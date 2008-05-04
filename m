Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbYEDV31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbYEDV31 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 17:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbYEDV3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 17:29:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55749 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbYEDV3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 17:29:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@seznam.cz
Subject: Re: [PATCH 32/56] microblaze_v2: definitions of types
Date: Sun, 4 May 2008 23:28:44 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <cfde3796e95bdd17c32e4fd7762d0aee55967707.1209897266.git.monstr@monstr.eu> <8aba2d82c85cd1d5b56de328c1fd080ee51f0211.1209897266.git.monstr@monstr.eu>
In-Reply-To: <8aba2d82c85cd1d5b56de328c1fd080ee51f0211.1209897266.git.monstr@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805042328.45508.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18b/L/GtyJ8K1LspiD9bMEW2IrV4MIEdfGCr41
 nlEwRzAR7kG5cgnvURQdR8xhx0KoB8UDNaEb41BHK2CKy3dun/
 T0hOLWSf2UrzY6e3REMuA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 May 2008, monstr@seznam.cz wrote:
> include/asm-microblaze/posix_types.h

It would be good to have this as asm-generic/posix_types_32.h.
Unfortunately, __kernel_size_t and friends need to match the
compiler and are sometimes defined as 'unsigned int' and
sometimes as 'unsigned long', otherwise we could even use
the same header for 32 and 64 bit.

> +typedef unsigned short	__kernel_mode_t;
> +typedef unsigned short	__kernel_nlink_t;
> +typedef unsigned short	__kernel_ipc_pid_t;

Some architectures define these as 'unsigned int', which
seems reasonable, though there is no real requirement behind it,
afaict.

> +typedef long		__kernel_off_t;

I suppose this should become 'typedef long long __kernel_off_t;'
It won't work on pre-C99 compilers, but I don't think we need
to care about those for a new architecture.

> +typedef unsigned short	__kernel_uid_t;
> +typedef unsigned short	__kernel_gid_t;

this should certainly be unsigned int.

> +typedef unsigned short	__kernel_uid16_t;
> +typedef unsigned short	__kernel_gid16_t;
> +typedef unsigned int	__kernel_uid32_t;
> +typedef unsigned int	__kernel_gid32_t;
> +
> +typedef unsigned short	__kernel_old_uid_t;
> +typedef unsigned short	__kernel_old_gid_t;
> +typedef unsigned short	__kernel_old_dev_t;

try not defining these at all and see if something breaks.
If it does, that's probably a bug.

	Arnd <><
