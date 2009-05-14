Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbZENQfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbZENQfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 12:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbZENQe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 12:34:57 -0400
Received: from ocean.emcraft.com ([213.221.7.182]:51115 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbZENQe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 12:34:57 -0400
X-Greylist: delayed 3126 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 May 2009 12:34:57 EDT
Message-ID: <4A0C3BFB.1010305@emcraft.com>
Date: Thu, 14 May 2009 19:42:51 +0400
From: Sergei Poselenov <sposelenov@emcraft.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 'make headers_check' failed to install headers to arbitrary location
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm trying to install kernel headers to build a cross-toolchain, but got
the following:

make ARCH=arm 
INSTALL_HDR_PATH=/work/psl/eldk-builds/arm-2009-04-21/work/var/tmp/crosstool-0.43-3-root/usr/crosstool/gcc-4.2.2-glibc-20070515T2025-eldk/arm-linux-gnueabi/arm-linux-gnueabi/ 
headers_check
...
   CHECK   include/linux/raid (2 files)
   CHECK   include/linux/spi (1 files)
   CHECK   include/linux/sunrpc (1 files)
   CHECK   include/linux/tc_act (6 files)
   CHECK   include/linux/tc_ematch (4 files)
   CHECK   include/linux/usb (8 files)
make[2]: execvp: /bin/sh: Argument list too long
make[2]: *** 
[/work/psl/eldk-builds/arm-2009-04-21/work/var/tmp/crosstool-0.43-3-root/usr/crosstool/gcc-4.2.2-glibc-20070515T2025-eldk/arm-linux-gnueabi/arm-linux-gnueabi//include/linux/.check] 
Error 127
make[1]: *** [linux] Error 2
make: *** [headers_check] Error 2
->


The kernel version is 2.6.28

However, this works fine for 2.6.24.2

Running make with '-n', I've found the problem is that the filelist 
passed as argument to scripts/headers_check.pl apparently is too big.

The error depends also on a bash version, it failed on 2.05a, but passed
on 3.2.39.  Unfortunately, bash (or the hole host system) upgrade is not
an option. Also, I'm sure I could find a path length big enough to 
reproduce the error on a modern bash.

What would you suggest to resolve the problem?

Thanks for any help.

Regards,
Sergei
