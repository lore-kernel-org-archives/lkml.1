Return-Path: <linux-kernel-owner+w=401wt.eu-S1764845AbXGLRbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764845AbXGLRbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 13:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbXGLRbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 13:31:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45611 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644AbXGLRbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 13:31:44 -0400
Date: Thu, 12 Jul 2007 10:30:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86 setup code rewrite in C - revised
Message-Id: <20070712103056.52126a96.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707121016210.20061@woody.linux-foundation.org>
References: <1184181538674-git-send-email-hpa@zytor.com>
	<alpine.LFD.0.999.0707121016210.20061@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007 10:24:48 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 11 Jul 2007, H. Peter Anvin wrote:
> >
> > This patch set replaces the x86 setup code, which is currently all in
> > assembly, with a version written in C, using the ".code16gcc" feature
> > of binutils (which has been present since at least 2001.)
> >
> >  76 files changed, 4606 insertions(+), 5209 deletions(-)
> 
> I can't really argue against this on any sane grounds - not only is it 
> removing more lines than it adds, but moving from mostly unreadable 
> assembly to C seems a good idea.
> 
> How does this impact the size of that code? Do we even care?
> 
> But as to how to integrate it, I'm not sure I really want to just merge 
> it. I suspect we would want to have it in some public tree that people 
> actually test at least to some degree first, and the -mm tree seems to 
> make most sense.
> 
> I didn't see anything objectionable in the series, although I do think the 
> explanations need to be re-done for a number of them. You seem to have 
> violated the "a single line to explain the patch at the top" rule, and as 
> a result they make no sense for some of them (the explanation for patch 
> 05/33 doesn't parse for me and 07/33 seems to have the single-line 
> problem)
> 
> So let's just get this merged. But the question is, do we put it in 
> 2.6.23-rc1, or do we put it in -mm for a few weeks, which would imply 
> waiting for the next merge window? Andrew?
> 

This code has been in -mm since 11 May, as git-newsetup.patch.  It has
caused (for what it is) astonishingly few problems.  Maybe a couple of
build glitches and one runtime failure, all quickly fixed.

I'd say it's ready.
