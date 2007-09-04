Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbXIDIxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbXIDIxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 04:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbXIDIw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 04:52:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:36679 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbXIDIw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 04:52:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SAlqPudqKObpVA2qv1DhCESP2GT2EAadzn6GBMKGxkH76E746jM/ocIhgJytqOU4JvH4SN++duBLGT+xDDOX5j4i42vXpYLm2qVeek25vI8da9hQkomecQc4QUuXmj8KePEkbeRQlIO7PSnlqcV+El6X9p7HBCjHT6x28FDb87Q=
Message-ID: <ab40e9c0709040152v5019a6abi2f18182623115ef@mail.gmail.com>
Date: Tue, 4 Sep 2007 10:52:55 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: "Bill Davidsen" <davidsen@tmr.com>
Subject: Re: ramdisk
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <46DC9700.7070208@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab40e9c0709030604u5fecf34dr945ece01b95e622d@mail.gmail.com>
	 <46DC2228.7080503@tmr.com>
	 <ab40e9c0709031003h72901a45wafc8697f086af477@mail.gmail.com>
	 <46DC9700.7070208@tmr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bill,

OK I will try it.
Thanks,

2007/9/4, Bill Davidsen <davidsen@tmr.com>:
> Xu Yang wrote:
> > thanks for the reply.
> >
> > no , it is not decompressed. isn' t the kernel supposed to do that? As
> > we have tried to load this filesystem on the pc, it turns out the the
> > kernel can recognize it.
> >
> > concerning the root=/dev/ram0,
> > as the default value is root=/dev/nfs, so I just modify the nfs to
> > ram0. is this might be a problem?
> >
> >
> Hopefully someone who works with this regularly can provide some
> answers, the only time I used booting into a RAM-only system the tools
> which I had "just worked" and I followed the steps outlined without
> fully understanding the details. However, I just tried loop mounting a
> compressed filesystem and that didn't work, while decompressing into a
> ramdisk and mounting worked fine. That's why I asked if your tool was
> just copying to RAM without decompression, since I have no ides what
> tool you use.
>
> As for the name, your original post used "dev" without a leading "/" and
> while I assumed it was a typo, I thought it was worth mentioning since
> you were looking for suggestions. I would expect /dev/ram0 to be correct.
>
> I would try the decompressed image next, and I have no other ideas at
> the moment.
> > regards,
> >
> >
> > 2007/9/3, Bill Davidsen <davidsen@tmr.com>:
> >
> >> Xu Yang wrote:
> >>
> >>> Hi everyone,
> >>>
> >>> I want to use ramdisk to boot my filesystem, as I can't use NFS and harddisk.
> >>>
> >>> I have load the ramdisk into the ram memory (start address :0x4000000)
> >>>
> >>> and in the boot options I specified : root =dev/ram0 initrd=0x4000000
> >>>
> >>> but the kernel said it can not find any file system on it.
> >>>
> >>>
> >> Looking at the information below, did the program which loaded the
> >> filesystem into RAM decompress it? It noted that it was compressed so I
> >> would assume so, but I am unfamiliar with ARM tools, so I ask the
> >> question. Also, should the boot device be "/dev/ram0" rather than
> >> "dev/ram0" or is that correct for your system?
> >>
> >>
> >>> Here is the information I can supply :
> >>> U-Boot 1.2.0 (Aug 31 2007 - 20:54:55)
> >>>
> >>> ***  Auto-detects ethernet chip ***
> >>>
> >>>
> >>>
> >>> DRAM:   0 kB
> >>> ## Unknown FLASH on Bank 1 - Size = 0x00000000 = 0 MB
> >>> Flash:  0 kB
> >>> *** Warning - bad CRC, using default environment
> >>>
> >>> In:    serial
> >>> Out:   serial
> >>> Err:   serial
> >>>
> >>> Hit any key to stop autoboot:  0
> >>> ## Booting image at 00007fc0 ...
> >>>    Image Name:   Linux-2.6.19-arm2
> >>>    Image Type:   ARM Linux Kernel Image (uncompressed)
> >>>    Data Size:    740372 Bytes = 723 kB
> >>>    Load Address: 00008000
> >>>    Entry Point:  00008000
> >>> OK
> >>>
> >>>
> >>> ## Loading Ramdisk Image at 04000000 ...
> >>>    Image Name:   ramdisc
> >>>    Image Type:   ARM Linux RAMDisk Image (gzip compressed)
> >>>    Data Size:    12582962 Bytes = 12 MB
> >>>    Load Address: 04000000
> >>>    Entry Point:  04000000
> >>>
> >>> Starting kernel ...
> >>>
> >>>
> >>> .........................................................................................
> >>>
> >>> RAMDISK driver initialized: 16 RAM disks of 10240K size 1024 blocksize
> >>> <6>loop: loaded (max 8 devices)
> >>> <6>mice: PS/2 mouse device common for all mice
> >>> <6>VFP support v0.3: implementor 41 architecture 1 part 20 variant b rev 3
> >>> No filesystem could mount root, tried:  ext2 cramfs vfat
> >>> <0>Kernel panic - not syncing: VFS: Unable to mount root fs on
> >>> unknown-block(1,0)
> >>>
> >>>
> >>> Who can give me some hints ? or point me some direction to handle this.
> >>>
> >>> I appreciate this very much.
> >>>
> >>> regards,
> >>>
> >>> Yang
> >>>
> >> --
> >> Bill Davidsen <davidsen@tmr.com>
> >>   "We have more to fear from the bungling of the incompetent than from
> >> the machinations of the wicked."  - from Slashdot
> >>
> >>
> >
> >
>
>
> --
> bill davidsen <davidsen@tmr.com>
>  CTO TMR Associates, Inc
>  Doing interesting things with small computers since 1979
>
>
