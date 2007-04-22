Return-Path: <linux-kernel-owner+w=401wt.eu-S932263AbXDVISh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbXDVISh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 04:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932279AbXDVISh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 04:18:37 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932263AbXDVISg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 04:18:36 -0400
Date: Sun, 22 Apr 2007 01:18:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE
Message-Id: <20070422011810.e76685cc.akpm@linux-foundation.org>
In-Reply-To: <46247427.6000902@redhat.com>
References: <46247427.6000902@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007 03:15:51 -0400 Rik van Riel <riel@redhat.com> wrote:

> Make it possible for applications to have the kernel free memory
> lazily.  This reduces a repeated free/malloc cycle from freeing
> pages and allocating them, to just marking them freeable.  If the
> application wants to reuse them before the kernel needs the memory,
> not even a page fault will happen.
> 
> This patch, together with Ulrich's glibc change, increases
> MySQL sysbench performance by a factor of 2 on my quad core
> test system.
> 

In file included from include/linux/mman.h:4,
                 from arch/sparc64/kernel/sys_sparc.c:19:
include/asm/mman.h:36:1: "MADV_FREE" redefined
In file included from include/asm/mman.h:5,
                 from include/linux/mman.h:4,
                 from arch/sparc64/kernel/sys_sparc.c:19:
include/asm-generic/mman.h:32:1: this is the location of the previous definition

sparc32 and sparc64 already defined MADV_FREE:


#define MADV_FREE       0x5             /* (Solaris) contents can be freed */

I'll remove the sparc definitions for now, but we need to work out what
we're going to do here.  Your patch changes the values of MADV_FREE on
sparc.

Perhaps this should be renamed to MADV_FREE_LINUX and given a different
number.  It depends on how close your proposed behaviour is to Solaris's.

