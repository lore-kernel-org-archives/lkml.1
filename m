Return-Path: <linux-kernel-owner+w=401wt.eu-S935127AbXEIAvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935127AbXEIAvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 20:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934594AbXEIAv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 20:51:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40361 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934586AbXEIAv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 20:51:28 -0400
Date: Tue, 8 May 2007 17:51:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
 added to -mm tree
In-Reply-To: <20070509002307.GV11115@waste.org>
Message-ID: <Pine.LNX.4.64.0705081746500.16914@schroedinger.engr.sgi.com>
References: <200705082302.l48N2KrZ004229@shell0.pdx.osdl.net>
 <20070509002307.GV11115@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Matt Mackall wrote:

> First, SLOB no longer runs on SMP because SLAB grew some RCU-related
> hair. So it now effectively has no locks at all! 

Well it seems that SLOB was not well maintained. RCU has been around for a 
long time and SLOB has not been updated to cope with it.
 
> Third, I don't think it's possible even in theory for a SLAB-like
> allocator to be as efficient as SLOB simply due to the constraints of
> putting only objects of the same size on a given page. So consider me
> skeptical on the density claim.

SLUB can put 32 objects sized 128 byte each in a 4k page. Can SLOB do 
the same?
 
> It is usually better to use SLUB simply because you're more likely to
> have 1GB of RAM rather than 4MB.

SLUB should be perfectly fine for that environment provided you 
adjust the cacheline alignment and switch off SLUB debugging. 
define L1_CACHE_BYTES to be 4 or so.

