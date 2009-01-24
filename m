Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbZAXDMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbZAXDMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 22:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbZAXDL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 22:11:57 -0500
Received: from mga07.intel.com ([143.182.124.22]:40686 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753811AbZAXDL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 22:11:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,315,1231142400"; 
   d="scan'208";a="103357332"
Subject: Re: [PATCH] SLUB: revert direct page allocator pass through
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <200901240237.10522.nickpiggin@yahoo.com.au>
References: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI>
	 <200901240212.58829.nickpiggin@yahoo.com.au>
	 <alpine.DEB.1.10.0901231025320.21692@qirst.com>
	 <200901240237.10522.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 24 Jan 2009 11:11:48 +0800
Message-Id: <1232766708.11429.210.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-24 at 02:37 +1100, Nick Piggin wrote:
> On Saturday 24 January 2009 02:27:29 Christoph Lameter wrote:
> > On Sat, 24 Jan 2009, Nick Piggin wrote:
> > > > I thought higher order allocations were not supposed to be used in
> > > > performance critical paths?
> > >
> > > ? You use them all the time in SLUB alone.
> >
> > But SLUB compensates for the slow higher order allocs by using them as
> > buffers for smaller objects.. The higher order allocs are in the slow
> > paths.
> 
> I don't quite know what you're asking of me. If you see higher order
> allocations in performance critical code, then you answer your own
> question?
> 
> However, I don't know if netperf udp 4K over loopback is totally
> realistic. Maybe real network drivers have different allocation patterns.
Client/server model and distributed systems are popular. To be flexible,
these applications mostly can be configured in one machine, or in a group of
machines. If in one machine, they are used to communicate with network loopback.
I once touched a big distributed telecom application which use UDP to communicate
between front-end and back-end. If they merge ﻿front-end and back-end to one machine
based on some customers' requirements to reduce cost, that will be an example.

> If I were you I wouldn't be too hasty to make big changes based on that
> alone, if it could introduce regression in somewhere more important.


