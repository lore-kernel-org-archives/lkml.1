Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbXCTTn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbXCTTn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 15:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbXCTTn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 15:43:29 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:57340 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752864AbXCTTn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 15:43:28 -0400
Date: Tue, 20 Mar 2007 12:43:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Mackerras <paulus@samba.org>
cc: akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 1/5] Quicklists for page table pages V3
In-Reply-To: <17919.20743.384741.398444@cargo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.64.0703201241560.8729@schroedinger.engr.sgi.com>
References: <20070319233716.13775.45569.sendpatchset@schroedinger.engr.sgi.com>
 <17919.20743.384741.398444@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007, Paul Mackerras wrote:

> Christoph Lameter writes:
> 
> > +static inline void *quicklist_alloc(int nr, gfp_t flags, void (*ctor)(void *))
> > +{
> 
> ...
> 
> > +	p = (void *)__get_free_page(flags | __GFP_ZERO);
> 
> This will cause problems on 64-bit powerpc, at least with 4k pages,
> since the pmd and pgd levels only use 1/4 of a page.

quicklists are only useful for page sized allocations. If you have smaller 
sizes then by all means continue the use of slab. You do not have a page 
struct for each pmd, pgd  to do bad things with (like i386) so everything 
is just fine.
