Return-Path: <linux-kernel-owner+w=401wt.eu-S1763473AbYETJMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763473AbYETJMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758071AbYETJL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:11:58 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:43817 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757887AbYETJL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:11:57 -0400
Date: Tue, 20 May 2008 12:09:49 +0300
From: Adrian Bunk <bunk@stusta.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] asm-generic/int-ll64.h: always provide __{s,u}64
Message-ID: <20080520090949.GI17716@cs181133002.pp.htv.fi>
References: <20080519215452.GK17716@cs181133002.pp.htv.fi> <4831F89F.5060106@zytor.com> <1211236048.5915.94.camel@brick> <20080519223232.GB17716@cs181133002.pp.htv.fi> <48321299.80303@zytor.com> <20080520001345.GG17716@cs181133002.pp.htv.fi> <4832189B.8000602@zytor.com> <20080520003315.GH17716@cs181133002.pp.htv.fi> <4832266D.5010203@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4832266D.5010203@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 06:16:29PM -0700, H. Peter Anvin wrote:
> Adrian Bunk wrote:
>>>>
>>> This is a valid point.  This should be __i486__ for userspace, which 
>>> is  gcc's way to tell you if you're compiling with -march=i486.
>>
>> This doesn't help if you're compiling with e.g. -march=pentium
>
> Yes, it does.  -march=pentium defines __i486__ as well as __i586__, and  
> so on.

$ cat test.c
#include <stdio.h>

int main()
{
#ifdef __i486__
  printf("foobarbaz\n");
#endif

  return 0;
}
$ gcc -O2 -march=i486 -Wall test.c; ./a.out
foobarbaz
$ gcc -O2 -march=pentium -Wall test.c; ./a.out
$ gcc --version
gcc (Debian 4.3.0-4) 4.3.1 20080501 (prerelease)
...
$ /usr/local/DIR/gcc-3.2.3/bin/gcc -O2 -march=i486 -Wall test.c; ./a.out
foobarbaz
$ /usr/local/DIR/gcc-3.2.3/bin/gcc -O2 -march=pentium -Wall test.c; ./a.out
$ /usr/local/DIR/gcc-3.2.3/bin/gcc --version
gcc (GCC) 3.2.3


> 	-hpa

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

