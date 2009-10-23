Return-Path: <linux-kernel-owner+w=401wt.eu-S1752413AbZJWP4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbZJWP4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 11:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbZJWP4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 11:56:36 -0400
Received: from smtp.nokia.com ([192.100.105.134]:18262 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbZJWP4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 11:56:35 -0400
Subject: Re: [PATCH v11 4/5] core: Add kernel message dumper to call on
	oopses and panics
From: "Shargorodsky Atal (EXT-Teleca/Helsinki)" 
	<ext-atal.shargorodsky@nokia.com>
To: ext Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Artem Bityutskiy <dedekind1@gmail.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20091022082500.602f9a7d@marrow.netinsight.se>
References: <20091015093133.GF10546@elte.hu>
	 <20091015161052.0752208e@marrow.netinsight.se>
	 <20091015154640.GA11408@elte.hu>
	 <20091016094601.4e2c2d3e@marrow.netinsight.se>
	 <20091016080935.GA3895@elte.hu>	<1255681467.32489.360.camel@localhost>
	 <20091016112556.6902b2dc@marrow.netinsight.se>
	 <20091016101045.GA3263@elte.hu>
	 <20091016140918.3981cfa2@marrow.netinsight.se>
	 <1255952922.32489.505.camel@localhost>	<20091019125017.GA9030@elte.hu>
	 <alpine.LFD.2.00.0910220832580.9771@eeepc.linux-foundation.org>
	 <20091022082500.602f9a7d@marrow.netinsight.se>
Content-Type: text/plain
Date: Fri, 23 Oct 2009 18:53:22 +0300
Message-Id: <1256313202.5824.60.camel@atal-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Oct 2009 15:55:03.0382 (UTC) FILETIME=[2EFDAF60:01CA53F9]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Thu, 2009-10-22 at 08:25 +0200, ext Simon Kagstrom wrote:

> Thanks to everyone for the reviewing and suggestions!
> 

I have a couple of questions:

1. If somebody writes a module that uses dumper for uploading the
oopses/panics logs via some pay-per-byte medium,  since he has no way
to know in a module if the panic_on_oops flag is set, he'll have
to upload both oops and the following panic, because he does not
know for sure that the panic was caused by the oops. Hence he
pays twice for the same information, right?

I can think of a couple of way to figure it out in the module
itself, but I could not think of any clean way to do it.


2. We tried to use panic notifiers mechanism to print additional
information that we want to see in mtdoops logs and it worked well,
but having the kmsg_dump(KMSG_DUMP_PANIC) before the
atomic_notifier_call_chain() breaks this functionality.
Can we the call kmsg_dump() after the notifiers had been invoked?


Thanks,
Atal.

> // Simon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

