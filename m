Return-Path: <linux-kernel-owner+w=401wt.eu-S1762476AbYD0RlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762476AbYD0RlJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 13:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758016AbYD0Rk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 13:40:58 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:56532 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757892AbYD0Rk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 13:40:57 -0400
Date: Sun, 27 Apr 2008 11:40:56 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] prepare kconfig inline optimization for all architectures
Message-ID: <20080427174055.GS14990@parisc-linux.org>
References: <20080427105100.GA14795@uranus.ravnborg.org> <20080427113158.GY2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804271002360.2896@woody.linux-foundation.org> <20080427172235.GA2252@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427172235.GA2252@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 08:22:35PM +0300, Adrian Bunk wrote:
> I'm looking at it from a different angle, all code in the kernel should 
> follow the following rules [1]:
> - no functions in .c files should be marked inline
> - all functions in headers should be static inline
> - all functions in headers should either be very small or collapse
>   to become very small after inlining
> 
> I can simply not see any usecase for a non-forced inline in the kernel,
> and fixing the kernel should give a superset of the space savings of 
> this "inline optimization".

Here's a good counterexample: kernel/mutex.c.

__mutex_lock_common wants to be inlined into __mutex_lock_*_slowpath.
and *_slowpath *shouldn't* be inlined into mutex_lock_*.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
