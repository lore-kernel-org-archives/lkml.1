Return-Path: <linux-kernel-owner+w=401wt.eu-S1030755AbXAZPot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030755AbXAZPot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 10:44:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030752AbXAZPot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 10:44:49 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:35324 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030731AbXAZPos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 10:44:48 -0500
Date: Fri, 26 Jan 2007 07:44:42 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Andrew Morton <akpm@osdl.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Track mlock()ed pages
In-Reply-To: <20070126031300.59f75b06.akpm@osdl.org>
Message-ID: <Pine.LNX.4.64.0701260742340.6141@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0701252141570.10629@schroedinger.engr.sgi.com>
 <45B9A00C.4040701@yahoo.com.au> <Pine.LNX.4.64.0701252234490.11230@schroedinger.engr.sgi.com>
 <20070126031300.59f75b06.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, Andrew Morton wrote:

> > > > Track mlocked pages via a ZVC
> 
> Why?

Large amounts of mlocked pages may be a problem for 

1. Reclaim behavior.

2. Defragmentation


> You could perhaps go for a walk across all the other vmas which presently
> map this page.  If any of them have VM_LOCKED, don't increment the counter.
> Similar on removal: only decrement the counter when the final mlocked VMA
> is dropping the pte.

For that we would need an additional refcount for vmlocked maps in the 
page struct. Looks too expensive.
