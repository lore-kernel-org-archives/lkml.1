Return-Path: <linux-kernel-owner+w=401wt.eu-S1764082AbZFLJzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764082AbZFLJzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760459AbZFLJzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:55:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39120 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760162AbZFLJzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:55:08 -0400
Date: Fri, 12 Jun 2009 12:03:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 2/5] HWPOISON: fix tasklist_lock/anon_vma locking order
Message-ID: <20090612100308.GD25568@one.firstfloor.org>
References: <20090611142239.192891591@intel.com> <20090611144430.540500784@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611144430.540500784@intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 10:22:41PM +0800, Wu Fengguang wrote:
> To avoid possible deadlock. Proposed by Nick Piggin:

I disagree with the description. There's no possible deadlock right now.
It would be purely out of paranoia.

> 
>   You have tasklist_lock(R) nesting outside i_mmap_lock, and inside anon_vma
>   lock. And anon_vma lock nests inside i_mmap_lock.
> 
>   This seems fragile. If rwlocks ever become FIFO or tasklist_lock changes

I was a bit dubious on this reasoning. If rwlocks become FIFO a lot of
stuff will likely break.

>   type (maybe -rt kernels do it), then you could have a task holding

I think they tried but backed off quickly again

It's ok with a less scare-mongering description.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
