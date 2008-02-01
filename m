Return-Path: <linux-kernel-owner+w=401wt.eu-S934907AbYBAFBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934907AbYBAFBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 00:01:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933204AbYBAEoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:44:06 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48664 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764596AbYBAEoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:44:05 -0500
Date: Thu, 31 Jan 2008 20:43:58 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Robin Holt <holt@sgi.com>
cc: Andrea Arcangeli <andrea@qumranet.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 2/3] mmu_notifier: Callbacks to invalidate address ranges
In-Reply-To: <20080201042408.GG26420@sgi.com>
Message-ID: <Pine.LNX.4.64.0801312042500.20675@schroedinger.engr.sgi.com>
References: <20080131045750.855008281@sgi.com> <20080131045812.785269387@sgi.com>
 <20080201042408.GG26420@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, Robin Holt wrote:

> > Index: linux-2.6/mm/memory.c
> ...
> > @@ -1668,6 +1678,7 @@ gotten:
> >  		page_cache_release(old_page);
> >  unlock:
> >  	pte_unmap_unlock(page_table, ptl);
> > +	mmu_notifier(invalidate_range_end, mm, 0);
> 
> I think we can get an _end call without the _begin call before it.

If that would be true then also the pte would have been left locked.

We always hit unlock. Maybe I just do not see it?

