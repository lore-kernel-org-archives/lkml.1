Return-Path: <linux-kernel-owner+w=401wt.eu-S1759395AbYJJMi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395AbYJJMi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 08:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbYJJMiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 08:38:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:23435 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459AbYJJMit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 08:38:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qzuRcLWWwMnWabPA6yxizx+uzi/VcCxyl0HxCej9isS76T2EdKODMqZlfQVZczrNHz
         9OuaKgITOOlfFCJkTGe/1wE6SN3LLl7JYx42iql9DDTuX4TTyVHrfwPO3sunpejjyVyR
         hMAkX4jrtlAb/HNpv8uAA41FOb7RHqt0gFcSc=
Date: Fri, 10 Oct 2008 16:38:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Typo in x86 apic.c with DIVISOR setup
Message-ID: <20081010123838.GB7328@localhost>
References: <20081010002203.GA23238@linux-os.sc.intel.com> <aa79d98a0810092138q1f27a94bhd544ca3637c02c4f@mail.gmail.com> <7E82351C108FA840AB1866AC776AEC463782339F@orsmsx505.amr.corp.intel.com> <aa79d98a0810092239p32153776qd0cda47e54929545@mail.gmail.com> <20081010090100.GC319@elte.hu> <aa79d98a0810100416q72ec10d5q7d841e02dc4d4f81@mail.gmail.com> <alpine.LFD.1.10.0810101221580.19747@ftp.linux-mips.org> <20081010115655.GC19487@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010115655.GC19487@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Fri, Oct 10, 2008 at 01:56:55PM +0200]
| 
| * Maciej W. Rozycki <macro@linux-mips.org> wrote:
| 
| > On Fri, 10 Oct 2008, Cyrill Gorcunov wrote:
| > 
| > > Btw I don't remember but hope it was not me who made this typo --
| > 
| >  What would be the difference so that you hope it wasn't you?  All the 
| > people make mistakes, this one has been caught and that's what really 
| > matters.
| 
| yeah, like most kernel newbies Cyrill is worrying way too much about 
| mistakes. In 10 years time he too will have his healthy collection of 
| embarrassing brown paperbag incidents and will be a lot more relaxed 
| about it, just like the rest of us ;-)
| 
| what matters is to fix them quickly and to learn from those mistakes 
| that are avoidable.
| 
| 	Ingo
| 

Just brought first paperbag -- usefull thing I've to say :)
...

ok, what the conclusion will be on divisor side? I think
something like that maybe. Maciej?

		- Cyrill -

---

Index: linux-2.6.git/arch/x86/kernel/apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic.c	2008-09-26 20:43:47.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic.c	2008-10-10 16:37:26.000000000 +0400
@@ -332,11 +332,7 @@ int lapic_get_maxlvt(void)
  */
 
 /* Clock divisor */
-#ifdef CONFG_X86_64
-#define APIC_DIVISOR 1
-#else
 #define APIC_DIVISOR 16
-#endif
 
 /*
  * This function sets up the local APIC timer, with a timeout of
@@ -592,10 +588,10 @@ static int __init calibrate_APIC_clock(v
 	global_clock_event->event_handler = lapic_cal_handler;
 
 	/*
-	 * Setup the APIC counter to 1e9. There is no way the lapic
+	 * Setup the APIC counter to maximum. There is no way the lapic
 	 * can underflow in the 100ms detection time frame
 	 */
-	__setup_APIC_LVTT(1000000000, 0, 0);
+	__setup_APIC_LVTT(0xffffffff, 0, 0);
 
 	/* Let the interrupts run */
 	local_irq_enable();
