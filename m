Return-Path: <linux-kernel-owner+w=401wt.eu-S1761882AbYD0RH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761882AbYD0RH1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 13:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbYD0RHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 13:07:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753825AbYD0RHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 13:07:20 -0400
Date: Sun, 27 Apr 2008 10:06:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Sam Ravnborg <sam@ravnborg.org>, linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] prepare kconfig inline optimization for all
 architectures
In-Reply-To: <20080427113158.GY2252@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0804271002360.2896@woody.linux-foundation.org>
References: <20080427105100.GA14795@uranus.ravnborg.org> <20080427113158.GY2252@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 27 Apr 2008, Adrian Bunk wrote:
> 
> My opinion on this is still:
> "OPTIMIZE" means "work around bugs in the kernel".

No.

It means that

 - gcc used to (long ago) always honor "inline", and we had kernel code 
   that depended on that in various ways (ie required that there was no 
   return etc).

   We've been mostly replacing the ones we know about with 
   "__always_inline", but there may be some that remain. We'll find out, I 
   guess.

 - gcc was a total and utter piece of horrible crap in the inlining 
   department, doign insane things and changing their documentation to 
   match the new behaviour (and some people then claimed that it was 
   always documented that way).

   It would not inline big functions even when they statically collapsed 
   to nothing, etc.

As a result, we really couldn't afford to let gcc make any inlining 
decisions, because the compiler was simply *broken*.

			Linus

