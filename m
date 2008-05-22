Return-Path: <linux-kernel-owner+w=401wt.eu-S1764278AbYEVEp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764278AbYEVEp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 00:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbYEVEpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 00:45:13 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38167 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbYEVEpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 00:45:11 -0400
Message-ID: <4834F9D6.7080706@cs.helsinki.fi>
Date: Thu, 22 May 2008 07:43:02 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       mpm@selenic.com, dhowells@redhat.com
Subject: Re: [RFC/PATCH 1/3] SLAB: Add PageSlab checking to ksize()
References: <Pine.LNX.4.64.0805212124250.22291@sbz-30.cs.Helsinki.FI> <20080521234555.GB32707@linux-sh.org> <4834F2E2.3070806@cs.helsinki.fi> <Pine.LNX.4.64.0805212116260.19431@schroedinger.engr.sgi.com> <4834F4DC.3040009@cs.helsinki.fi> <20080522043410.GA4050@linux-sh.org>
In-Reply-To: <20080522043410.GA4050@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Paul Mundt wrote:
> Shouldn't SLOB's PageSlab usage should mimic that of SLUB in this case
> instead? PG_slab doesn't buy us much if we can already sort out the size
> through compound_order(), it's the kmem_cache_alloc() and <= PAGE_SIZE
> kmalloc()'s where __GFP_COMP isn't true and where PG_slab should be set.

Well, we should really be calling ksize() in the nommu case and although 
Matt and Christoph don't seem to agree with me here, I'd much rather 
have *all* allocators set PageSlab for all the pages they return (yes, 
including pass-through ones) to get us back where we were with SLAB. We 
currently don't have any means to see whether an arbitrary page is part 
of the slab or not and I'd argue that's PageSlab is an established API 
(that makes sense).

Furthermore, if ksize() in SLOB doesn't work for kmem_cache_alloc() 
pages, I think it should be fixed as well.

			Pekka
