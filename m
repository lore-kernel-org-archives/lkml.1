Return-Path: <linux-kernel-owner+w=401wt.eu-S1758390AbZA1Xdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390AbZA1Xdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757411AbZA1X3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:29:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:53843 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408AbZA1X3W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:29:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: do not expose CONFIG_BSWAP to userspace
Date: Thu, 29 Jan 2009 00:24:08 +0100
User-Agent: KMail/1.9.9
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
References: <20090127222825.GA27097@elte.hu> <1233179884.6717.59.camel@brick> <4980D913.3000505@zytor.com>
In-Reply-To: <4980D913.3000505@zytor.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901290024.09815.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1++ltRnaaqyGsoYum+78D8xd5Sc6uIDhTIP6at
 xyGdBLZkHbVjrNkCzI1IguPn96TCEo4r40y2lgzWkngdx9ZZYE
 P66M5//eXsy3apWKqiFtg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 January 2009, H. Peter Anvin wrote:
> So, one ends up doing something like:
> 
> #ifdef __i486__
> # define __CPU_HAVE_BSWAP
> #endif
> #ifdef __i586__
> # define __CPU_HAVE_BSWAP
> #endif
> 
> ... and so on, and have to keep this up to date with the latest 
> inventions of the gcc people.  *Sob.*

Well, to put this into perspective: The bswap inline assembly was
introduced in Linux-1.3.51 "Greased Weasel", back in 1995 and at
no time it was ever visible to user space, unless the code manually
included <linux/config.h> (which we broke) or defined CONFIG_M486,
CONFIG_X86_BSWAP and/or __KERNEL__, depending on the kernel version.

I take this as a strong indication that user space applications
won't generally expect to get the bswap instruction from including
the kernel headers. For the longest time, we actually had

/* For avoiding bswap on i386 */
#ifdef __KERNEL__
#include <linux/config.h>
#endif

which I read as explicitly using the portable i386 version for
all user space.

	Arnd <><
