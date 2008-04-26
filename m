Return-Path: <linux-kernel-owner+w=401wt.eu-S1762434AbYDZVMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762434AbYDZVMV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 17:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755177AbYDZVMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 17:12:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755084AbYDZVMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 17:12:13 -0400
Date: Sat, 26 Apr 2008 14:11:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai.lu@sun.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, jbarnes@virtuousgeek.org
Subject: Re: [git pull] "big box" x86 changes, boot protocol
In-Reply-To: <20080426210632.GW2252@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0804261410320.2813@woody.linux-foundation.org>
References: <20080426185516.GA32364@elte.hu> <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org> <20080426195407.GA13729@elte.hu> <20080426133928.a6f40caa.akpm@linux-foundation.org> <20080426210632.GW2252@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 27 Apr 2008, Adrian Bunk wrote:

> On Sat, Apr 26, 2008 at 01:39:28PM -0700, Andrew Morton wrote:
> > On Sat, 26 Apr 2008 21:54:07 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> >...
> > > +
> > > +	memcpy(&early_res[i], &early_res[i + 1],
> > > +	       (j - 1 - i) * sizeof(struct early_res));
> > 
> > nit: memcpy() shouldn't be used for overlapping copies.  It happens to be
> > OK (for dst<src) in the kernel implementations.  We hope.
> >...
> 
> We always use the gcc builtin for memcpy() here.

It's probably hard to write a reasonable x86 memcpy() that wouldn't happen 
to do the right thing for this case, but I do agee - we should still use 
memmove() for this, just to make it clear that it does overlapping things.

		Linus
