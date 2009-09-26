Return-Path: <linux-kernel-owner+w=401wt.eu-S1751608AbZIZJTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbZIZJTG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 05:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbZIZJTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 05:19:05 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:34548 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbZIZJTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 05:19:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=kJDWZcXjY/zAntusRBwxlyWe0RAi3gVKk28ugoFsLc3BpuL62NoGGWLRbNJd2EY96u
         XGzOEJy4ShJt6rok5NpdsYl6CJudJIqwtmJuc7cEyxQG0ivpHditl2EzCIzmN9GQIrvm
         BkBnL1G+IydsI8UGPhEx+gxj/lIKC1HCRa0Jc=
MIME-Version: 1.0
Date: Sat, 26 Sep 2009 17:19:07 +0800
Message-ID: <e997b7420909260219n17fcf421ke2e552e6311c66f6@mail.gmail.com>
Subject: Why get_fs_names return NULL?
From: "wilbur.chan" <wilbur512@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am going to start a kernel using ramdisk, but  kernel panic  when
mounting the ramdisk fs.


After traped the code , I found that , when kernel invoked
get_fs_names, it got a NULL list of existing file system names.

That is to say,
prepare_namespace--->mount_root-->mount_block_root-->get_fs_names-->get_filesystem_list
 ,

return  a list of nothing...

I thought that , maybe module_init(init_ext2_fs) failed , but I don't
know why? and how to solve it ?

here is my ramdisk script:

mkdir initrd
dd if=/dev/zero of=initrd.img bs=1k count=4096
mke2fs -F -v -m0 initrd.img
mount -o loop initrd.img initrd
cp -av rootfs/* initrd
sync
umount initrd
sync
gzip -f -9 initrd.img
sync
./mkimage -T ramdisk -C gzip -n ' Ramdisk Image' -d initrd.img.gz
your.ramdisk.u-boot
