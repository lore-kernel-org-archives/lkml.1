Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805AbXL2QBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbXL2QBe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 11:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbXL2QBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 11:01:25 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:43197 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbXL2QBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 11:01:25 -0500
Date: Sat, 29 Dec 2007 17:01:24 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: devzero@web.de
cc: dl9pf@gmx.de, jcm@jonmasters.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kbuild: modules_install regression ? - depmod
In-Reply-To: <75317208@web.de>
Message-ID: <Pine.LNX.4.64.0712291658560.23321@fbirervta.pbzchgretzou.qr>
References: <75317208@web.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 29 2007 16:51, devzero@web.de wrote:
>
>> Erm... same system here -
>> 
>> $ gzip -cd /proc/config.gz | grep DEBUG_INFO
>> # CONFIG_DEBUG_INFO is not set
>> 
>> I think you managed to snafu something during building.
>
>mhh - i have kernel-default-2.6.22.13-0.3 kernel (didn`t touch that since online update) and this has CONFIG_DEBUG_INFO=y
>wondering about that, i installed shipping kernel (kernel-default-2.6.22.5-31 from http://download.opensuse.org/distribution/openSUSE-current/repo/oss/suse/i586/ ) 
>
>but:
>
>opensuse103:~ # uname -a
>Linux opensuse103 2.6.22.5-31-default #1 SMP 2007/09/21 22:29:00 UTC i686 i686 i386 GNU/Linux
>
>opensuse103:~ # zcat /proc/config.gz |grep DEBUG_INFO
>CONFIG_DEBUG_INFO=y
>
>so i don`t plead guilty.......
>

Well, either way.

rpm2cpio /lnk/103/i586/kernel-default-2.6.22.5-31.i586.rpm [...] grep
DEBUG_INFO ./boot/config-2.6.22.5-31-default

says =y

vs

rpm2cpio /lnk/103/src/kernel-default-2.6.22.5-31.src.rpm [...]
tar -xf config.tar.bz2 [...] grep DEBUG_INFO ./config/i386/default

says =n.

Anyway, it's that option that causes the kernel to be built with -g
and m-i-t does not gracefully handle all that debug info yet.
If /lib is 800 MB, well, expect some serious swapping. Or just
compile without it. Or if you are lazy, find /lib/modules -type f
-iname '*.ko' -print0 | xargs -0 strip -g && depmod. :-)
