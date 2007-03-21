Return-Path: <linux-kernel-owner+w=401wt.eu-S932444AbXCUPoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbXCUPoI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932414AbXCUPoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:44:08 -0400
Received: from graphe.net ([209.204.138.32]:36260 "EHLO graphe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932444AbXCUPoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:44:06 -0400
Date: Wed, 21 Mar 2007 08:43:30 -0700 (PDT)
From: Christoph Lameter <christoph@lameter.com>
X-X-Sender: christoph@graphe.net
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Eric Dumazet <dada1@cosmosbay.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH] SLAB : [NUMA] keep nodeid in struct page instead
 of struct slab
In-Reply-To: <84144f020703210803x70c6827di99864618d36f725e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0703210842180.3160@graphe.net>
References: <20070321102231.7288f231.dada1@cosmosbay.com> 
 <84144f020703210521q10ad95d4g760010bd4388c71f@mail.gmail.com> 
 <Pine.LNX.4.64.0703210742080.1573@graphe.net>
 <84144f020703210803x70c6827di99864618d36f725e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007, Pekka Enberg wrote:

> On 3/21/07, Christoph Lameter <christoph@lameter.com> wrote:
> > None of that please. The page flags already contain a node number that is
> > accessible via page_to_nid(). Just make sure that we never put a slab onto
> > the wrong node.
> 
> Sounds good. Do you know for a fact that we don't or are you just
> afraid we have a bug?

I tried to clean it up during the GFP_THISNODE work but there was some 
issue on powerpc where we needed fallback for bootstrap. There may be more 
trouble there. Checking the allocs where we do not use GFP_THISNODE should 
get you there.

