Return-Path: <linux-kernel-owner+w=401wt.eu-S1759046AbYG1Ufx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759046AbYG1Ufx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 16:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbYG1Ufp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 16:35:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773AbYG1Ufo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 16:35:44 -0400
Date: Mon, 28 Jul 2008 13:35:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-kernel@vger.kernel.org, mhalcrow@us.ibm.com, stable@kernel.org
Subject: Re: [PATCH] eCryptfs - use page_alloc not kmalloc to get a page of
 memory
Message-Id: <20080728133504.156f438f.akpm@linux-foundation.org>
In-Reply-To: <488DF00F.3080809@redhat.com>
References: <488DF00F.3080809@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 11:13:03 -0500
Eric Sandeen <sandeen@redhat.com> wrote:

> With SLUB debugging turned on in 2.6.26, I was getting memory corruption
> when testing eCryptfs.  The root cause turned out to be that eCryptfs
> was doing kmalloc(PAGE_CACHE_SIZE); virt_to_page() and treating that
> as a nice page-aligned chunk of memory.  But at least with SLUB debugging
> on, this is not always true, and the page we get from virt_to_page does
> not necessarily match the PAGE_CACHE_SIZE worth of memory we got from 
> kmalloc.
> 
> My simple testcase was 2 loops doing "rm -f fileX; cp /tmp/fileX ." for
> 2 different multi-megabyte files.  With this change I no longer see
> the corruption.

The fix applies to both 2.6.25 and to 2.6.26 and appears to be needed
in both kernel versions, so I have tagged it for backporting into both.

