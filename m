Return-Path: <linux-kernel-owner+w=401wt.eu-S1760787AbXGaXk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787AbXGaXk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 19:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbXGaXkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 19:40:21 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54507 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751583AbXGaXkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 19:40:19 -0400
Date: Tue, 31 Jul 2007 16:40:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [rfc] balance-on-fork NUMA placement
In-Reply-To: <200707311114.09284.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0707311639450.31337@schroedinger.engr.sgi.com>
References: <20070731054142.GB11306@wotan.suse.de> <200707311114.09284.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007, Andi Kleen wrote:

> On Tuesday 31 July 2007 07:41, Nick Piggin wrote:
> 
> > I haven't given this idea testing yet, but I just wanted to get some
> > opinions on it first. NUMA placement still isn't ideal (eg. tasks with
> > a memory policy will not do any placement, and process migrations of
> > course will leave the memory behind...), but it does give a bit more
> > chance for the memory controllers and interconnects to get evenly
> > loaded.
> 
> I didn't think slab honored mempolicies by default? 
> At least you seem to need to set special process flags.

It does in the sense that slabs are allocated following policies. If you 
want to place individual objects then you need to use kmalloc_node().
