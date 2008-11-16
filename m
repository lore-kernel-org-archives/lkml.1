Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbYKPXzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbYKPXzj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 18:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbYKPXza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 18:55:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751674AbYKPXz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 18:55:29 -0500
Date: Sun, 16 Nov 2008 15:55:10 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Helge Deller <deller@gmx.de>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Kyle Mc Martin <kyle@hera.kernel.org>, linux-parisc@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH, 2.6.28-rc5] unitialized return value in mm/mlock.c:
 __mlock_vma_pages_range()
In-Reply-To: <200811170030.58246.deller@gmx.de>
Message-ID: <alpine.LFD.2.00.0811161551540.3468@nehalem.linux-foundation.org>
References: <200811170030.58246.deller@gmx.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Nov 2008, Helge Deller wrote:
>
> Fix an unitialized return value when compiling on parisc (with CONFIG_UNEVICTABLE_LRU=y):
> 	mm/mlock.c: In function `__mlock_vma_pages_range':
> 	mm/mlock.c:165: warning: `ret' might be used uninitialized in this function

Looks valid.

Of course, nobody should ever call this with a range that could possibly 
be empty, so an equally valid approach would be to change the "while" loop 
to a "do while()", and that would generate better code. But I guess the 
simple unnecessary initialization is more defensive programming, in that 
if some other buggy caller does set things up with an empty range, it gets 
the right result.

Btw, exactly _because_ gcc warnings about uninitialized functions are 
sometimes bogus (ie due to gcc simply not being able to follow things like 
conditional initializations where the values are only used if they were 
initialized), I would ask that people comment on these kinds of issues 
when they send in patches. 

		Linus
