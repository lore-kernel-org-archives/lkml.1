Return-Path: <linux-kernel-owner+w=401wt.eu-S1761578AbXKHSde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761578AbXKHSde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 13:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760865AbXKHSd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 13:33:27 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42671 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760839AbXKHSd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 13:33:26 -0500
Date: Thu, 8 Nov 2007 10:33:26 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
cc: akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 01/28] cpu alloc: The allocator
In-Reply-To: <1194525257.6289.145.camel@twins>
Message-ID: <Pine.LNX.4.64.0711081031420.7871@schroedinger.engr.sgi.com>
References: <20071106195144.983665861@sgi.com>  <20071106195157.878563669@sgi.com>
 <1194525257.6289.145.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007, Peter Zijlstra wrote:

> On Tue, 2007-11-06 at 11:51 -0800, Christoph Lameter wrote:
> 
> > +/*
> > + * Lock to protect the bitmap and the meta data for the cpu allocator.
> > + */
> > +static DEFINE_SPINLOCK(cpu_alloc_map_lock);
> 
> I thought you got nightmares from global locks :-)

Yes but this one is rarely taken.

> Why a bitmap allocator and not a heap allocator?

Because the allocator must be able to deal with small 4 byte entities.

> Also, looking at the lock usage, this thing is not IRQ safe, so it
> should not be called from hardirq context. Please document this.

Ok.
