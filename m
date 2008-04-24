Return-Path: <linux-kernel-owner+w=401wt.eu-S1756431AbYDXViV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbYDXViV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 17:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbYDXViB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 17:38:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:54083 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbYDXViA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 17:38:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <Monstr@seznam.cz>
Subject: Re: microblaze syscall list
Date: Thu, 24 Apr 2008 23:37:52 +0200
User-Agent: KMail/1.9.9
Cc: Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au
References: <4988.7968-24314-1195487808-1209070282@seznam.cz>
In-Reply-To: <4988.7968-24314-1195487808-1209070282@seznam.cz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804242337.53681.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18hVVqyK+jkcDPPjQfeXQzJlOEfygskPCEqmph
 d/gBdH4TyyTgXLnCTYV3NC7qsISmhLc0ZjogH/By3Yc8Y21qDb
 +odJJdeNmn337LN7np/HA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 April 2008, Michal Simek wrote:
> Hi Arnd,
> here is current syscall table - I only rewrite your changes. I remove sys_ni_syscall except from #ifdefs. 
> I would like to match syscalls to logical block. Can I do it? (I'll fix unistd.h later)

yes, that makes a lot of sense to me. If we introduce a new
asm-generic/unistd.h, it's good to have it sorted in some
meaningful way, even if it is going to get messier over time.

> Can you look at it if I remove old syscalls? 
> I will continue tomorrow I am tired.

ok, I'll look at it tomorrow.

> 
> #ifdef __ARCH_WANT_SYS_SIGNAL
> 	.long sys_signal
> #else
> 	.long sys_ni_syscall
> #endif
> #ifdef __ARCH_WANT_SYS_TIME
> 	.long sys_time
> 	.long sys_stime
> #else
> 	.long sys_ni_syscall
> 	.long sys_ni_syscall
> #endif

I guess I wasn't entirely clear with what I mean referring to
__ARCH_WANT_SYS_*. Instead of adding the #ifdef here, I meant
you should just remove the call entirely. With a few exceptions
that I already mentioned, the fact that there is an __ARCH_WANT
check in the syscall definition means that new architectures
should not reference the call, nor #define the __ARCH_WANT macro.

	Arnd <><
