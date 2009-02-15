Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbZBOVJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbZBOVJt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 16:09:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZBOVJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 16:09:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48125 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbZBOVJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 16:09:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [Bug #12617] unable to compile e100 firmware into kernel
Date: Sun, 15 Feb 2009 22:09:24 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <1234719496.4738.19.camel@macbook.infradead.org> <200902152259.00244.arvidjaar@mail.ru>
In-Reply-To: <200902152259.00244.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902152209.25361.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 February 2009, Andrey Borzenkov wrote:
> On 15 of February 2009 20:38:15 David Woodhouse wrote:
> > On Sat, 2009-02-14 at 21:38 +0100, Rafael J. Wysocki wrote:
> > >  This message has been generated automatically as a part of a
> > > report of recent regressions.
> > >
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.28.  Please verify if it still should be listed and let me
> > > know (either way).
> > >
> > >
> > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12617
> > > Subject         : unable to compile e100 firmware into kernel
> > > Submitter       : Andrey Borzenkov <arvidjaar@mail.ru>
> > > Date            : 2009-01-31 15:59 (15 days old)
> > > References      :
> > > http://marc.info/?l=linux-kernel&m=123341764915181&w=4
> >
> > I thought this was resolved?
> 
> I guess it has to be closed. This was caused by config options mismatch 
> and I do not see how we can programmatically express "this device could 
> be required before any (even early) user space is available, so make 
> sure everything that this device needs is built in".
> 
> One possibility is following:
> 
> --- drivers/base/Kconfig.orig 2009-01-17 14:46:28.000000000 +0300
> +++ drivers/base/Kconfig        2009-02-15 22:57:02.000000000 +0300
> @@ -37,7 +37,7 @@ config FW_LOADER
> 
>  config FIRMWARE_IN_KERNEL
>         bool "Include in-kernel firmware blobs in kernel binary"
> -       depends on FW_LOADER
> +       depends on FW_LOADER = y
>         default y
>         help
>           The kernel source tree includes a number of firmware 'blobs'
> 
> On assumption that compiling firmware in kernel makes no sense as long 
> as kernel does not even have facility to actually access it.
> 
> Does it make sense?

Guess so.

I've closed the bug.

Thanks,
Rafael
