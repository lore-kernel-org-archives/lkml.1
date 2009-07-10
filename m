Return-Path: <linux-kernel-owner+w=401wt.eu-S1752037AbZGJDbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbZGJDbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 23:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZGJDbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 23:31:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376AbZGJDbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 23:31:06 -0400
Date: Thu, 9 Jul 2009 20:31:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Amerigo Wang <xiyou.wangcong@gmail.com>
cc: Changli Gao <xiaosuo@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PATCH: fd leak if pipe() is called with an invalid address.
In-Reply-To: <20090710031854.GC5694@cr0.nay.redhat.com>
Message-ID: <alpine.LFD.2.01.0907092029200.3352@localhost.localdomain>
References: <4A4C6013.9090509@gmail.com> <20090710031854.GC5694@cr0.nay.redhat.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Jul 2009, Amerigo Wang wrote:

> On Thu, Jul 02, 2009 at 03:21:55PM +0800, Changli Gao wrote:
> >fd leak if pipe() is called with an invalid address.
> >
> >Though -EFAULT is returned, the file descriptors opened by pipe() call
> >are left open.
> >
> >Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> >----
> >
> > x86/ia32/sys_ia32.c     |    5 ++++-
> > xtensa/kernel/syscall.c |    5 ++++-
> > 2 files changed, 8 insertions(+), 2 deletions(-)
> >
> >
> >--- arch/x86/ia32/sys_ia32.c.orig	2009-07-02 15:08:39.000000000 +0800
> >+++ arch/x86/ia32/sys_ia32.c	2009-07-02 15:09:49.000000000 +0800
> 
> This patch is not correctly made... You need to make the patch in the
> _upper_ directory of the top source code tree (if you don't use git),
> so that we can apply it with 'patch -p1 < XXX'.
> 
> Probably this is the reason why Linus still doesn't merge it.

No, the main reason I haven't merged it is that I don't think the patch is 
worth it. 

If you give a bad area to pipe(), there's no point in closign the file 
descriptors. It's a user-space bug. You got your file descriptors, you 
just don't know what the hell they are, because your program is sh*t. 
There's no point in the kernel trying to clean up, because the cleaned-up 
state is not any better.

			Linus
