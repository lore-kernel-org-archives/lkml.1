Return-Path: <linux-kernel-owner+w=401wt.eu-S1757049AbZBRVQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbZBRVQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbZBRVQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:16:15 -0500
Received: from 1wt.eu ([62.212.114.60]:2329 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbZBRVQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:16:14 -0500
Date: Wed, 18 Feb 2009 22:09:17 +0100
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alain Knaff <alain@knaff.lu>, Ingo Molnar <mingo@elte.hu>,
       Jan Engelhardt <jengelh@medozas.de>,
       the arch/x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
Message-ID: <20090218210917.GQ5038@1wt.eu>
References: <496142E4.8040308@zytor.com> <49614491.7020903@knaff.lu> <49614D1F.8020900@zytor.com> <alpine.LSU.2.00.0902172202230.5620@fbirervta.pbzchgretzou.qr> <499B267E.2090509@zytor.com> <20090217220825.GA24337@elte.hu> <20090217233708.GA10756@elte.hu> <499B5BCA.8000905@zytor.com> <499BBD62.5090506@knaff.lu> <499C670F.9090203@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499C670F.9090203@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 11:52:47AM -0800, H. Peter Anvin wrote:
> Alain Knaff wrote:
> >
> >Maybe another solution would be to make the choice of builtin ramdisk
> >compression user-selectable, and default to no compression at all.
> >
> 
> That might just make most sense.
> 
> >Indeed, in the default case, the builtin ramdisk is so small (950 bytes
> >uncompressed), that it probably wouldn't really matter anyways.
> >
> >The only case where it matters is for developers of embedded systems who
> >want to replace the builtin ramdisk with a fully populated one, because
> >their boot loader does not support loading a "normal" initrd.
> >
> >These people are (hopefully) knowledgeable enough to pick an appropriate
> >compressor (but there's still the issue of notifying them about the
> >change, obviously).
> >
> >Btw, what *is* the standard work flow of supplying your own built-in
> >initramfs? Do such developers usually supply a directory tree, or do
> >they already cpio it before supplying it to the kernel? Or do they even
> >compress it themselves?
> 
> The normal thing is that you point the kernel build to an 
> out-of-the-kernel-build-tree directory.

FWIW I'm personally used to include my kernel's modules into its own
initramfs, so that I can have a common generic rootfs image in a
separate initrd and multiple kernels using the same initrd. This
allows me to easily and quickly boot full-featured kernels from CD,
USB sticks or even PXE, load modules depending on my usages, and
only have to care about some kernel build options (typically SMP/UP)
without having to repackage anything in the root fs. This brings me
the best of modules and monolithic kernels, and that's very convenient.

The build process is not trivial, as I have to proceed in two steps
to package the kernel's own modules into the initramfs before building
the final vmlinux. But scripts make that easier.

Willy

