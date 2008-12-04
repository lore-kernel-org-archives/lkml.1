Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbYLDESf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbYLDESf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 23:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbYLDES0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 23:18:26 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:24713 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbYLDES0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 23:18:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=g4S04E2yf2/nTq7VjqlhQkcba/swBXMv4T+FtxUbIo4C0wtAltQZK0SMFhqADs6h4i
         XBqv6gbmjN3tks6F5wDFszcHHtACYs84930358p0aGVzTuQLip5sDLAiAe3C8IItePNZ
         QTeGHw8+uzC7WwuHJs1uOC5kiKxSvOachSSLk=
Message-ID: <b7bb26000812032018g5c5fdd03n52135e4cdd240352@mail.gmail.com>
Date: Wed, 3 Dec 2008 23:18:22 -0500
From: "Sihan Goi" <goister@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: How to change root_dev for 2.6.27.7 kernel?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to update the kernel in 1 of my drives from 2.6.22.19 to
the latest stable 2.6.27.7 release. It seems that some changes
happened.

First, arch/i386/boot has been replaced by arch/x86/boot. Also the
boot sector file bootsect no longer exists, and the build command's
syntax has changed to reflect this.

I have previously been able to build an uncompressed kernel whose
rootdev is /dev/sda1 with the following script:

echo "Builds uncompressed Image here with root device as /dev/sda1"
mknod  /dev/sda1 b 8 1
objcopy -O binary -R .note -R .comment -S vmlinux tmppiggy
cd arch/i386/boot
tools/build -b bootsect setup ../../../tmppiggy /dev/sda1 > ../../../Image_sda
cd -
echo "The uncompressed image can only boot from /dev/sda1 and is
called Image_sda"

However, I'm unable to do this even after changing the directory
names, because the file "setup" doesn't exist.

I have tried manually modifying ROOT_DEV in arch/x86/boot/Makefile
from CURRENT to "/dev/sda1" and the when I do a "file bzImage" it
gives the following output:

bzImage: Linux kernel x86 boot executable RO-rootFS, root_dev 0x801,
swap_dev 0x1, Normal VGA

My old kernel 2.6.22.19, after running the script, has a swap_dev of
0x2 instead.

I'm not sure what else is different, however I'm having trouble
booting up with the new image in some(not all) systems. It boots up
until the following stage then kernel panics:

FS: Cannot open root device "801" or unknown-block (8,1)
Please append a correct "root=" boot option; here are the available partitions:
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(8,1)

Any ideas how I can get build to change my root_dev/swa_dev? I've
tried using the setup.elf, as well as copying setp from the 2.6.22.19
kernel and running the command without the "bootsect" parameter, but
it gives me the message:

Boot block hasn't got boot flag (0xAA55)

Thanks.
