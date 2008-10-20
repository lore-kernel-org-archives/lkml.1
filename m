Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbYJTSHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbYJTSHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 14:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYJTSHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 14:07:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:50394 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385AbYJTSH3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 14:07:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,453,1220252400"; 
   d="scan'208";a="393848953"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "ltt-dev@lists.casi.polymtl.ca" <ltt-dev@lists.casi.polymtl.ca>
Date: Mon, 20 Oct 2008 11:07:05 -0700
Subject: RE: [RFC patch 15/15] LTTng timestamp x86
Thread-Topic: [RFC patch 15/15] LTTng timestamp x86
Thread-Index: AckxQyh8bXSMGeBMQIe9AFo7wn5DqABmcSmg
Message-ID: <57C9024A16AD2D4C97DC78E552063EA353346068@orsmsx505.amr.corp.intel.com>
References: <20081016234657.837704867@polymtl.ca>
 <alpine.LFD.2.00.0810161701470.3288@nehalem.linux-foundation.org>
 <20081017012835.GA30195@Krystal>
 <57C9024A16AD2D4C97DC78E552063EA3532D455F@orsmsx505.amr.corp.intel.com>
 <20081017172515.GA9639@goodmis.org>
 <57C9024A16AD2D4C97DC78E552063EA3533458AC@orsmsx505.amr.corp.intel.com>
 <20081017184215.GB9874@Krystal>
 <57C9024A16AD2D4C97DC78E552063EA35334594F@orsmsx505.amr.corp.intel.com>
 <20081017202313.GA13597@Krystal>
 <57C9024A16AD2D4C97DC78E552063EA353345B9B@orsmsx505.amr.corp.intel.com>
 <20081018170118.GA22243@Krystal>
In-Reply-To: <20081018170118.GA22243@Krystal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And what do we say when we detect this ? "sorry, please upgrade your
> hardware to get a reliable trace" ? ;)

My employer might be happy with that answer ;-) ... but I think
we could tell the user to:

        1) adjust something in /sys/...
        2) boot with some special option
        3) rebuild kernel with CONFIG_INSANE_TSC=y

to switch over to a heavyweight workaround in s/w.  Systems
that require this are already in the minority ... and I
think (hope!) that current and future generations of cpus
won't have these challenges.

So this is mostly a campaign for the default code path to
be based on current (sane) TSC behaviour ... with the workarounds
for past problems kept to one side.

> Nope, this is not required. I removed the heartbeat event from LTTng two
> weeks ago, implementing detection of the delta from the last timestamp
> written into the trace. If we detect that the new timestamp is too far
> from the previous one, we write the full 64 bits TSC in an extended
> event header. Therefore, we have no dependency on interrupt latency to
> get a sane time-base.

Neat.  Could you grab the HPET value here too?


> (8 cores up)

Interesting results.  I'm not at all sure why HPET scales so badly.
Maybe some h/w throttling/synchronizing going on???

-Tony
