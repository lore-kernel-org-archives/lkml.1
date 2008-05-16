Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbYEPBry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbYEPBry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 21:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbYEPBro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 21:47:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514AbYEPBrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 21:47:43 -0400
Date: Thu, 15 May 2008 18:47:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: gorcunov@gmail.com, geert@linux-m68k.org, zippel@linux-m68k.org,
       schwab@suse.de, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org
Subject: Re: [PATCH] init - fix building bug and potential buffer overflow
In-Reply-To: <20080515144554.7b759b3c.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805151844440.2941@woody.linux-foundation.org>
References: <20080514154402.GF6902@cvg> <20080515105803.7c9ab8c7.akpm@linux-foundation.org> <20080515180528.GC7481@cvg> <Pine.LNX.4.64.0805152132530.22059@anakin> <aa79d98a0805151322s20a2bb34x4491bcacfcef310@mail.gmail.com> <20080515134928.83b2d948.akpm@linux-foundation.org>
 <alpine.LFD.1.10.0805151406030.3019@woody.linux-foundation.org> <20080515144554.7b759b3c.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 May 2008, Andrew Morton wrote:
> 
> this, basically:
> 
> >  init/main.c |   78 +++++++++++++++++++++++++++++++----------------------------
> >  1 files changed, 41 insertions(+), 37 deletions(-)
> 
> the dont-mix-bugfixes-and-cleanups mantra.

Sure. I committed them as two separate things.

The point *I* had was that we don't make source code uglier for arbitrary 
reasons. The checkpatch.pl script shouldn't be powerful enough that we do 
uglier source code and break arbitrary rules just to make that script 
happy.

So either we should sy "screw the script, it's wrong", or we should just 
not fix the bug. Or we should say "ok, I can write even _better_ source 
code, and fix the bug, make the source look nicer _and_ not piss off the 
script too".

> > Would somebody please want to move that cast into the macro (or better 
> > yet, make it an inline function that takes a 'void *'), and remove all the 
> > casts from the callers?
> 
> Would be nice.

So I did that too.

		Linus
