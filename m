Return-Path: <linux-kernel-owner+w=401wt.eu-S932167AbXDNNCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbXDNNCe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 09:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932192AbXDNNCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 09:02:33 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:51710 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbXDNNCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 09:02:33 -0400
X-Originating-Ip: 24.6.145.253
Date: Sat, 14 Apr 2007 09:01:06 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: {Spam?} Re: [PATCH][RFC] Kill off legacy power management stuff.
In-Reply-To: <20070413183054.08ca0dff.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0704140855270.10740@localhost.localdomain>
References: <Pine.LNX.4.64.0704122025380.3628@CPE00045a9c397f-CM001225dbafb6>
 <20070413180942.b7cf0665.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0704130416250.15118@CPE00045a9c397f-CM001225dbafb6>
 <20070413183054.08ca0dff.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: spam, SORBS-DUL,
	SpamAssassin (not cached, score=-12.808, required 5,
	ALL_TRUSTED -1.80, BAYES_00 -15.00, RCVD_IN_NJABL_DUL 1.95,
	RCVD_IN_SORBS_DUL 2.05)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007, Stephen Rothwell wrote:

> On Fri, 13 Apr 2007 04:20:10 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:
> >
> > On Fri, 13 Apr 2007, Stephen Rothwell wrote:
> > >
> > > One thing that comes to mind is that you will need some way to
> > > make sure that only one of ACPI and APM get initialized ...
> >
> > i don't see how that has anything to do with removing legacy PM
> > support.  you can select both ACPI and APM *now*.  if that's a bad
> > thing, then fixing it is a completely independent issue.
>
> Except your patch removes this hunk:
>
> @@ -2264,14 +2248,6 @@ static int __init apm_init(void)
>  		apm_info.disabled = 1;
>  		return -ENODEV;
>  	}
> -	if (PM_IS_ACTIVE()) {
> -		printk(KERN_NOTICE "apm: overridden by ACPI.\n");
> -		apm_info.disabled = 1;
> -		return -ENODEV;
> -	}
> -#ifdef CONFIG_PM_LEGACY
> -	pm_active = 1;
> -#endif
>
> in apm.c and a similar piece of the ACPI initialisation that
> prevented one initialising if the other had already initialised.

ah, just took a closer look at this.  from <linux/pm_legacy.h>:
...
#ifdef CONFIG_PM_LEGACY
...
#else
#define PM_IS_ACTIVE() 0
...
#endif

so if you choose not to configure legacy PM, that macro equates to
false and that "if" construct in arch/i386/kernel/apm.c doesn't come
into play, anyway.

so i re-iterate what i posted in my earlier e-mail -- if APM and ACPI
want to avoid clashing, they have to do it without invoking anything
related to legacy PM.

rday

p.s.  if someone wants to take that previously-submitted patch
proposal and tidy it up and submit it officially, feel free.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
