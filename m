Return-Path: <linux-kernel-owner+w=401wt.eu-S937618AbYEUVPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937618AbYEUVPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937811AbYEUVOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:14:48 -0400
Received: from relay1.sgi.com ([192.48.171.29]:51698 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937777AbYEUVOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:14:46 -0400
Date: Wed, 21 May 2008 14:14:45 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, mpm@selenic.com, lethal@linux-sh.org,
       dhowells@redhat.com
Subject: Re: [RFC/PATCH 2/3] SLUB: make ksize() more strict for page allocator
 pass-through
In-Reply-To: <4834704D.6020809@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0805211412340.17915@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805212125310.22291@sbz-30.cs.Helsinki.FI>
 <Pine.LNX.4.64.0805211149210.16064@schroedinger.engr.sgi.com>
 <4834704D.6020809@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Pekka Enberg wrote:

> Christoph Lameter wrote:
> > Why is it too big? Without your additions it is converting kmallocs inline
> > to get_free_pages(). That results in a simple function call with two
> > constant parameters.
> 
> Well, it's a PITA because of #include dependencies in any case. Is moving it
> out-of-line a problem?
> 
> Christoph Lameter wrote:
> > The patch touches the page struct uselessly. I think the PageSlab marking is
> > useful for debugging but not for a production kernel.
> 
> Hmm, where? page_address() already references ->virtual. I suppose
> CONFIG_SLUB_DEBUG is a no no as well then so do we want to add a
> CONFIG_KSIZE_DEBUG config option...? (Btw, I removed the BUG_ON() from kfree()
> as spotted by Vegard Nossum.)

If it has to be then add CONFIG_KSIZE_DEBUG. There are a number of 
debugging techniques (kmem_check?) that should not be compiled in. Maybe 
add a new config option for those. CONFIG_SLUB_ENABLE_EXPENSIVE_DEBUG?

