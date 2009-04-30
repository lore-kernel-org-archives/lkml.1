Return-Path: <linux-kernel-owner+w=401wt.eu-S1763470AbZD3Ovo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763470AbZD3Ovo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761813AbZD3Ove
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:51:34 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41186 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759173AbZD3Ove (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:51:34 -0400
Message-ID: <49F9BAF1.9060805@monstr.eu>
Date: Thu, 30 Apr 2009 16:51:29 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       john.williams@petalogix.com
Subject: Re: [PATCH 29/30] microblaze_mmu_v1: stat.h MMU update
References: <1240821139-7247-23-git-send-email-monstr@monstr.eu> <200904301553.47556.arnd@arndb.de> <49F9B13C.3060008@monstr.eu> <200904301640.32769.arnd@arndb.de>
In-Reply-To: <200904301640.32769.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Thursday 30 April 2009, Michal Simek wrote:
> 
>> 2. header cleanup -> some of them is pain because I have to recompile toolchain
>> that's should be a big deal but after recompilation kernel, user apps I am getting some problems.
> 
> Yes, I understand that you have a circular dependency there, but fixing
> the ABI can only become harder with time, as more people start using
> the current kernel/toolchain combination.

Here is the one advantage that in mainline are only some drivers for Microblaze
and the rest is in petalinux. And people can use whole distribution.

> 
>> 3. syscall cleanup -> we still have old libc and I can't simple remove ancient syscalls
> 
> I had hoped that the way I set __ARCH_WANT_SYSCALL_* in the microblaze
> unistd.h would provide an easy way to migrate, because this still defines
> almost all traditional system calls (I haven't double-checked if some more
> are currently used on microblaze, but they would be easy to add).
> This means that as a first step, rebuilding the tool chain (as above) should
> be sufficient and not require source-level changes to libc. From that point,
> you can remove the remaining __ARCH_WANT_SYSCALL_* defintions one by one,
> and change the libc accordingly.
> 
> I could also try building uclibc with the generic headers if I find the
> time. Which version do you use, just upstream or do you have a private
> libc tree with more changes?

That's good question but harder answer.
Glibc is any ancient 3-4 years non mainline version. There are some backports too.
I have some comments to it but it is better not to write them.

uclibc version is a little bit better. I had functional port half year mainline version
+ some private fixes. Currently John W is working on it to get working version with gcc 4.1.2.
He has some troubles with it but I hope he solve it soon.

We have troubles because none have taken care about. I hope that we are able to update
all the things and repair everything what wrong it.

Michal

> 
> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
