Return-Path: <linux-kernel-owner+w=401wt.eu-S1763541AbXF0WbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763541AbXF0WbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 18:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759790AbXF0WbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 18:31:15 -0400
Received: from smtpout.mac.com ([17.250.248.172]:58147 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759064AbXF0WbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 18:31:14 -0400
In-Reply-To: <20070627173240.GR1094@stusta.de>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de> <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm> <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de> <1182483527.10524.31.camel@shinybook.infradead.org> <20070622150038.GN23017@stusta.de> <E27BAC4D-2F1E-4191-A75D-4DD18231C320@mac.com> <20070627154046.GN1094@stusta.de> <468287a8.spBb6PdAZ4QV0j2Y%Joerg.Schilling@fokus.fraunhofer.de> <20070627173240.GR1094@stusta.de>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <B3C8EEBF-71FB-4169-8ED7-7C4A410BBEE1@mac.com>
Cc: LKML Kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, david@lang.hm,
       linux-arch@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Userspace compiler support of "long long"
Date: Wed, 27 Jun 2007 18:30:52 -0400
To: Adrian Bunk <bunk@stusta.de>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 27, 2007, at 13:32:40, Adrian Bunk wrote:
> AFAIR the Intel compiler claims to be gcc.
>
> But these are by far not the only C compilers under Linux, and the  
> more important points are:
>
> Is there any userspace Linux compiler that does not support "long  
> long"?

Don't know, but I'd guess not.


> If yes, is there any other way to tell that something is a 64bit  
> int on 32bit architectures?

Not that I know of.  Probably the straight #else conditional is OK.   
We should also merge up the types since *EVERY* linux architecture  
has these same types:

typedef   signed char      __s8;
typedef unsigned char      __u8;
typedef   signed short     __s16;
typedef unsigned short     __u16;
typedef   signed int       __s32;
typedef unsigned int       __u32;

Then all 64-bit archs have:
typedef   signed long      __s64;
typedef unsigned long      __u64;

While all 32-bit archs have:
typedef   signed long long __s64;
typedef unsigned long long __u64;

The only trick is if you care about building 32-bit compat code using  
64-bit linux kernel headers.  In that case we should probably just  
make all archs use "long long" for their 64-bit integers, unless  
there's some platform I'm not remembering where "long long" is 128- 
bits or bigger.  The other benefit is that people could then just use  
the printf format "%llu" for 64-bit integers instead of having to  
conditionalize it all over the place.

I'm working on a patch now.

Cheers,
Kyle Moffett

