Return-Path: <linux-kernel-owner+w=401wt.eu-S1762539AbXFTGO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762539AbXFTGO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 02:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758423AbXFTGOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 02:14:48 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45675 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757888AbXFTGOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 02:14:48 -0400
Date: Wed, 20 Jun 2007 09:14:43 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <clameter@sgi.com>
cc: Matt Mackall <mpm@selenic.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       suresh.b.siddha@intel.com
Subject: Re: [patch 05/26] Slab allocators: Cleanup zeroing allocations
In-Reply-To: <Pine.LNX.4.64.0706191532170.7633@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0706200911200.10032@sbz-30.cs.Helsinki.FI>
References: <20070618095838.238615343@sgi.com> <20070618095914.622685354@sgi.com>
 <20070619210010.GN11166@waste.org> <Pine.LNX.4.64.0706191532170.7633@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Matt Mackall wrote:
> > I worry a bit about adding another branch checking __GFP_ZERO in such
> > a hot path for SLAB/SLUB.

On Tue, 19 Jun 2007, Christoph Lameter wrote:
> Its checking the gfpflags variable on the stack. In a recently touched 
> cachline.

The variable could be in a register too but it's the _branch 
instruction_ that is bit worrisome especially for embedded devices (think 
slob). I haven't measured this, so consider this as pure speculation and 
hand-waving from my part.
