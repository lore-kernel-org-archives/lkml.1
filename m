Return-Path: <linux-kernel-owner+w=401wt.eu-S932246AbZLRRNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbZLRRNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbZLRRMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:12:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43077 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232AbZLRRMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:12:51 -0500
Message-ID: <4B2BB812.103@zytor.com>
Date: Fri, 18 Dec 2009 09:12:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Kernel built for i586 chip crashes instantly at boot time
 (CMOV instructions)
References: <219280.97558.qm@web52907.mail.re2.yahoo.com>
In-Reply-To: <219280.97558.qm@web52907.mail.re2.yahoo.com>
Content-Type: multipart/mixed;
 boundary="------------040109030508070100020306"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040109030508070100020306
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/18/2009 07:28 AM, Chris Rankin wrote:
> Hi,
> 
> I have been trying to build a 2.6.31.x kernel with Fedora 12's gcc compiler, and have discovered that this kernel crashes instantly at boot-time due to a pair of CMOV instructions in arch/x86/boot/compressed/misc.o. According to "make V=1", the command used to compile misc.c is:
> 
>   gcc -Wp,-MD,arch/x86/boot/compressed/.misc.o.d  -nostdinc -isystem /usr/lib/gcc/i686-redhat-linux/4.4.2/include -Iinclude -Iinclude2 -I/home/chris/LINUX/linux-2.6.31/include -I/home/chris/LINUX/linux-2.6.31/arch/x86/include -include include/linux/autoconf.h  -I/home/chris/LINUX/linux-2.6.31/arch/x86/boot/compressed -Iarch/x86/boot/compressed -D__KERNEL__ -m32 -D__KERNEL__ -O2 -fno-strict-aliasing -fPIC -DDISABLE_BRANCH_PROFILING -ffreestanding -fno-stack-protector   -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(misc)"  -D"KBUILD_MODNAME=KBUILD_STR(misc)"  -c -o arch/x86/boot/compressed/misc.o /home/chris/LINUX/linux-2.6.31/arch/x86/boot/compressed/misc.c
> 
> which apparently uses gcc's default architecture. However, Fedora has recently changed its gcc default architecture from i586 to i686, and so I end up with a pair on invalid instructions in my kernel binary.
> 

Does this patch work for you?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


--------------040109030508070100020306
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="diff"

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2Jvb3QvY29tcHJlc3NlZC9NYWtlZmlsZSBiL2FyY2gv
eDg2L2Jvb3QvY29tcHJlc3NlZC9NYWtlZmlsZQppbmRleCBmOGVkMDY1Li5mMjViYmQzIDEw
MDY0NAotLS0gYS9hcmNoL3g4Ni9ib290L2NvbXByZXNzZWQvTWFrZWZpbGUKKysrIGIvYXJj
aC94ODYvYm9vdC9jb21wcmVzc2VkL01ha2VmaWxlCkBAIC05LDYgKzksNyBAQCB0YXJnZXRz
IDo9IHZtbGludXgubGRzIHZtbGludXggdm1saW51eC5iaW4gdm1saW51eC5iaW4uZ3ogdm1s
aW51eC5iaW4uYnoyIHZtbGludQogS0JVSUxEX0NGTEFHUyA6PSAtbSQoQklUUykgLURfX0tF
Uk5FTF9fICQoTElOVVhfSU5DTFVERSkgLU8yCiBLQlVJTERfQ0ZMQUdTICs9IC1mbm8tc3Ry
aWN0LWFsaWFzaW5nIC1mUElDCiBLQlVJTERfQ0ZMQUdTICs9IC1ERElTQUJMRV9CUkFOQ0hf
UFJPRklMSU5HCitjZmxhZ3MtJChDT05GSUdfWDg2XzMyKSA6PSAtbWFyY2g9aTM4NgogY2Zs
YWdzLSQoQ09ORklHX1g4Nl82NCkgOj0gLW1jbW9kZWw9c21hbGwKIEtCVUlMRF9DRkxBR1Mg
Kz0gJChjZmxhZ3MteSkKIEtCVUlMRF9DRkxBR1MgKz0gJChjYWxsIGNjLW9wdGlvbiwtZmZy
ZWVzdGFuZGluZykK
--------------040109030508070100020306--
