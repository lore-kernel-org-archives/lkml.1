Return-Path: <linux-kernel-owner+w=401wt.eu-S934402AbYEHXAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934402AbYEHXAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765341AbYEHXAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:00:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763560AbYEHXAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:00:18 -0400
Date: Thu, 8 May 2008 16:00:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rene Herman <rene.herman@keyaccess.nl>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: GIT bisection range errors
In-Reply-To: <48237CA0.4080001@keyaccess.nl>
Message-ID: <alpine.LFD.1.10.0805081557580.2940@woody.linux-foundation.org>
References: <48237CA0.4080001@keyaccess.nl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 May 2008, Rene Herman wrote:
> 
> I'm in a git bisect and am experiencing strangeness. I did a
> 
> $ git checkout -b rc v2.6.26-rc1
> $ git bisect start
> $ git bisect bad
> $ git bisect good v2.6.25
> 
> Yet, during this I'm finding myself at 2.6.25-rc6 and 2.6.25-rc8
> as the last two results (both good...).

This is very normal.

Why?

Because a lot (in fact, *most*) of the code that was merged after v2.6.25 
was released was actually *written* and committed long before v2.6.25.

It just got merged into my tree much later.

So what happens? The bisection run starts walking into all that history, 
and that history is *not* based on the released v2.6.25 at all, it's based 
on much earlier kernels (eg the -rc kernels).

So what you see is perfectly normal and expected. It's only unexpected if 
you think of history as a linear thing, but it isn't - it's full of 
merging of code that was branched off from (much) earlier code points.

		Linus
