Return-Path: <linux-kernel-owner+w=401wt.eu-S1760795AbXKDMLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760795AbXKDMLk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 07:11:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759622AbXKDMLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 07:11:25 -0500
Received: from ozlabs.org ([203.10.76.45]:59639 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758418AbXKDMLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 07:11:24 -0500
From: Michael Neuling <mikey@neuling.org>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
cc: "Paul Mackerras" <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Restore deterministic CPU accounting on powerpc 
In-reply-to: <661de9470711030202x24d0186cuc96a70156ecfa23f@mail.gmail.com> 
References: <18218.44089.274628.680088@cargo.ozlabs.ibm.com> <661de9470711030202x24d0186cuc96a70156ecfa23f@mail.gmail.com>
Comments: In-reply-to "Balbir Singh" <balbir@linux.vnet.ibm.com>
   message dated "Sat, 03 Nov 2007 14:32:59 +0530."
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 21.4.1
Date: Sun, 04 Nov 2007 23:11:27 +1100
Message-ID: <30600.1194178287@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +#ifndef CONFIG_VIRT_CPU_ACCOUNTING
> > +void account_process_tick(int user_tick)
> > +{
> > +       if (user_tick) {
> > +               account_user_time(p, jiffies_to_cputime(1));
> > +               account_user_time_scaled(p, jiffies_to_cputime(1));
> > +       } else {
> > +               account_system_time(p, HARDIRQ_OFFSET, jiffies_to_cputime(1
));
> > +               account_system_time_scaled(p, jiffies_to_cputime(1));
> > +       }
> > +}
> > +#endif
> > +
> 
> Hi, Paul,
> 
> So, scaled accounting will not be available if
> CONFIG_VIRT_CPU_ACCOUNTING is defined? Am I reading this correctly

Balbir, 

Paulus' patch will have merge issues with the scaled time cleanup patch
I posted a week or so back.  My cleanup patch is only in akpm's tree at
this stage.

Mikey
