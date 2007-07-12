Return-Path: <linux-kernel-owner+w=401wt.eu-S1765034AbXGLRZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765034AbXGLRZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 13:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbXGLRZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 13:25:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54442 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753071AbXGLRZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 13:25:01 -0400
Date: Thu, 12 Jul 2007 10:24:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: andi@firstfloor.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: x86 setup code rewrite in C - revised
In-Reply-To: <1184181538674-git-send-email-hpa@zytor.com>
Message-ID: <alpine.LFD.0.999.0707121016210.20061@woody.linux-foundation.org>
References: <1184181538674-git-send-email-hpa@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Jul 2007, H. Peter Anvin wrote:
>
> This patch set replaces the x86 setup code, which is currently all in
> assembly, with a version written in C, using the ".code16gcc" feature
> of binutils (which has been present since at least 2001.)
>
>  76 files changed, 4606 insertions(+), 5209 deletions(-)

I can't really argue against this on any sane grounds - not only is it 
removing more lines than it adds, but moving from mostly unreadable 
assembly to C seems a good idea.

How does this impact the size of that code? Do we even care?

But as to how to integrate it, I'm not sure I really want to just merge 
it. I suspect we would want to have it in some public tree that people 
actually test at least to some degree first, and the -mm tree seems to 
make most sense.

I didn't see anything objectionable in the series, although I do think the 
explanations need to be re-done for a number of them. You seem to have 
violated the "a single line to explain the patch at the top" rule, and as 
a result they make no sense for some of them (the explanation for patch 
05/33 doesn't parse for me and 07/33 seems to have the single-line 
problem)

So let's just get this merged. But the question is, do we put it in 
2.6.23-rc1, or do we put it in -mm for a few weeks, which would imply 
waiting for the next merge window? Andrew?

			Linus
