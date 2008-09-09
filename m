Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbYIIQ7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbYIIQ7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbYIIQ7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:59:13 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59190 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbYIIQ7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:59:13 -0400
Date: Tue, 9 Sep 2008 19:57:28 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
Message-ID: <20080909165728.GD30160@cs181140183.pp.htv.fi>
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org> <alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 11:04:30AM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 8 Sep 2008, H. Peter Anvin wrote:
> >  
> >  config X86_GENERIC
> > -	bool "Generic x86 support"
> > +	bool "Generic x86 support" if EMBEDDED
> 
> Ok, so after having realized that this seems to be more about a bug with 
> gcc, I'm really not as convinced any more.
> 
> As far as I can tell, there are three issues:
> 
>  - "-mtune=core/core2/pentium4/.." is buggy in some gas/gcc versions on 
>    x86-32, and makes architectural choices.
> 
>    Any actual _released_ versions? Maybe it's just a current SVN issue?
> 
>    Workaround: don't use it. And yes, X86_GENERIC=y will do that, although 
>    quite frankly that seems to be dubious in itself.
>...

As far as I understood it it's a gas issue, and X86_GENERIC=y would 
therefore *not* fix the bug with gcc < 4.2 and affected binutils
since we pass -mtune=i686 for gcc < 4.2 with X86_GENERIC=y.

Anything I miss?

> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

