Return-Path: <linux-kernel-owner+w=401wt.eu-S932337AbZHLJ13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbZHLJ13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 05:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932270AbZHLJ13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 05:27:29 -0400
Received: from mail-yw0-f193.google.com ([209.85.211.193]:60450 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbZHLJ10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 05:27:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=dPyDLG5zQME6XigtJz3SSRSwd7ObrQf86x1iOTFBEhqhrOZfpf9avmc7sWI3PQTbl6
         LwPM5lUbiM32fq/wTP2OKWVpG8NL4zxkIR1BN9quHmBpdi+DK6c50cillu4r2R7mULNT
         dML51M4RoIB9f4h5AIYdmytBeJ0uE9V/sFwow=
MIME-Version: 1.0
Date: Wed, 12 Aug 2009 17:27:27 +0800
Message-ID: <d67deb790908120227s7816a02cr1ea173a4358fa301@mail.gmail.com>
Subject: Is compat_sys_ioctl called when both kernel and userland are 64bit ?
From: april <aapril03@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all:

I am doing something to support 32bit userland and 64bit kernel.
I know compat_sys_ioctl will be called if 32bit userland send ioctl to
64bit kernel.

The compat ioctl do some conversion(suppose I provide those ioctls).
For example:
if a struct has a field  type is long or a pointer,which the size is
different between userland and kernel

I notice in the x86_64_defconfig file:
CONFIG_X86_64=y
CONFIG_IA32_EMULATION=y
and in "trap_init" function,
#ifdef CONFIG_IA32_EMULATION
        set_system_intr_gate(IA32_SYSCALL_VECTOR, ia32_syscall);
        set_bit(IA32_SYSCALL_VECTOR, used_vectors);
#endif

it seems when a kernel is built to x86_64, whenever a ioctl called
,the call flow will be ia32_syscall -->compat_sys_ioctl->compat
ioctl(if provided)
but I have some doubt:

My question is:
1.  Is compat_sys_ioctl called when both kernel and userland are 64bit
(suppose I provide those compat ioctl functions)?
     if so, it may have problem, for the compat ioctl suppose userland
is 32bit, and do the conversion, if a field is unsinged long or a
pointer, it will do the        wrong things .

     If not, how kernel knows the driver is 32bit or 64bit?

2. when using mmap, the 64bit kernel will return a 64bit address, and
a userland(32bit) application can only get the lower 32bit,
it can work when the memory is not large.

Is kernel do some conversion? or fortunately the higher 32bit is 00000000 ?

Thanks
