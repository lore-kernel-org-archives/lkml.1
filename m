Return-Path: <linux-kernel-owner+w=401wt.eu-S1760030AbZEFSQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030AbZEFSQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 14:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbZEFSQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 14:16:14 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34723 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbZEFSQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 14:16:13 -0400
Date: Wed, 6 May 2009 14:03:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Greg KH <greg@kroah.com>
Cc: Eric Valette <eric.valette@free.fr>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: DMA debug trace pointing to rtl8187
Message-ID: <20090506180353.GD30070@tuxdriver.com>
References: <49FDB9F8.3080400@free.fr> <20090506133131F.fujita.tomonori@lab.ntt.co.jp> <4A012FC8.3020304@free.fr> <20090506064513.GA7460@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506064513.GA7460@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 11:45:13PM -0700, Greg KH wrote:
> On Wed, May 06, 2009 at 08:35:52AM +0200, Eric Valette wrote:
> > FUJITA Tomonori wrote:
> > > CC'ed linux-usb,
> > > 
> > > The ehci_hcd driver uses buffers on the stack for DMA?
> > > 
> > > On Sun, 03 May 2009 17:36:24 +0200
> > > Eric Valette <eric.valette@free.fr> wrote:
> > > 
> > >> ------------[ cut here ]------------
> > >>
> > >> WARNING: at /usr/src/linux-2.6.22.9/lib/dma-debug.c:609
> > > 
> > > Hmm, the kernel version is wired. lib/dma-debug.c was added in
> > > 2.6.30-rc.
> > 
> > No that's the file path.  I use ketchup to apply patches...
> > 
> > > 
> > >> check_for_stack+0x6b/0x8b()
> > >> Hardware name: P5W DH Deluxe
> > >>
> > >> ehci_hcd 0000:00:1d.7: DMA-API: device driver maps memory fromstack
> > >> [addr=ffff88007fa79968]
> > >> Modules linked in:
> > >>
> > >> Pid: 297, comm: khubd Not tainted 2.6.30-rc4-git1 #32
> > 
> > Here is the real version.
> 
> The problem is in the rtl8187 driver.
> 
> They are calling usb_control_msg and passing a pointer to a buffer on
> the stack.  See drivers/net/wireless/rtl818x/rtl8187.h for where the
> problem happens in numerous places.
> 
> Also it looks like rtl8225_write_8051() is incorrect.  You are passing a
> pointer to a variable that was passed as an argument.  I don't know
> where that is supposed to be on, somewhere on the stack I guess.
> 
> Larry, care to fix this up?

I just sent '[RFT] rtl8187: use DMA-aware buffers with usb_control_msg'
as a parallel reply to this message.  It is pretty ugly w.r.t. kmalloc
failures, but it might be worth testing just to see if it helps the
problem at hand...?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
