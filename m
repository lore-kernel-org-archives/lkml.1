Return-Path: <linux-kernel-owner+w=401wt.eu-S1758477AbYJVTDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477AbYJVTDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbYJVTDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:03:41 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:36021 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbYJVTDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:03:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wmiS7eZqkEszWrUKYQ8SSIsfcrILUGnUABpj0CsatDRklOdA8NYTH67Y7sm3ojLg7f
         YZ2MchMgVpKURRYvN//QUbZrdMsUf1ZWgcDQUvYgDUV1dxcELwdjqRD1x1scnJwlxScn
         qNsRecCOgcfmFO7/1nF7+570P3/kE+RMq1ya4=
Message-ID: <8bd0f97a0810221203k1adaeec8xe4c47295dc823264@mail.gmail.com>
Date: Wed, 22 Oct 2008 15:03:35 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bodo Eggert" <7eggert@gmx.de>
Subject: Re: [PATCH] use tmpfs for rootfs v3
Cc: jeffschroeder@computer.org, "Geert Uytterhoeven" <geert@linux-m68k.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LSU.0.999.0810202006050.5225@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LSU.0.999.0810161400160.5456@be1.lrz>
	 <Pine.LNX.4.64.0810161507130.25933@anakin>
	 <alpine.LSU.0.999.0810161936590.5051@be1.lrz>
	 <c24352ca0810161403r1842185bg2f8b4f8c067af541@mail.gmail.com>
	 <alpine.LSU.0.999.0810171313550.4828@be1.lrz>
	 <8bd0f97a0810191112v29ca6be9kf4b0b8ecca718ef8@mail.gmail.com>
	 <alpine.LSU.0.999.0810202006050.5225@be1.lrz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 14:13, Bodo Eggert wrote:
> On Sun, 19 Oct 2008, Mike Frysinger wrote:
>> On Fri, Oct 17, 2008 at 07:16, Bodo Eggert wrote:
>> > --- linux-2.6.27.2-numlock/fs/Kconfig   2008-10-10 13:18:34.000000000 +0200
>> > +++ linux-2.6.27.3-tmpfs/fs/Kconfig     2008-10-11 15:42:21.000000000 +0200
>> > @@ -953,6 +953,27 @@ config TMPFS_POSIX_ACL
>> >
>> >          If you don't know what Access Control Lists are, say N.
>> >
>> > +config TMPFS_ROOT
>> > +       bool "Use tmpfs instrad of ramfs for initramfs"
>> > +       depends on TMPFS && SHMEM
>> > +       default n
>> > +       help
>> > +         This replaces the ramfs used for unpacking the cpio images
>> > +         with tmpfs.
>> > +
>> > +         If unsure, say N
>>
>> this should be init/Kconfig and depend on BLK_DEV_INITRD i think.  and
>> then update the comment to talk about the initial filesystem rather
>> than cpio images.
>
> Maybe, but then you'd have to go to filesystems->pseudo-fs to enable tmpfs,
> then to i-don't-remember to set it as the rootfs, and then back to
> fs->pseudo-fs to unselect ramfs.
>
> Thinking of it as a tmpfs option makes it much easier to use.

i guess that works

>> > +config RAMFS
>> > +       bool "Ramfs file system support" if TMPFS_ROOT
>>
>> if you have initramfs support disabled, then you should be able to
>> disable RAMFS as well.  so perhaps the depend should read like:
>> if BLK_DEV_INITRD && TMPFS_ROOT || !BLK_DEV_INITRD
>
> No, since a kernel not having initcpio support will mount rootfs anyway,

we should get that fixed then

> create some directories and special files and use them to open the console
> and to mount the real root into.

erm, i dont recall seeing any init code create any directories or
files.  opening /dev/console doesnt require the fake rootfs, nor does
mounting the real root on top of it.  where exactly do you see this
logic ?
-mike
