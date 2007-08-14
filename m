Return-Path: <linux-kernel-owner+w=401wt.eu-S1762554AbXHNWYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762554AbXHNWYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761493AbXHNWVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:21:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39329 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936005AbXHNWVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:21:52 -0400
Date: Wed, 15 Aug 2007 00:21:50 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/9] Atomic reclaim: Save irq flags in vmscan.c
Message-ID: <20070814222150.GI23308@one.firstfloor.org>
References: <20070814212355.GA23308@one.firstfloor.org> <Pine.LNX.4.64.0708141425000.31693@schroedinger.engr.sgi.com> <20070814212955.GC23308@one.firstfloor.org> <Pine.LNX.4.64.0708141436380.31693@schroedinger.engr.sgi.com> <20070814214430.GD23308@one.firstfloor.org> <Pine.LNX.4.64.0708141444590.32110@schroedinger.engr.sgi.com> <20070814215659.GF23308@one.firstfloor.org> <Pine.LNX.4.64.0708141504350.32420@schroedinger.engr.sgi.com> <20070814221616.GG23308@one.firstfloor.org> <Pine.LNX.4.64.0708141517340.32624@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708141517340.32624@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok I have a vague idea on how this could but its likely that the 
> changes make things worse rather than better. Additional reference to a 
> new cacheline (per cpu but still), preempt disable. Lots of code at all
> call sites. Interrupt enable/disable is quite efficient in recent 
> processors.

The goal of this was not to be faster than interrupt disable,
but to avoid the interrupt latency impact. This might be a problem
when spending a lot of time inside the locks.

-Andi
