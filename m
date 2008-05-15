Return-Path: <linux-kernel-owner+w=401wt.eu-S1764129AbYEOVrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764129AbYEOVrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 17:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbYEOVrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 17:47:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753443AbYEOVrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 17:47:09 -0400
Date: Thu, 15 May 2008 14:45:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: gorcunov@gmail.com, geert@linux-m68k.org, zippel@linux-m68k.org,
       schwab@suse.de, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org
Subject: Re: [PATCH] init - fix building bug and potential buffer overflow
Message-Id: <20080515144554.7b759b3c.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805151406030.3019@woody.linux-foundation.org>
References: <20080514154402.GF6902@cvg>
	<20080515105803.7c9ab8c7.akpm@linux-foundation.org>
	<20080515180528.GC7481@cvg>
	<Pine.LNX.4.64.0805152132530.22059@anakin>
	<aa79d98a0805151322s20a2bb34x4491bcacfcef310@mail.gmail.com>
	<20080515134928.83b2d948.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0805151406030.3019@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 14:15:38 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 15 May 2008, Andrew Morton wrote:
> > 
> > (yeah, I normally parenthesise sizeof too, but this provided 80-col
> > salvation)
> 
> Why?

this, basically:

>  init/main.c |   78 +++++++++++++++++++++++++++++++----------------------------
>  1 files changed, 41 insertions(+), 37 deletions(-)

the dont-mix-bugfixes-and-cleanups mantra.

The patch looks good to me and compiles cleanly on various architectures.

> Talking about cleanups, why the *hell* does print_fn_descriptor_symbol() 
> take an "unsigned long", when every single user would want to give it a 
> pointer?

Yes, we make that mistake fairly regularly (looks at timer_list.data). 
We start out not being sure whether most callers will pass in a ulong
or a pointer and guess wrongly.

> Would somebody please want to move that cast into the macro (or better 
> yet, make it an inline function that takes a 'void *'), and remove all the 
> casts from the callers?

Would be nice.

