Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbYKVHPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbYKVHPa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 02:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYKVHPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 02:15:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362AbYKVHPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 02:15:21 -0500
Date: Fri, 21 Nov 2008 23:15:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ying Han <yinghan@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Mike Waychison <mikew@google.com>, David Rientjes <rientjes@google.com>,
       Rohit Seth <rohitseth@google.com>
Subject: Re: [RFC v1][PATCH]page_fault retry with NOPAGE_RETRY
Message-Id: <20081121231511.ce59702e.akpm@linux-foundation.org>
In-Reply-To: <604427e00811212247k1fe6b63u9efe8cfe37bddfb5@mail.gmail.com>
References: <604427e00811212247k1fe6b63u9efe8cfe37bddfb5@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008 22:47:44 -0800 Ying Han <yinghan@google.com> wrote:

> page fault retry with NOPAGE_RETRY
> Allow major faults to drop the mmap_sem read lock while waitting for
> synchronous disk read. This allows another thread which wishes to grab
> down_read(mmap_sem) to proceed while the current is waitting the disk IO.

Confused.  down_read() on an rwsem will already permit multiple threads
to run that section of ccode concurrently.

The benefit here will be to permit down_write() callers (eg:
sys_mmap()) to get in there and do work.

> The patch flags current->flags to PF_FAULT_MAYRETRY as identify that the
> caller can tolerate the retry in the filemap_fault call patch.
> 
> Benchmark is done by mmap in huge file and spaw 64 thread each faulting in
> pages in reverse order, the the result shows 8% porformance hit with the
> patch.

You mean it slowed down 8%?  I'm a bit surprised - I'd have expected a
smaller slowdown for an IO-intensive thing like this.

Does it speed anything up?

