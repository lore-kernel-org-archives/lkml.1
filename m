Return-Path: <linux-kernel-owner+w=401wt.eu-S934184AbYEGWoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934184AbYEGWoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbYEGWoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:44:15 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:37172
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761795AbYEGWoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:44:12 -0400
Date: Thu, 8 May 2008 00:44:06 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, clameter@sgi.com, steiner@sgi.com,
       holt@sgi.com, npiggin@suse.de, a.p.zijlstra@chello.nl,
       kvm-devel@lists.sourceforge.net, kanojsarcar@yahoo.com,
       rdreier@cisco.com, swise@opengridcomputing.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       general@lists.openfabrics.org, hugh@veritas.com, rusty@rustcorp.com.au,
       aliguori@us.ibm.com, chrisw@redhat.com, marcelo@kvack.org,
       dada1@cosmosbay.com, paulmck@us.ibm.com
Subject: Re: [PATCH 08 of 11] anon-vma-rwsem
Message-ID: <20080507224406.GI8276@duo.random>
References: <6b384bb988786aa78ef0.1210170958@duo.random> <alpine.LFD.1.10.0805071349200.3024@woody.linux-foundation.org> <20080507212650.GA8276@duo.random> <alpine.LFD.1.10.0805071429170.3024@woody.linux-foundation.org> <20080507222205.GC8276@duo.random> <20080507153103.237ea5b6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507153103.237ea5b6.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 03:31:03PM -0700, Andrew Morton wrote:
> Nope.  We only need to take the global lock before taking *two or more* of
> the per-vma locks.
> 
> I really wish I'd thought of that.

I don't see how you can avoid taking the system-wide-global lock
before every single anon_vma->lock/i_mmap_lock out there without
mm_lock.

Please note, we can't allow a thread to be in the middle of
zap_page_range while mmu_notifier_register runs.

vmtruncate takes 1 single lock, the i_mmap_lock of the inode. Not more
than one lock and we've to still take the global-system-wide lock
_before_ this single i_mmap_lock and no other lock at all.

Please elaborate, thanks!
