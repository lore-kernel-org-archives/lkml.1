Return-Path: <linux-kernel-owner+w=401wt.eu-S2992443AbXCGSXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992443AbXCGSXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992444AbXCGSXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:23:40 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42148 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S2992443AbXCGSXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:23:38 -0500
Date: Wed, 7 Mar 2007 10:23:36 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, akpm@osdl.org,
       Marcelo Tosatti <marcelo@kvack.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [SLUB 2/3] Large kmalloc pass through. Removal of large general
 slabs
In-Reply-To: <20070307180359.GU23311@waste.org>
Message-ID: <Pine.LNX.4.64.0703071022230.22448@schroedinger.engr.sgi.com>
References: <20070307023502.19658.39217.sendpatchset@schroedinger.engr.sgi.com>
 <20070307023513.19658.81228.sendpatchset@schroedinger.engr.sgi.com>
 <1173258077.6374.120.camel@twins> <Pine.LNX.4.64.0703070732130.9460@schroedinger.engr.sgi.com>
 <20070307180359.GU23311@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007, Matt Mackall wrote:

> > I have a patch here to make this dependent on page size using a loop. The 
> > problem is that it does not work with some versions of gcc. On the 
> > other hand we really need this since one arch can 
> > actually have an order 22 page size!
> 
> You don't need a loop, you need an if (s >= PAGE_SIZE) at the head of
> your static list.

As I just said: PAGE_SIZE may be quite high. So I would need a looong 
static list. We already check for the size being bigger than 2048 which is 
half the usual page size. Anything larger will get passed through.

