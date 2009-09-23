Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193AbZIWVkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbZIWVkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 17:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbZIWVkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 17:40:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45063 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbZIWVkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 17:40:06 -0400
Date: Wed, 23 Sep 2009 23:39:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Len Brown <lenb@kernel.org>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [origin tree boot hang] [PATCH] Revert "early_printk:
	Allowmorethan one early console"
Message-ID: <20090923213929.GA20204@elte.hu>
References: <20090923135539.GA6542@kroah.com> <20090923173709.GA18056@elte.hu> <4ABA6182.1000106@windriver.com> <20090923190239.GC24251@elte.hu> <20090923191756.GA25163@elte.hu> <20090923210555.GA13492@elte.hu> <4ABA90C6.3000600@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABA90C6.3000600@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Wessel <jason.wessel@windriver.com> wrote:

> Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >
> >
> >   
> >> The commit point to which the attached config and bootlog belongs is:
> >>
> >>   2.6.31-07863-gb64ada6
> >>
> >> Reverting:
> >>
> >>   c953094: early_printk: Allow more than one early console
> >>
> >> solves it.
> >>     
> >
> > btw., the boot options are:
> >
> > Command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 debug
> > initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel 
> > selinux=0 nmi_watchdog=0 panic=1 3
> >
> >   
> 
> AH HA!
> 
> earlyprintk=serial,ttyS0,115200
> 
> You are invoking the same device twice which is why you are having 
> infinite recursion.  It was not obvious to me why the earlyprintk code 
> would allow "serial" or "ttyS", but perhaps we need to protect for 
> that?
> 
> Your boot line should be:
> 
> earlyprintk=serial,115200
> 
> OR
> 
> earlyprintk=ttyS0,115200

ah, indeed!

> The line you had there before would have been the equivalent of doing:
> 
> earlyprintk=ttyS0,ttyS0,115200
> 
> Given this, do we still need to execute the revert your revert?  Or 
> perhaps do we need to add some protection?

I have such lines on other boxes too. I'd suggest to add protection if 
it's not too ugly - the typoed line worked and was pretty natural to do, 
and the failure mode is nasty enough.

	Ingo
