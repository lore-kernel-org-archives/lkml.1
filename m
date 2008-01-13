Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYAMWDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYAMWDl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 17:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbYAMWDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 17:03:32 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33110 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753885AbYAMWDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 17:03:31 -0500
Date: Sun, 13 Jan 2008 23:03:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>, akpm@osdl.org,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: remove "too much work for irq" printk
Message-ID: <20080113220327.GB5128@elf.ucw.cz>
References: <20080112201543.GB12775@kvack.org> <20080112212457.3bf534af@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112212457.3bf534af@lxorguk.ukuu.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-01-12 21:24:57, Alan Cox wrote:
> On Sat, 12 Jan 2008 15:15:43 -0500
> Benjamin LaHaise <bcrl@kvack.org> wrote:
> 
> > When using kvm with a serial console, the serial driver will print out 
> > "too much work for irq4" on any heavy activity (ie vi on a file repainting 
> > the terminal).  This message is entirely spurious, as output continues to 
> > work fine.  Remove the message as it corrupts screen output and is far too 
> > easy to trigger.
> 
> NAK. This is a qemu/kvm emulation bug. The real check is there to catched
> jammed IRQs and combined with the IRQ bug handling nowdays does actually
> do the intended job.
> 
> Our serial port code (correctly) interprets a continuous stream of bytes
> at an impossible bit rate as an error. KVM should be emulating to some
> extent at least the timing on serial interfaces or using a virtualised
> interface.

How can you tell apart impossible bit rate from really slow CPU, or
maybe just an SMI storm, or heavy busmaster DMA?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
