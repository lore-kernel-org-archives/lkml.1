Return-Path: <linux-kernel-owner+w=401wt.eu-S1760966AbYDYIQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760966AbYDYIQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 04:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756393AbYDYIPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 04:15:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:60607 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbYDYIPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 04:15:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 00/24] Unify integer type definitions, and add fixed type constructor macros
Date: Fri, 25 Apr 2008 10:15:31 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>
References: <1209078352-7593-1-git-send-email-hpa@zytor.com>
In-Reply-To: <1209078352-7593-1-git-send-email-hpa@zytor.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804251015.32157.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18LUGPfCb4E2DHUVq1Co5imuJxuuS2YMvf2VaS
 34WhhFz1RsRbcn7uPhY0l6ox8HHTmL20fBo+18IhdwgmGmG1KD
 yTDvQ6xjPysf7+B/YvcFw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 April 2008, H. Peter Anvin wrote:
> This patchset unifies the integer definitions across all the
> <asm-*/types.h> files, replacing them with two asm-generic files, one
> for the LL64 model (all 32-bit architectures plus x86-64) and one for
> the L64 model (all other 64-bit architectures.)

I started hacking on a similar patch just yesterday, but with a slightly
different goal. My intention was to move the headers in a direction
where a new architecture (microblaze being the next one) would no longer
have to care about ABI defining headers at all, but just use the defaults
from a single #include line.

I could deal with x86 by leaving the current asm-x86/types.h in place,
and change all the others so they can use the common one. The only
difference here would be umode_t and dma_addr_t, which are irregularly
defined on a few architectures, but we can assume reasonable defaults, as in

asm-powerpc/types.h:

#ifdef __powerpc64__
#define __umode_t unsigned int
#include <asm-generic/types_64.h>
#else
#include <asm-generic/types_32.h>
#endif

asm-generic/types_64.h:

#ifdef __umode_t
typedef __umode_t umode_t;
#else
typedef unsigned short umode_t;
#endif

	Arnd <><
