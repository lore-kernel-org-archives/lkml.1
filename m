Return-Path: <linux-kernel-owner+w=401wt.eu-S1752205AbXCUAQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbXCUAQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 20:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbXCUAQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 20:16:50 -0400
Received: from graphe.net ([209.204.138.32]:33475 "EHLO graphe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbXCUAQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 20:16:49 -0400
Date: Tue, 20 Mar 2007 17:16:37 -0700 (PDT)
From: Christoph Lameter <christoph@lameter.com>
X-X-Sender: christoph@graphe.net
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLAB : NUMA cache_free_alien() very expensive because of
 virt_to_slab(objp); nodeid = slabp->nodeid;
In-Reply-To: <46005B7D.3090701@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703201715110.17799@graphe.net>
References: <20070320181235.77d28864.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0703201248530.12664@graphe.net> <20070320213218.GA13952@one.firstfloor.org>
 <46005B7D.3090701@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007, Eric Dumazet wrote:

> I understand we want to do special things (fallback and such tricks) at
> allocation time, but I believe that we can just trust the real nid of memory
> at free time.

Sorry no. The node at allocation time determines which node specific 
structure tracks the slab. If we fall back then the node is allocated 
from one node but entered in the node structure of another. Thus you 
cannot free the slab without knowing the node at allocation time.

