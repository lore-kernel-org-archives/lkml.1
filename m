Return-Path: <linux-kernel-owner+w=401wt.eu-S1751643AbXBVPZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbXBVPZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 10:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbXBVPZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 10:25:55 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60684 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751644AbXBVPZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 10:25:55 -0500
Date: Thu, 22 Feb 2007 07:25:54 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
       akpm@linux-foundation.org
Subject: Re: SLUB: The unqueued Slab allocator
In-Reply-To: <1172133274.6374.12.camel@twins>
Message-ID: <Pine.LNX.4.64.0702220724340.858@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702212250271.30485@schroedinger.engr.sgi.com>
 <1172133274.6374.12.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007, Peter Zijlstra wrote:

> On Wed, 2007-02-21 at 23:00 -0800, Christoph Lameter wrote:
> 
> > +/*
> > + * Lock order:
> > + *   1. slab_lock(page)
> > + *   2. slab->list_lock
> > + *
> 
> That seems to contradict this:

This is a trylock. If it fails then we can compensate by allocating
a new slab.
