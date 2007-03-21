Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbXCUOfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbXCUOfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 10:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbXCUOfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 10:35:25 -0400
Received: from graphe.net ([209.204.138.32]:34769 "EHLO graphe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677AbXCUOfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 10:35:25 -0400
Date: Wed, 21 Mar 2007 07:35:04 -0700 (PDT)
From: Christoph Lameter <christoph@lameter.com>
X-X-Sender: christoph@graphe.net
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLAB : NUMA cache_free_alien() very expensive because of
 virt_to_slab(objp); nodeid = slabp->nodeid;
In-Reply-To: <4600DB6E.40107@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703210734010.1573@graphe.net>
References: <20070320181235.77d28864.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0703201248530.12664@graphe.net> <20070320213218.GA13952@one.firstfloor.org>
 <46005B7D.3090701@cosmosbay.com> <Pine.LNX.4.64.0703201715110.17799@graphe.net>
 <4600D04B.6030305@cosmosbay.com> <Pine.LNX.4.64.0703210001220.25462@graphe.net>
 <4600DB6E.40107@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007, Eric Dumazet wrote:

> If numa_node_id() is equal to the node of the page containing the first byte
> of the object, then object is on the local node. Or what ?

No. The slab (the page you are referring to) may have been allocated for 
another node and been tracked via the node structs of that other node. We 
were just falling back to the node that now appears to be local.


