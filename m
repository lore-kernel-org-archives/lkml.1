Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYILP61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYILP61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 11:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYILP6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 11:58:19 -0400
Received: from waste.org ([66.93.16.53]:42115 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbYILP6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 11:58:18 -0400
Subject: Re: [PATCH -mm 1/2] sort: Add obj_sort() for sorting all kinds of
	random-accessible objects
From: Matt Mackall <mpm@selenic.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <48CA58A4.8020902@cn.fujitsu.com>
References: <48CA58A4.8020902@cn.fujitsu.com>
Content-Type: text/plain
Date: Fri, 12 Sep 2008 10:56:04 -0500
Message-Id: <1221234964.5277.482.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-09-12 at 19:55 +0800, Lai Jiangshan wrote:
> current sort can only sort objects on continuous memory,
> but sometimes we need to sort objects on noncontinuous memory,
> this patch provide obj_sort() for this.
> 
> Sometimes a C struct(the container of objects, or objects) may be designed
> with some high-level language's semantic meaning. obj_sort() can sort
> for them.
>
> obj_sort() is need for sort pids for cgroup.tasks file.

Ok, if I understand this correctly, your new function basically changes:

cmp(void *a, void *b)            to cmp(void *obj, int a, int b)
swap(void *a, void *b, int size) to swap(void *obj, int a, int b)

Since neither function actually looks at the data directly, it seems we
could make a unified sort function with:

cmp(void *base, int a, int b)
swap(void *base, int a, int b, int size)

What is the underlying data structure you're sorting by the way? Years
ago, I wrote a very nice merge sort for linked lists that I never got
around to submitting. 

-- 
Mathematics is the supreme nostalgia of our time.

