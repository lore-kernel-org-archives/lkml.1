Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbZCDB7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbZCDB7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 20:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZCDB7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 20:59:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:36885 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096AbZCDB7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 20:59:14 -0500
Message-ID: <49ADE077.1060606@kernel.org>
Date: Wed, 04 Mar 2009 10:59:19 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86-tip: cpufreq breakage - bisection fingers	89c9215165ca609096e845926d9a18f1306176a4
References: <1236085632.5958.8.camel@marge.simson.net>	 <20090303143106.GA12248@elte.hu> <1236098338.5926.0.camel@marge.simson.net>
In-Reply-To: <1236098338.5926.0.camel@marge.simson.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 01:59:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Mike Galbraith wrote:
> On Tue, 2009-03-03 at 15:31 +0100, Ingo Molnar wrote:
>> * Mike Galbraith <efault@gmx.de> wrote:
>>
>>> Box is Q6600, X86_64.  I haven't poked at it other than to 
>>> verify the bisection result via patchlet below data.
>>>
>>> [    1.672700] overflow in relocation type 11 val 3a000f06b588
>>> [    1.681051] `processor' likely not compiled with -mcmodel=kernel
>> btw., the .config you used, and the output of ld -v and gcc -v 
>> would be nice as well.
> 
> GNU ld (GNU Binutils; openSUSE 11.0) 2.18.50.20080409-11.1
> 
> Using built-in specs.
> Target: x86_64-suse-linux
> Configured with: ../configure --prefix=/usr --with-local-prefix=/usr/local --infodir=/usr/share/info --mandir=/usr/share/man --libdir=/usr/lib64 --libexecdir=/usr/lib64 --enable-languages=c,c++,objc,fortran,obj-c++,java,ada --enable-checking=release --with-gxx-include-dir=/usr/include/c++/4.3 --enable-ssp --disable-libssp --with-bugurl=http://bugs.opensuse.org/ --with-pkgversion='SUSE Linux' --disable-libgcj --with-slibdir=/lib64 --with-system-zlib --enable-__cxa_atexit --enable-libstdcxx-allocator=new --disable-libstdcxx-pch --program-suffix=-4.3 --enable-version-specific-runtime-libs --enable-linux-futex --without-system-libunwind --with-cpu=generic --build=x86_64-suse-linux
> Thread model: posix
> gcc version 4.3.1 20080507 (prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) 

I can't reproduce the problem here.  My tool chains are newer tho
(11.1).  Hmmm... I really don't see how calling a function or not can
cause relocation overflow in other places.  For the linker, all three
setup_pcpu functions aren't that different.

I'll set up a 11.0 system and see whether I can reproduce the problem.
Just in case, can you please try to rebuild after mrproper?

-- 
tejun
