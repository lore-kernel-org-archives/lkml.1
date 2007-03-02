Return-Path: <linux-kernel-owner+w=401wt.eu-S1422811AbXCBFWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422811AbXCBFWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 00:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422813AbXCBFWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 00:22:48 -0500
Received: from gundega.hpl.hp.com ([192.6.19.190]:50869 "EHLO
	gundega.hpl.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422811AbXCBFWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 00:22:47 -0500
Date: Thu, 1 Mar 2007 21:18:06 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Uwe Bugla <uwe.bugla@gmx.de>, torvalds@linux-foundation.org,
       linux-dvb@linuxtv.org, domi.dumont@free.fr,
       Jiri Slaby <jirislaby@gmail.com>, bunk@stusta.de,
       linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: patch 3 / 3: fix floppy mount bug in kernel 2.6.21-rc1
Message-ID: <20070302051806.GA25921@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070301143222.263070@gmx.net> <20070301164742.d9be02d7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301164742.d9be02d7.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Thu, Mar 01, 2007 at 04:47:42PM -0800, Andrew Morton wrote:
> On Thu, 01 Mar 2007 15:32:22 +0100
> "Uwe Bugla" <uwe.bugla@gmx.de> wrote:
> 
> > Hi folks,
> > this patch fixes the floppy mount bug (i. e. regression) in kernel 2.6.21-rc1. It was inspired by Stephane Eranian. It was tested on an Intel P4 1800 MHz
> > (Intel ICH4 chipset) and on an AMD Athlon XP 1800 MHz (Silicon Integrated Systems chipset 740, 5513).
> > My deep thanks and respect go to:
> > Stephane Eranian, Linus Torvalds, Jiri Slaby. You are truthfully real men and reliable, accurate, fine chaps. It feels great to have you in this world-wide community!
> > Would you still call the whole i386 architecture "a small number of machines", Mister Andrew Morton? If yes, in how far please?
> > 
> > Signed-off-by: Uwe Bugla <uwe.bugla@gmx.de>
> > 
> > --- a/arch/i386/kernel/process.c
> > +++ b/arch/i386/kernel/process.c
> > @@ -154,6 +154,7 @@
> >  		current_thread_info()->status |= TS_POLLING;
> >  	} else {
> >  		/* loop is done by the caller */
> > +		local_irq_enable();
> >  		cpu_relax();
> >  	}
> >  }
> 
> Linus reverted the offending patch "[PATCH] i386: add idle notifier"
> on Feb 26, so this fix should no longer be needed, and 2.6.21-rc2 should
> be working again.
> 
> Hopefully Stephane will fold this fix into any future version of that patch,
> if appropriate.

Well, given that nobody really liked this idle notifier, I am trying to do
differently on all architectures which unfortunately is not an easy thing
to do.

What I did not really like in all of this is that people come up with
arguments without providing the data to prove it, e.g., increase interrupt
latency (by how much?).

-- 
-Stephane
