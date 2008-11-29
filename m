Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYK2BWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYK2BWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 20:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYK2BV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 20:21:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:58587 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbYK2BV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 20:21:58 -0500
Date: Fri, 28 Nov 2008 17:23:00 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] usb/serial: Add compat_ioctl pass-through
Message-ID: <20081128172300.0e30229e@infradead.org>
In-Reply-To: <20081129011057.14840d20@lxorguk.ukuu.org.uk>
References: <200811281642.52637.arnd@arndb.de>
	<1227911282-8857-1-git-send-email-keithp@keithp.com>
	<20081128223305.2d11f8d9@lxorguk.ukuu.org.uk>
	<1227920556.4277.128.camel@aiko.keithp.com>
	<20081129011057.14840d20@lxorguk.ukuu.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Nov 2008 01:10:57 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Oh yes, it is -- serial_ioctl does:
> > 
> >         if (port->serial->type->ioctl) {
> >                 lock_kernel();
> >                 retval = port->serial->type->ioctl(tty, file, cmd,
> > arg); unlock_kernel();
> >         } else
> > 
> > I added the comment to make the difference in calling convention
> > documented in the header file at least, I didn't change the code.
> 
> Gak I thought I'd killed all of those.
> 
> Let me rephase it "It won't be next week" ;)

it's a double BKL since it's also using .ioctl not .unlocked_ioctl
(but then again we should just over time merge the two into a .ioctl
which is unlocked ;-)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
