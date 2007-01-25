Return-Path: <linux-kernel-owner+w=401wt.eu-S1752105AbXAYCfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbXAYCfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 21:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXAYCfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 21:35:07 -0500
Received: from main.gmane.org ([80.91.229.2]:48000 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbXAYCfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 21:35:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Piet Delaney <piet@bluelane.com>
Subject: Problem booting a kernel built in an older environemnt in the newer LFS LiveCDs 6.2-3 and 6.2-4 environments.
Followup-To: gmane.linux.lfs.devel
Date: Wed, 24 Jan 2007 18:24:54 -0800
Organization: BlueLane Tech
Message-ID: <ep94dm$13o$1@sea.gmane.org>
Reply-To: piet@bluelane.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 64.95.123.130
Mail-Copies-To: piet@bluelane.com
User-Agent: KNode/0.9.1
Cc: lfs-dev@linuxfromscratch.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm having two unexpected problems with LFS LiveCDs 6.2-3 and 6.2-4
that don't occure on lfslivecd-x86-6.1.1-4.iso. I've got a workaround
for the second problem but haven't found a solution yet for the second;
see 2. below.

 1. The first is that I need to add a symbolic pointer from stage
    to stage2 in the ${DISK}/boot/ directory when running grub-install.
    The difference seems to be that the script is passing the wrong
    arg in grub to the install command. The '2' is missing from the
    the "(hd0,0)/boot/grub/stage2" argument; Ex:

        # grub-install --debug  --root-directory=/recovery /dev/sda
        + case "$host_os" in
        + bootdir=/recovery/boot
        + grubdir=/recovery/boot/grub
        + device_map=/recovery/boot/grub/device.map
        + set /usr/sbin/grub dummy
        .
        .
        .
        grub> root (hd0,0)
        Filesystem type is ext2fs, partition type 0x83
        grub> setup  --stage2=/recovery/boot/grub/stage2 
                     --prefix=/boot/grub (hd0)
        Checking if "/boot/grub/stage1" exists... yes
        Checking if "/boot/grub/stage2" exists... yes
        Checking if "/boot/grub/e2fs_stage1_5" exists... yes
        Running "embed /boot/grub/e2fs_stage1_5 (hd0)"...  15 sectors are
        embedded.
        succeeded
        Running "instal--stage2=/recovery/boot/grub/stage2 
                        /boot/grub/stage1
                        (hd0) (hd0)1+15 p 
                        (hd0,0)/boot/grub/stage /boot/grub/menu.lst"...
        succeeded                             ^
        Done.                                 |
        grub> quit                            +---- HERE



 2. The second, and more important problem, is that once one of my
    kernels is running that it can't open the root filesystem. Looks
    like it can't read the partition table or something. It's not 
    the kernel source being to old, as kernels more recent than the 
    2.6.16 kernel (2.6.18 for example) also fail to boot.

    I made a static version of our mke2fs ran it on the lfslivecd-x86-6.2.3
    and used it instead of the stock mke2fs and it didn't effect the
    problem. I ran a static dumpe2fs and checked the magic number.
    Seems the magic number hasn't changed.

    I recall when migrating from 2.4 to 2.6 there being some bin-utils or
    something that the kernel build process used to make the kerenl image.
    I suspect that I need to update that in my build environmennt. If that's
    it anyone know which package that is and where to get it from. I tried
    kernel.org wonder if it's util-linux-2.12r.

-piet


