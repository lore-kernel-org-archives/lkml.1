Return-Path: <linux-kernel-owner+w=401wt.eu-S933320AbXBGGbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320AbXBGGbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 01:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933326AbXBGGbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 01:31:35 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:33757 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933327AbXBGGbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 01:31:34 -0500
Date: Wed, 7 Feb 2007 15:29:34 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@osdl.org>, Hugh Dickins <hugh@veritas.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3 take2] smaps: extract pte walker from smaps code
Message-ID: <20070207062934.GA11967@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	David Rientjes <rientjes@google.com>, Andrew Morton <akpm@osdl.org>,
	Hugh Dickins <hugh@veritas.com>,
	Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0702062212550.13931@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702062212550.13931@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 10:15:47PM -0800, David Rientjes wrote:
> Extracts the page table entry walker from the smaps-specific code in
> fs/proc/task_mmu.c.  This will be used later for clearing the reference
> bits on pages to measure the number of pages accessed over a time period
> through /proc/pid/smaps.
> 
I like the general idea of this patch set, however..

> Since the PTE walker is now extracted from the smaps code,
> smaps_pte_func() is invoked for each PTE in the VMA.  Its behavior is
> identical to the existing implementation, except it is slightly slower
> because each PTE now invokes a function call.
> 
Perhaps this is something that needs to be looked at more closely and
made more generic? There are many ranged page table walkers that aren't
so performance critical that the function call cost would cause too much
pain. ioremap_page_range() comes to mind, and there's bound to be others.
This would also help people to get the pte map/unmap right, which seems
to pop up from time to time as well..
