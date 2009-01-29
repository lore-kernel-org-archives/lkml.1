Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbZA2REh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbZA2REh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbZA2RE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:04:28 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:39220 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751558AbZA2RE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:04:27 -0500
Subject: Re: Vramfs: filesystem driver to utilize extra RAM on VGA devices
From: "Peter W. Morreale" <pmorreale@novell.com>
To: Jonathan Campbell <jon@nerdgrounds.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, devel@driverdev.osuosl.org,
       Linux Kernel List <linux-kernel@vger.kernel.org>
In-Reply-To: <497E4C5E.2030201@nerdgrounds.com>
References: <497E4531.20800@nerdgrounds.com> <497E4919.60907@zytor.com>
	 <497E4C5E.2030201@nerdgrounds.com>
Content-Type: text/plain
Organization: Linux Solutions Group
Date: Thu, 29 Jan 2009 17:04:09 +0000
Message-Id: <1233248649.7191.130.camel@hermosa.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-26 at 15:50 -0800, Jonathan Campbell wrote:
> vramfs is designed to take the memory range and directly turn it into a 
> usable filesystem.
> The structures are not actually in VRAM, but the file contents are.
> Vramfs has a builtin mechanism as described to avoid conflicting with 
> the region in use by the framebuffer console.
> 
> I don't really know about the mtd device, but I thought it would be good 
> kernel coding practice to write a filesystem driver to pull off a stunt 
> like that.
> 
> I also wrote this in consideration of the GPU which probably wouldn't 
> know how to handle the fragmentation that would inevitably happen if 
> ext3 needed to write blocks in a non-contiguous manner, this fs enforces 
> the rule that files are always unbroken with only a start and length.
> 

How do you accomplish that? 

(I haven't yet looked at your code...)

-PWM


> Also, doesn't mtd come in as a block device?
> So you'd have to format the memory region using a filesystem like ext3, 
> right?
> And as a block device you can't use mmap() to map that region directly 
> into your process space, right?
> > Jonathan Campbell wrote:
> >>
> >> So far I've tested it against 2.6.25.17 and 2.6.28 on both x86 and 
> >> x86_64 with reads, writes, directory creation, symlink creation, and 
> >> mmap() and it seems to work fine.
> >> Just give it a range of memory on the bus, or the 
> >> domain:bus:device:function numbers of a VGA PCI device, and it will 
> >> mount the VGA video RAM and allow files to exist there.
> >> As a special hack: you can also specify the size of the active 
> >> framebuffer console so that fbcon doesn't collide with this driver 
> >> (unless you want to see what your files look like splattered across 
> >> your screen, ha). The active VRAM area becomes a "sentinel" file 
> >> named "framebuffer".
> >>
> >> What do you guys think?
> >>
> >
> > How is this different from the MTD driver we already have?
> >
> >     -hpa
> > -- 
> > To unsubscribe from this list: send the line "unsubscribe 
> > linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> >
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel

