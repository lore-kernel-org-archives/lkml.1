Return-Path: <linux-kernel-owner+w=401wt.eu-S935243AbXEIBcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935243AbXEIBcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 21:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934109AbXEIBch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 21:32:37 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49955 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933865AbXEIBch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 21:32:37 -0400
Date: Tue, 8 May 2007 18:32:35 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
 added to -mm tree
In-Reply-To: <20070509012725.GZ11115@waste.org>
Message-ID: <Pine.LNX.4.64.0705081828300.17376@schroedinger.engr.sgi.com>
References: <200705082302.l48N2KrZ004229@shell0.pdx.osdl.net>
 <20070509002307.GV11115@waste.org> <Pine.LNX.4.64.0705081746500.16914@schroedinger.engr.sgi.com>
 <20070509012725.GZ11115@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Matt Mackall wrote:

> On Tue, May 08, 2007 at 05:51:27PM -0700, Christoph Lameter wrote:
> > On Tue, 8 May 2007, Matt Mackall wrote:
> > 
> > > First, SLOB no longer runs on SMP because SLAB grew some RCU-related
> > > hair. So it now effectively has no locks at all! 
> > 
> > Well it seems that SLOB was not well maintained. RCU has been around for a 
> > long time and SLOB has not been updated to cope with it.
> 
> RCU's incursion into SLAB that broke SLOB is relatively new. And it
> only broke for people using SMP or SPARSEMEM. Intersection with target
> audience of SLOB: ~0.

New meaning in the last 3 years?

> > SLUB can put 32 objects sized 128 byte each in a 4k page. Can SLOB do 
> > the same?
> 
> Yes. It can in fact put 512 8-byte objects in a 4k page. More

So can SLUB.

> importantly, it can put 2 1k objects and 16 128-byte objects on the
> same page instead of on two pages.

That SLUB cannot do. And I do not believe you. SLOB must have some way to 
distinguish the objects and their sizes since kfree does not include size 
information. You can mix slabs of different size on the same page without 
metadata. Magic?

So how does kfree then know how to free the object? There must be some way 
where you get the metainformation. What is the point of your 8 byte 
metadata that keeps getting inserted? That does not consume memory on a 
page?
