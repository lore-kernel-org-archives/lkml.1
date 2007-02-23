Return-Path: <linux-kernel-owner+w=401wt.eu-S932374AbXBWOAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbXBWOAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 09:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932378AbXBWOAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 09:00:40 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60149 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932374AbXBWOAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 09:00:39 -0500
Date: Fri, 23 Feb 2007 06:00:37 -0800 (PST)
From: Christoph Lameter <clameter@engr.sgi.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       wli@holomorphy.com
Subject: Re: [PATCH] slab: remove colouroff from struct slab
In-Reply-To: <Pine.LNX.4.64.0702221436460.14523@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0702230550270.27654@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702221436460.14523@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007, Pekka J Enberg wrote:

> As the color offset is always within the first page of the slab,
> virt_to_page() works just fine without slabp->colouroff.

True but then we pass an address to kmem_freepages that is not the start 
of the page. kmem_freepages will then in turn call free_pages() with an 
address that is not the start of a page. free_pages() will then do another 
virt_to_page() which ignored the offset into the page again. And so the 
approach works but an uneasy feeling remains since the address we got from 
kmem_getpages() is different from what we pass to kmem_freepages().

Could you think about a way to do this in a cleaner way? Maybe use a 
struct page * in both kmem_get/freepages? Or add some comment explaining 
the situation?
