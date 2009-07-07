Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbZGGUdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbZGGUdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 16:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbZGGUdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 16:33:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753982AbZGGUdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 16:33:05 -0400
Date: Tue, 7 Jul 2009 13:30:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
cc: Linux-fbdev-devel <linux-fbdev-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, rjw@sisk.pl, stable@kernel.org
Subject: Re: matroxfb: fix regression with uninitalized fb_info->mm_lock
 mutex (second head)
In-Reply-To: <20090707223413.d56c6a7f.krzysztof.h1@poczta.fm>
Message-ID: <alpine.LFD.2.01.0907071327370.3210@localhost.localdomain>
References: <20090707223413.d56c6a7f.krzysztof.h1@poczta.fm>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 7 Jul 2009, Krzysztof Helt wrote:
> 
> Remove redundant locking by the mm_lock mutex before a second head of matrox 
> framebuffer is registered.

Why do you write misleading commentary like this.

> +/*
> + * This function is called before the register_framebuffer so
> + * no locking is needed.
> + */

Or this?

It's not about "needed". The locking is not only not needed, it would be 
BUGGY.

And it's not "redundant". That implies that it's done somewhere else. It's 
more than "not needed" - it would be actively buggy to lock things there.

I really don't like how you're approaching this. You're ignoring the real 
issues I ask you, you're writing misleading comments and commit messages, 
and the end result is fragile code. I still don't understand why you 
insist on initializing those things late, which is the primary problem 
here.

		Linus
