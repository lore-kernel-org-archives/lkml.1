Return-Path: <linux-kernel-owner+w=401wt.eu-S935721AbXHNWXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935721AbXHNWXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765837AbXHNWUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:20:31 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51224 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934766AbXHNWU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:20:28 -0400
Date: Tue, 14 Aug 2007 15:20:28 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/9] Atomic reclaim: Save irq flags in vmscan.c
In-Reply-To: <20070814221616.GG23308@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0708141517340.32624@schroedinger.engr.sgi.com>
References: <20070814204454.GC22202@one.firstfloor.org>
 <Pine.LNX.4.64.0708141414260.31693@schroedinger.engr.sgi.com>
 <20070814212355.GA23308@one.firstfloor.org>
 <Pine.LNX.4.64.0708141425000.31693@schroedinger.engr.sgi.com>
 <20070814212955.GC23308@one.firstfloor.org>
 <Pine.LNX.4.64.0708141436380.31693@schroedinger.engr.sgi.com>
 <20070814214430.GD23308@one.firstfloor.org>
 <Pine.LNX.4.64.0708141444590.32110@schroedinger.engr.sgi.com>
 <20070814215659.GF23308@one.firstfloor.org>
 <Pine.LNX.4.64.0708141504350.32420@schroedinger.engr.sgi.com>
 <20070814221616.GG23308@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007, Andi Kleen wrote:

> > > The interrupt handler shouldn't touch zone_flag. If it wants
> > > to it would need to be converted to a local_t and incremented/decremented
> > > (should be about the same cost at least on architectures with sane
> > > local_t implementation) 
> > 
> > That would mean we need to fork the code for reclaim?
> 
> Not with the local_t increment.

Ok I have a vague idea on how this could but its likely that the 
changes make things worse rather than better. Additional reference to a 
new cacheline (per cpu but still), preempt disable. Lots of code at all
call sites. Interrupt enable/disable is quite efficient in recent 
processors.


