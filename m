Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbZHROBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbZHROBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 10:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZHROBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 10:01:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60379 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbZHROBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 10:01:43 -0400
Subject: RE: [PATCH] perf_counter: Fix a race on perf_counter_ctx
From: Peter Zijlstra <peterz@infradead.org>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EC1CB77C8@irsmsx504.ger.corp.intel.com>
References: <928CFBE8E7CB0040959E56B4EA41A77EC1BFEFEB@irsmsx504.ger.corp.intel.com>
	 <20090807103127.GA23139@elte.hu> <20090807103610.GA23728@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF02D@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF048@irsmsx504.ger.corp.intel.com>
	 <20090807112421.GB30014@elte.hu> <20090807113349.GA31673@elte.hu>
	 <1249667341.17467.5.camel@twins> <20090808120315.GA14086@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF464@irsmsx504.ger.corp.intel.com>
	 <20090810134608.GA8295@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF78D@irsmsx504.ger.corp.intel.com>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB7725@irsmsx504.ger.corp.intel.com>
	 <1250600348.7583.280.camel@twins> <1250600385.7583.281.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB7775@irsmsx504.ger.corp.intel.com>
	 <1250602664.7583.293.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1CB77C8@irsmsx504.ger.corp.intel.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 18 Aug 2009 16:01:31 +0200
Message-Id: <1250604091.7583.296.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-18 at 14:54 +0100, Metzger, Markus T wrote:

> Well, that would push out the limit a bit, but it would still be quite fragile.
> 
> Currently, I'm not sure that this (i.e. that the interrupt handling takes too long)
> is the underlying problem of the hangs that I'm seeing.
> 
> If it truly is, then I would go with the two-buffer approach. This would make the
> ISR itself predictably and reliably fast - at the expense of additional locked memory.

comment out that perf_counter_output() call and see what happens ;-)

> Do you think that this truly is the problem?
> How would the kernel react if interrupts were disabled for too long? I would definitely
> expect bad responsiveness, but can the kernel kill itself?

If we're branch tracing while processing the interrupt (not sure here),
then we might well generate enough output to generate a new interrupt,
causing back-to-back interrupts, basically DoSing the machine.


