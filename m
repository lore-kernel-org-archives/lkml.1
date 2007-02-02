Return-Path: <linux-kernel-owner+w=401wt.eu-S1423109AbXBBF2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423109AbXBBF2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 00:28:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423110AbXBBF2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 00:28:08 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:43719 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423109AbXBBF2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 00:28:07 -0500
Date: Thu, 1 Feb 2007 21:27:47 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Andrew Morton <akpm@osdl.org>, Russell King <rmk+lkml@arm.linux.org.uk>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: [PATCH 0/8] Create ZONE_MOVABLE to partition memory between
 movable and non-movable pages
In-Reply-To: <1170150823.6189.203.camel@twins>
Message-ID: <Pine.LNX.4.64.0702012122370.10723@schroedinger.engr.sgi.com>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie> 
 <20070126030753.03529e7a.akpm@osdl.org>  <Pine.LNX.4.64.0701260751230.6141@schroedinger.engr.sgi.com>
  <20070126114615.5aa9e213.akpm@osdl.org>  <Pine.LNX.4.64.0701261147300.15394@schroedinger.engr.sgi.com>
  <20070126122747.dde74c97.akpm@osdl.org>  <Pine.LNX.4.64.0701291349450.548@schroedinger.engr.sgi.com>
  <20070129143654.27fcd4a4.akpm@osdl.org>  <Pine.LNX.4.64.0701291441260.1102@schroedinger.engr.sgi.com>
  <20070129225000.GG6602@flint.arm.linux.org.uk> 
 <Pine.LNX.4.64.0701291533500.1169@schroedinger.engr.sgi.com> 
 <20070129160921.7b362c8d.akpm@osdl.org> <1170150823.6189.203.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007, Peter Zijlstra wrote:

> I'm guessing this will involve page migration.

Not necessarily. The approach also works without page migration. Depends 
on an intelligent allocation scheme that stays off the areas of interest 
to those restricted to low area allocations as much as possible and then 
is able to reclaim from a section of a zone if necessary. The 
implementation of alloc_pages_range() that I did way back did not reply on 
page migration.

