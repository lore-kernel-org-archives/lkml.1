Return-Path: <linux-kernel-owner+w=401wt.eu-S1759154AbYBHXlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759154AbYBHXlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbYBHXlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:41:25 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58600 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753040AbYBHXlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:41:25 -0500
Date: Fri, 8 Feb 2008 15:41:24 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Robin Holt <holt@sgi.com>
cc: Andrew Morton <akpm@linux-foundation.org>, andrea@qumranet.com,
       avi@qumranet.com, izike@qumranet.com, kvm-devel@lists.sourceforge.net,
       a.p.zijlstra@chello.nl, steiner@sgi.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, daniel.blueman@quadrics.com,
       general@lists.openfabrics.org
Subject: Re: [patch 0/6] MMU Notifiers V6
In-Reply-To: <20080208233636.GG26564@sgi.com>
Message-ID: <Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com>
References: <20080208220616.089936205@sgi.com> <20080208142315.7fe4b95e.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0802081528070.4036@schroedinger.engr.sgi.com>
 <20080208233636.GG26564@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008, Robin Holt wrote:

> > > What about ib_umem_get()?
> > 
> > Ok. It pins using an elevated refcount. Same as XPmem right now. With that 
> > we effectively pin a page (page migration will fail) but we will 
> > continually be reclaiming the page and may repeatedly try to move it. We 
> > have issues with XPmem causing too many pages to be pinned and thus the 
> > OOM getting into weird behavior modes (OOM or stop lru scanning due to 
> > all_reclaimable set).
> > 
> > An elevated refcount will also not be noticed by any of the schemes under 
> > consideration to improve LRU scanning performance.
> 
> Christoph, I am not sure what you are saying here.  With v4 and later,
> I thought we were able to use the rmap invalidation to remove the ref
> count that XPMEM was holding and therefore be able to swapout.  Did I miss
> something?  I agree the existing XPMEM does pin.  I hope we are not saying
> the XPMEM based upon these patches will not be able to swap/migrate.

Correct.

You missed the turn of the conversation to how ib_umem_get() works. 
Currently it seems to pin the same way that the SLES10 XPmem works.



