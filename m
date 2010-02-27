Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030414Ab0B0SHY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 13:07:24 -0500
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:36245 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030293Ab0B0SHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 13:07:23 -0500
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Feb 2010 13:07:22 EST
Message-ID: <4B895D0A.1090401@free.fr>
Date: Sat, 27 Feb 2010 18:57:30 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: linux-mips@linux-mips.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: merge .text.*/.rel.text.* sections in module build with -ffunction-section
Content-Type: multipart/mixed;
 boundary="------------060303070200050206060907"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060303070200050206060907
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

mips (and other arch) use -ffunction-section (I am not sure why. It may be to prevent gcc to emit bad relocation).

Apart from making the code a bit bigger it :
- make very difficult to analyze binary kernel dump (without symbol) of module : you can't easily knowing the load address of the module find the symbol of an address.
- make module bigger (due to alignment between section and bigger section table)
- make the module loading slower (more section to parse)

I wondering why we doesn't merge all text section in one section when building .ko.
This can be done with :
mipsel-openwrt-linux-uclibc-ld -r  -m elf32ltsmip  -o vfat2.ko vfat.ko -T module-common.lds

Why doesn't mips provide a custom module-common.lds that does that ?


Matthieu

PS : could you keep me in CC

PS2 : 
ls -l vfat2.ko vfat.ko
12881 vfat2.ko
14748 vfat.ko

we save 13% of module size !

--------------060303070200050206060907
Content-Type: text/plain;
 name="module-common.lds"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="module-common.lds"

LyoKICogQ29tbW9uIG1vZHVsZSBsaW5rZXIgc2NyaXB0LCBhbHdheXMgdXNlZCB3aGVuIGxp
bmtpbmcgYSBtb2R1bGUuCiAqIEFyY2hzIGFyZSBmcmVlIHRvIHN1cHBseSB0aGVpciBvd24g
bGlua2VyIHNjcmlwdHMuICBsZCB3aWxsCiAqIGNvbWJpbmUgdGhlbSBhdXRvbWF0aWNhbGx5
LgogKi8KU0VDVElPTlMgewoJLnRleHQgOiB7CgkJKigudGV4dC4qKQoJfQoJLnJlbC50ZXh0
IDogewoJCSooLnJlbC50ZXh0LiopCgl9CgkvRElTQ0FSRC8gOiB7ICooLmRpc2NhcmQpIH0K
fQo=
--------------060303070200050206060907--
