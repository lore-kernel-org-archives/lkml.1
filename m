Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbYD0S62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbYD0S62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 14:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbYD0S6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 14:58:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750783AbYD0S6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 14:58:16 -0400
Date: Sun, 27 Apr 2008 11:57:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Sam Ravnborg <sam@ravnborg.org>, linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] prepare kconfig inline optimization for all
 architectures
In-Reply-To: <20080427184106.GD2252@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0804271150050.3119@woody.linux-foundation.org>
References: <20080427105100.GA14795@uranus.ravnborg.org> <20080427113158.GY2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271002360.2896@woody.linux-foundation.org> <20080427172235.GA2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271029130.2896@woody.linux-foundation.org>
 <20080427174714.GB2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271053300.2896@woody.linux-foundation.org> <20080427184106.GD2252@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 27 Apr 2008, Adrian Bunk wrote:

> On Sun, Apr 27, 2008 at 11:11:27AM -0700, Linus Torvalds wrote:
> > 
> > For example, what's wrong with having "inline" on functions in .c files if 
> > the author thinks they are small enough? He's likely right. Considering 
> > past behaviour, he's quite often more right than the compiler.
> >...
> 
> Ingo's commit in your tree just broke this assumption.

Note that our problem is too much inlining, not too little.

I'm actually happier with gcc not deciding to inline (despite having an 
"inline") than I am with gcc deciding to inline (in violation of _not_ 
having an "inline").

So I don't disagree with Ingo's commit per se.

The only problem with not inlining is a historical one: exactly because 
gcc _used_ to always do what people asked for, Linux has historically 
treated "inline" as a "force_inline". And I was very unhappy when gcc 
changed that, just because it broke historically good code.

In many ways, it might have been better if we had a "__may_inline" thing 
to tell the compiler "you can inline this if you think it's worth it"). 
Both gcc (long ago) and Ingo (now) decided to just make plain "inline" 
mean that, but with a pretty strong bias. It was wrong for gcc to do so, 
imho, and it may have been wrong for this OPTIMIZE_INLINE thing too.

			Linus
