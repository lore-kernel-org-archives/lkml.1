Return-Path: <linux-kernel-owner+w=401wt.eu-S1750918AbYLCTx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750918AbYLCTx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYLCTuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:50:15 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:55650 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbYLCTuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:50:09 -0500
Date: Wed, 03 Dec 2008 14:50:23 -0500
From: Jody McIntyre <scjody@sun.com>
Subject: Re: [PATCH] Fix compile error in arch/x86/kernel/syscall_64.c
In-reply-to: <4936C927.3030504@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
Message-id: <20081203195022.GA7080@clouds>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <20081202215154.GL29919@clouds> <4936C927.3030504@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 10:00:07AM -0800, H. Peter Anvin wrote:

> Okay, this makes no sense whatsoever.

Glad you agree :)

> Could you send me the following:
> 
> a. the .config you're using;

http://downloads.lustre.org/people/scjody/lkml/config_2008-12-03

> b. what kernel headers do you have in /usr/include
>    (if you installed the old ones with the broken header guards
>    with "make headers_install", then your development environment
>    is broken);

I have never installed headers via "make headers_install".  Anything
under /usr/include comes from my distribution (Ubuntu), and neither
header guard is found anywhere:

root@vm1:~/linux-2.6# grep -r ASM_X86__UNISTD_64_H /usr/include
root@vm1:~/linux-2.6# grep -r _ASM_X86_UNISTD_64_H /usr/include
root@vm1:~/linux-2.6# 

/usr/include/linux/* and /usr/include/asm/* come from the linux-libc-dev
(2.6.27-9.19) package:

Package: linux-libc-dev
Priority: optional
Section: devel
Installed-Size: 3684
Maintainer: Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>
Architecture: amd64
Source: linux
Version: 2.6.27-9.19
Replaces: dvb-dev (<< 1.0.1-6), libc6-dev (<< 2.3.2.ds1-6), libc6.1-dev (<< 2.3.2.ds1-6), linux-kernel-headers
Provides: linux-kernel-headers
Conflicts: amd64-libs-dev (<= 1.1), dvb-dev (<< 1.0.1-6), libc6-dev (<< 2.3.2.ds1-6), libc6.1-dev (<< 2.3.2.ds1-6), linux-kernel-headers
Filename: pool/main/l/linux/linux-libc-dev_2.6.27-9.19_amd64.deb
Size: 653400
MD5sum: f2c4482176fe9e5219f7b18a258cbf86
SHA1: 1e6d329b13612438673a905152410cde8d0a7a53
SHA256: a294cb5f320c626a48f917a23b73a04e7d763ac3c2863ad16432dcd46cc0675c
Description: Linux Kernel Headers for development
 This package provides headers from the Linux kernel.  These headers
 are used by the installed headers for GNU glibc and other system
 libraries. They are NOT meant to be used to build third-party modules for
 your kernel. Use linux-headers-* packages for that.
Bugs: mailto:ubuntu-users@lists.ubuntu.com
Build-Essential: yes
Origin: Ubuntu
Task: ubuntu-desktop, kubuntu-desktop, edubuntu-desktop, xubuntu-desktop, mobile-mobile

I'm confused as to why this matters - I didn't think the kernel build
used any external includes (except for helper utilities like "conf".)

> c. "make arch/x86/kernel/syscall_64.i".

http://downloads.lustre.org/people/scjody/lkml/syscall_64.i

Cheers,
Jody

> 
> 	-hpa
