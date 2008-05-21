Return-Path: <linux-kernel-owner+w=401wt.eu-S936550AbYEUSwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936550AbYEUSwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757237AbYEUSw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:52:28 -0400
Received: from relay1.sgi.com ([192.48.171.29]:32940 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756394AbYEUSw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:52:27 -0400
Date: Wed, 21 May 2008 11:52:25 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, mpm@selenic.com, lethal@linux-sh.org,
       dhowells@redhat.com
Subject: Re: [RFC/PATCH 2/3] SLUB: make ksize() more strict for page allocator
 pass-through
In-Reply-To: <Pine.LNX.4.64.0805212125310.22291@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0805211149210.16064@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805212125310.22291@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Pekka J Enberg wrote:

> This patch changes ksize() to be more strict with objets passed to it. We now
> set PageSlab also for objects allocated with page allocator and use page->slab
> to check whether page is a regular slab page or a pass-through page.
> 
> Also moves kmalloc_large() out-of-line as it's too big for inlining now.

Why is it too big? Without your additions it is converting kmallocs 
inline to get_free_pages(). That results in a simple function call with 
two constant parameters.

The patch touches the page struct uselessly. I think the PageSlab marking 
is useful for debugging but not for a production kernel.
