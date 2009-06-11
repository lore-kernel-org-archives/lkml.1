Return-Path: <linux-kernel-owner+w=401wt.eu-S1761082AbZFKQAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761082AbZFKQAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 12:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbZFKQAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 12:00:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46351 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929AbZFKQAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 12:00:20 -0400
Message-ID: <4A3129E3.3010309@redhat.com>
Date: Thu, 11 Jun 2009 11:59:31 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 2/5] HWPOISON: fix tasklist_lock/anon_vma locking order
References: <20090611142239.192891591@intel.com> <20090611144430.540500784@intel.com>
In-Reply-To: <20090611144430.540500784@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> To avoid possible deadlock. Proposed by Nick Piggin:
> 
>   You have tasklist_lock(R) nesting outside i_mmap_lock, and inside anon_vma
>   lock. And anon_vma lock nests inside i_mmap_lock.
> 
>   This seems fragile. If rwlocks ever become FIFO or tasklist_lock changes
>   type (maybe -rt kernels do it), then you could have a task holding
>   anon_vma lock and waiting for tasklist_lock, and another holding tasklist
>   lock and waiting for i_mmap_lock, and another holding i_mmap_lock and
>   waiting for anon_vma lock.
> 
> CC: Nick Piggin <npiggin@suse.de>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
