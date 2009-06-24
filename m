Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbZFXPHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbZFXPHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 11:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbZFXPHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 11:07:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:51127 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbZFXPHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 11:07:07 -0400
Date: Wed, 24 Jun 2009 08:07:53 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: upcoming kerneloops.org item: get_page_from_freelist
Message-ID: <20090624080753.4f677847@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

a new item is coming up fast in the kerneloops.org stats, and it's new
in 2.6.31-rc;

http://www.kerneloops.org/searchweek.php?search=get_page_from_freelist

it's this warning in mm/page_alloc.c:

                        * __GFP_NOFAIL is not to be used in new code.
                         *
                         * All __GFP_NOFAIL callers should be fixed so that they
                         * properly detect and handle allocation failures.
                         *
                         * We most definitely don't want callers attempting to
                         * allocate greater than single-page units with
                         * __GFP_NOFAIL.
                         */
                        WARN_ON_ONCE(order > 0);
  

typical backtraces look like

get_page_from_freelist
__alloc_pages_nodemask
alloc_pages_current
alloc_slab_page
new_slab
__slab_alloc
kmem_cache_alloc_notrace
start_this_handle
jbd2_journal_start

and

get_page_from_freelist
__alloc_pages_nodemask
alloc_pages_current
alloc_slab_page
new_slab
__slab_alloc
kmem_cache_alloc_notrace
start_this_handle
journal_start
ext3_journal_start_sb
ext3_journal_start
ext3_dirty_inode

but there are some other ones as well at the url above.


git blame shows that 

commit dab48dab37d2770824420d1e01730a107fade1aa
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Tue Jun 16 15:32:37 2009 -0700

introduced this WARN_ON.....



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
