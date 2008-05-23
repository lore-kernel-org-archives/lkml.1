Return-Path: <linux-kernel-owner+w=401wt.eu-S1757602AbYEWLJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbYEWLJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 07:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYEWLJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 07:09:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:57549 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbYEWLJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 07:09:18 -0400
In-Reply-To: <20080523011213.690363c7.akpm@linux-foundation.org>
References: <48313D8E.7020109@de.ibm.com> <20080523011213.690363c7.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <ab1f935148982762bae55734ffb8acc7@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
       Peter Oberparleiter <oberparleiter@googlemail.com>,
       Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       Sam Ravnborg <sam@ravnborg.org>, ltp-coverage@lists.sourceforge.net
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 0/7] gcov kernel support
Date: Fri, 23 May 2008 13:06:00 +0200
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This is version #2 of the gcov kernel support patch set
>
> powerpc blew up:
>
> /opt/crosstool/gcc-4.1.0-glibc-2.3.6/powerpc64-unknown-linux-gnu/lib/ 
> gcc/powerpc64-unknown-linux-gnu/4.1.0/../../../../powerpc64-unknown- 
> linux-gnu/bin/ld: skipping incompatible  
> /opt/crosstool/gcc-4.1.0-glibc-2.3.6/powerpc64-unknown-linux-gnu/lib/ 
> gcc/powerpc64-unknown-linux-gnu/4.1.0/./libgcov.a when searching for  
> -lgcov
> /opt/crosstool/gcc-4.1.0-glibc-2.3.6/powerpc64-unknown-linux-gnu/lib/ 
> gcc/powerpc64-unknown-linux-gnu/4.1.0/../../../../powerpc64-unknown- 
> linux-gnu/bin/ld: cannot find -lgcov
> collect2: ld returned 1 exit status
> make[2]: *** [arch/powerpc/kernel/vdso32/vdso32.so.dbg] Error 1
> make[1]: *** [arch/powerpc/kernel/vdso32] Error 2

Sounds like your toolchain was built without biarch support, but you're
using it for the 32-bit parts of the kernel anyway.  Which works as long
as you're not using any libraries, but now you need libgcov.a .

What does

/opt/crosstool/gcc-4.1.0-glibc-2.3.6/powerpc64-unknown-linux-gnu/bin/ 
powerpc64-unknown-linux-gnu-gcc -v

say?  (Or whatever the correct path to that compiler is, the directory
structure is a bit unusual here it seems).  There shouldn't be a
--disable-biarch there.

Or, what does

find  
/opt/crosstool/gcc-4.1.0-glibc-2.3.6/powerpc64-unknown-linux-gnu/4.1.0/  
-name libgcov.a

say?  (It should usually find three versions: 64-bit, 32-bit, 32-bit no  
float).


You *can* build with a non-biarch compiler, but then you need to point
the kernel build system at a 32-bit toolchain to use for the 32-bit
parts (via CROSS32_COMPILE).


Segher

