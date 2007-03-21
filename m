Return-Path: <linux-kernel-owner+w=401wt.eu-S932511AbXCUPt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbXCUPt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932508AbXCUPt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:49:26 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:33838 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932516AbXCUPt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:49:26 -0400
Date: Wed, 21 Mar 2007 16:49:27 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <christoph@lameter.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH] SLAB : [NUMA] keep nodeid in struct page instead
 of struct slab
Message-Id: <20070321164927.98256bf8.dada1@cosmosbay.com>
In-Reply-To: <Pine.LNX.4.64.0703211740460.19583@sbz-30.cs.Helsinki.FI>
References: <20070321102231.7288f231.dada1@cosmosbay.com>
	<84144f020703210521q10ad95d4g760010bd4388c71f@mail.gmail.com>
	<Pine.LNX.4.64.0703210742080.1573@graphe.net>
	<Pine.LNX.4.64.0703211740460.19583@sbz-30.cs.Helsinki.FI>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 17:42:22 +0200 (EET)
Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> On Wed, 21 Mar 2007, Christoph Lameter wrote:
> > None of that please. The page flags already contain a node number that is 
> > accessible via page_to_nid(). Just make sure that we never put a slab onto 
> > the wrong node.
> 
> Oh well, here's a patch to find out. (I don't have a NUMA box.)
> 

This wont work, because of use_alien_caches knob.

If use_alien_caches is set to 0, your WARN_ON will trigger many false alarms

