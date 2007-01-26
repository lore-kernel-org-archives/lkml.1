Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbXAZU2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbXAZU2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 15:28:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030787AbXAZU2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 15:28:01 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53621 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbXAZU2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 15:28:00 -0500
Date: Fri, 26 Jan 2007 12:27:47 -0800
From: Andrew Morton <akpm@osdl.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: [PATCH 0/8] Create ZONE_MOVABLE to partition memory between
 movable and non-movable pages
Message-Id: <20070126122747.dde74c97.akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0701261147300.15394@schroedinger.engr.sgi.com>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
	<20070126030753.03529e7a.akpm@osdl.org>
	<Pine.LNX.4.64.0701260751230.6141@schroedinger.engr.sgi.com>
	<20070126114615.5aa9e213.akpm@osdl.org>
	<Pine.LNX.4.64.0701261147300.15394@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007 11:58:18 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> > If the only demonstrable benefit is a saving of a few k of text on a small
> > number of machines then things are looking very grim, IMO.
> 
> The main benefit is a significant simplification of the VM, leading to 
> robust and reliable operations and a reduction of the maintenance 
> headaches coming with the additional zones.
> 
> If we would introduce the ability of allocating from a range of 
> physical addresses then the need for DMA zones would go away allowing 
> flexibility for device driver DMA allocations and at the same time we get 
> rid of special casing in the VM.

None of this is valid.  The great majority of machines out there will
continue to have the same number of zones.  Nothing changes.

What will happen is that a small number of machines will have different
runtime behaviour.  So they don't benefit from the majority's testing and
they don't contrinute to it and they potentially have unique-to-them
problems which we need to worry about.

That's all a real cost, so we need to see *good* benefits to outweigh that
cost.  Thus far I don't think we've seen that.

