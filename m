Return-Path: <linux-kernel-owner+w=401wt.eu-S1763698AbXF0W7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763698AbXF0W7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 18:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761824AbXF0W6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 18:58:54 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:45970 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbXF0W6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 18:58:53 -0400
Date: Wed, 27 Jun 2007 15:57:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Adrian Bunk <bunk@stusta.de>, LKML Kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, david@lang.hm,
       linux-arch@vger.kernel.org
Subject: Re: Userspace compiler support of "long long"
Message-Id: <20070627155715.60ebc48f.randy.dunlap@oracle.com>
In-Reply-To: <B3C8EEBF-71FB-4169-8ED7-7C4A410BBEE1@mac.com>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
	<Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
	<467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de>
	<1182483527.10524.31.camel@shinybook.infradead.org>
	<20070622150038.GN23017@stusta.de>
	<E27BAC4D-2F1E-4191-A75D-4DD18231C320@mac.com>
	<20070627154046.GN1094@stusta.de>
	<468287a8.spBb6PdAZ4QV0j2Y%Joerg.Schilling@fokus.fraunhofer.de>
	<20070627173240.GR1094@stusta.de>
	<B3C8EEBF-71FB-4169-8ED7-7C4A410BBEE1@mac.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 18:30:52 -0400 Kyle Moffett wrote:

> On Jun 27, 2007, at 13:32:40, Adrian Bunk wrote:
> > AFAIR the Intel compiler claims to be gcc.
> >
> > But these are by far not the only C compilers under Linux, and the  
> > more important points are:
> >
> > Is there any userspace Linux compiler that does not support "long  
> > long"?
> 
> Don't know, but I'd guess not.
> 
> 
> > If yes, is there any other way to tell that something is a 64bit  
> > int on 32bit architectures?
> 
> Not that I know of.  Probably the straight #else conditional is OK.   
> We should also merge up the types since *EVERY* linux architecture  
> has these same types:
> 
> typedef   signed char      __s8;
> typedef unsigned char      __u8;
> typedef   signed short     __s16;
> typedef unsigned short     __u16;
> typedef   signed int       __s32;
> typedef unsigned int       __u32;
> 
> Then all 64-bit archs have:
> typedef   signed long      __s64;
> typedef unsigned long      __u64;
> 
> While all 32-bit archs have:
> typedef   signed long long __s64;
> typedef unsigned long long __u64;
> 
> The only trick is if you care about building 32-bit compat code using  
> 64-bit linux kernel headers.  In that case we should probably just  
> make all archs use "long long" for their 64-bit integers, unless  
> there's some platform I'm not remembering where "long long" is 128- 
> bits or bigger.  The other benefit is that people could then just use  
> the printf format "%llu" for 64-bit integers instead of having to  
> conditionalize it all over the place.
> 
> I'm working on a patch now.

LDD3 ch. 11 says that long on Sparc64 is 32 bits.
Same for "ppc" (don't know which power* arch. they mean by that).

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
