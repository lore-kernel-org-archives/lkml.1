Return-Path: <linux-kernel-owner+w=401wt.eu-S1759694AbYG3In4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759694AbYG3In4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 04:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756119AbYG3Inr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 04:43:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752489AbYG3Inq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 04:43:46 -0400
Date: Wed, 30 Jul 2008 01:41:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Munson <ebmunson@us.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       libhugetlbfs-devel@lists.sourceforge.net
Subject: Re: [RFC] [PATCH 0/5 V2] Huge page backed user-space stacks
Message-Id: <20080730014139.39b3edc5.akpm@linux-foundation.org>
In-Reply-To: <cover.1216928613.git.ebmunson@us.ibm.com>
References: <cover.1216928613.git.ebmunson@us.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 12:17:10 -0700 Eric Munson <ebmunson@us.ibm.com> wrote:

> Certain workloads benefit if their data or text segments are backed by
> huge pages. The stack is no exception to this rule but there is no
> mechanism currently that allows the backing of a stack reliably with
> huge pages.  Doing this from userspace is excessively messy and has some
> awkward restrictions.  Particularly on POWER where 256MB of address space
> gets wasted if the stack is setup there.
> 
> This patch stack introduces a personality flag that indicates the kernel
> should setup the stack as a hugetlbfs-backed region. A userspace utility
> may set this flag then exec a process whose stack is to be backed by
> hugetlb pages.
> 
> Eric Munson (5):
>   Align stack boundaries based on personality
>   Add shared and reservation control to hugetlb_file_setup
>   Split boundary checking from body of do_munmap
>   Build hugetlb backed process stacks
>   [PPC] Setup stack memory segment for hugetlb pages
> 
>  arch/powerpc/mm/hugetlbpage.c |    6 +
>  arch/powerpc/mm/slice.c       |   11 ++
>  fs/exec.c                     |  209 ++++++++++++++++++++++++++++++++++++++---
>  fs/hugetlbfs/inode.c          |   52 +++++++----
>  include/asm-powerpc/hugetlb.h |    3 +
>  include/linux/hugetlb.h       |   22 ++++-
>  include/linux/mm.h            |    1 +
>  include/linux/personality.h   |    3 +
>  ipc/shm.c                     |    2 +-
>  mm/mmap.c                     |   11 ++-
>  10 files changed, 284 insertions(+), 36 deletions(-)

That all looks surprisingly straightforward.

Might there exist an x86 port which people can play with?
