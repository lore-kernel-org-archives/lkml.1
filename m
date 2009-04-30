Return-Path: <linux-kernel-owner+w=401wt.eu-S1763714AbZD3Ols@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763714AbZD3Ols (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763477AbZD3Old
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:41:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53447 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763656AbZD3Olc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:41:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH 29/30] microblaze_mmu_v1: stat.h MMU update
Date: Thu, 30 Apr 2009 16:40:32 +0200
User-Agent: KMail/1.9.9
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       john.williams@petalogix.com
References: <1240821139-7247-23-git-send-email-monstr@monstr.eu> <200904301553.47556.arnd@arndb.de> <49F9B13C.3060008@monstr.eu>
In-Reply-To: <49F9B13C.3060008@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904301640.32769.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19wSpE92JrV+3gjqK1KX+fYzgGHyiZn1Kzj4gZ
 K7nIL0DTKwkjt1fGISnpACdP8aEzgGJgKnT/5y5kRIwh6fxDzy
 mzLjFkar0Xa7uC3eTKnNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 April 2009, Michal Simek wrote:

> 2. header cleanup -> some of them is pain because I have to recompile toolchain
> that's should be a big deal but after recompilation kernel, user apps I am getting some problems.

Yes, I understand that you have a circular dependency there, but fixing
the ABI can only become harder with time, as more people start using
the current kernel/toolchain combination.

> 3. syscall cleanup -> we still have old libc and I can't simple remove ancient syscalls

I had hoped that the way I set __ARCH_WANT_SYSCALL_* in the microblaze
unistd.h would provide an easy way to migrate, because this still defines
almost all traditional system calls (I haven't double-checked if some more
are currently used on microblaze, but they would be easy to add).
This means that as a first step, rebuilding the tool chain (as above) should
be sufficient and not require source-level changes to libc. From that point,
you can remove the remaining __ARCH_WANT_SYSCALL_* defintions one by one,
and change the libc accordingly.

I could also try building uclibc with the generic headers if I find the
time. Which version do you use, just upstream or do you have a private
libc tree with more changes?

	Arnd <><
