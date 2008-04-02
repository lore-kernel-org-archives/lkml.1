Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbYDBPRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbYDBPRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 11:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbYDBPRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 11:17:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:10059 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbYDBPRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 11:17:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=NcGuQNVfDXWG/2vlYXC52U1mFTEXyGYxA3cZzIAKotM/QJibghUmqXSfbRFGPhFuyxx++3W+Fl8QT2rjxAZSHsQuQ3bZ/ib9BaxSiukQdyqUqfndjGiZITzjOIoFqoCd7R0hQUG53lON7z5B1H+CSK9npASb//4ljN+Ogm+SFns=
Message-ID: <9e0cf0bf0804020817s2f558479ve9bca8f82981f7bb@mail.gmail.com>
Date: Wed, 2 Apr 2008 18:17:42 +0300
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: SH4 - Cannot make initramfs work
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am trying to boot 2.6.24 kernel on SH4 eb using embedded initramfs.

The kernel boots, but when trying to decompress the initramfs image it
fails with "crc error",
resulting from lib/inflate.c::gunzip:1250.

Has anyone got this error? The initramfs image is correct. I also
dumped the memory of __initramfs_start->__initramfs_start and verified
that it matches the initramfs image on usr/initramfs_data.cpio.gz.

I then noticed that the kernel code at
init/initramfs::unpack_to_rootfs:459 supports handling
uncompressed archives. So I compiled a kernel with uncompressed archived.

I also hooked the init/initramfs::do_name:585 functions, and see that
"/init' is passed
to sys_open, and sys_open returns with -EOENT (-2).

How can it be? shouldn't rootfs always be available?

The same attempt on i586, mipsel is working as expected.

Any ideas?
1. Why decompression working for kernel and not for initramfs (crc error).
2. Why files cannot be created on rootfs?

Thank you,
Alon Bar-Lev.
