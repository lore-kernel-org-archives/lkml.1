Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZAYMJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZAYMJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 07:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbZAYMJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 07:09:17 -0500
Received: from lucidpixels.com ([75.144.35.66]:45998 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbZAYMJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 07:09:16 -0500
Date: Sun, 25 Jan 2009 07:09:15 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
In-Reply-To: <20090125110742.4ba54c0b@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.1.10.0901250705300.6888@p34.internal.lan>
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan> <20090125110742.4ba54c0b@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 25 Jan 2009, Alan Cox wrote:

> Easiest is to use labels. Old ide will keep hda,b,c,d constant
> providing you have interfaces using the legacy IDE port mappings (0x1f0
> and 0x170). Libata doesn't do that as pretty much every distribution had
> already switched to volume labels, and the user space can do the job far
> better than the kernel - especially as the newer devices with modern
> interfaces don't have the old BIOS/DOS legacy ideas any more.
>
> Mount by label also means you can flip back and forth between the
> different drivers and kernel revisions.
>
> Alan
>

That works well with ext* filesystems as one can set it anytime with 
e2label if I recall; however, how can one do this with XFS, is it 
possible without booting off a boot-cd etc?

Here is the filesystem information:
p254:~# xfs_info /dev/sdd2
meta-data=/dev/root              isize=256    agcount=16, agsize=1186676 blks
          =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=18986816, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096 
log      =internal               bsize=4096   blocks=9270, version=1
          =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=65536  blocks=0, rtextents=0

When I try to label it:
p254:~# xfs_admin -L "root" /dev/sdd2
xfs_admin: /dev/sdd2 contains a mounted filesystem

fatal error -- couldn't initialize XFS library

The label is currently not set:
p254:~# xfs_admin -l  /dev/sdd2
label = ""
p254:~#

I guess my next step is to try UUID?

        Instead of giving the device explicitly, one may indicate the (ext2  or
        xfs)  filesystem that is to be mounted by its UUID or volume label (cf.
        e2label(8) or  xfs_admin(8)),  writing  LABEL=<label>  or  UUID=<uuid>,
        e.g.,   `LABEL=Boot'   or  `UUID=3e6be9de-8139-11d1-9106-a43f08d823a6'.
        This will make the system more robust: adding or removing a  SCSI  disk
        changes the disk device name but not the filesystem volume label.

p254:~# xfs_admin -U generate /dev/sdd2
xfs_admin: /dev/sdd2 contains a mounted filesystem

fatal error -- couldn't initialize XFS library
p254:~#

Hmm, am I out of luck?

Justin.
