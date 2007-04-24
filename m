Return-Path: <linux-kernel-owner+w=401wt.eu-S1422754AbXDXRiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422754AbXDXRiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422838AbXDXRiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:38:46 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36895 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422754AbXDXRip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:38:45 -0400
Date: Tue, 24 Apr 2007 10:38:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
In-Reply-To: <Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0704241036020.8341@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
 <20070423142919.5809e03f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
 <20070423154224.15ebf8f7.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Hugh Dickins wrote:

> I've not yet looked at the patch under discussion, but this remark
> prompts me...  a couple of days ago I got very worried by the various
> hard-wired GFP_HIGHUSER allocations in mm/migrate.c and mm/mempolicy.c,
> and wondered how those would work out if someone has a blockdev mmap'ed.

Hmmm.... These not that critical given that 32 bit NUMA systems are a bit 
rare. And if a page is in the wrong area then it can be bounced before I/O 
is performed on it.
 
> (If vma->vm_file is non-NULL, we can be sure vma->vm_file->f_mapping
> is non-NULL, can't we?  Some common code assumes that, some does not:
> I've avoided cargo-cult safety below, but don't let me make it unsafe.)
> 
> 
> Is there a problem with page migration to HIGHMEM, if pages were
> mapped from a GFP_USER block device?  I failed to demonstrate any
> problem, but here's a quick fix if needed.

If a page is migrated into a different zone and then a write attempt is 
made on it then the page will be bounced into a zone from which the device
can write from. 
