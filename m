Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbYFPQTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbYFPQTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 12:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbYFPQTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 12:19:46 -0400
Received: from atlantis.8hz.com ([212.129.237.78]:64702 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776AbYFPQTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 12:19:45 -0400
Date: Mon, 16 Jun 2008 16:19:44 +0000
From: Sean Young <sean@mess.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, "H. Anvin" <hpa@zytor.com>
Subject: Re: Regression: boot failure on AMD Elan TS-5500
Message-ID: <20080616161944.GA53539@atlantis.8hz.com>
References: <20080616121138.GA51097@atlantis.8hz.com> <200806162327.34912.rusty@rustcorp.com.au> <48566C88.6000702@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48566C88.6000702@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 06:37:12AM -0700, Jeremy Fitzhardinge wrote:
> Rusty Russell wrote:
> >On Monday 16 June 2008 22:11:39 Sean Young wrote:
> >  
> >>The symptons are either a crash or reboot on booting the kernel. No
> >>printk's have occurred yet -- even with early printk on.
> >>
> >>2.6.15 worked on this board however current does not. I've bisected it to:
> >>
> >>	commit a24e785111a32ccb7cebafd24b1b1cb474ea8e5d
> >>	Author: Rusty Russell <rusty@rustcorp.com.au>
> >>	Date:   Sun Oct 21 16:41:35 2007 -0700
> >>
> >>	    i386: paravirt boot sequence
> >>    
> >
> >Hi Sean,
> >
> >   Thanks for tracking this down.  Can we try reverting this in pieces to 
> >   see exactly what the cause was?
> >
> >1) Revert arch/x86/boot/compressed/head_32.S
> >2) If that doesn't fix it, Try removing the 8 lines which were added to 
> >arch/x86/kernel/head_32.S
> >  
> And the arch/x86/boot/compressed/misc_32.c change too, just in case...

Reverting only head_32.S makes the problem go away. I didn't try any other
changes.

> >I assume this is CONFIG_PARAVIRT=n?

Indeed.

> What bootloader does this platform use?  I wonder if it's setting things 
> up in an unexpected way?

It's syslinux. That must be the culprit, considering the change to head_32.S.

I'm digging in syslinux right now. 

Thanks
Sean
