Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYFIOQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYFIOQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbYFIOQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:16:50 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38692 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751322AbYFIOQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:16:49 -0400
Date: Mon, 9 Jun 2008 07:16:48 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Eric Dumazet <dada1@cosmosbay.com>, kosaki.motohiro@jp.fujitsu.com,
       nickpiggin@yahoo.com.au, hugh@veritas.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vmallocinfo: Add NUMA informations
In-Reply-To: <20080603144054.973284bb.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0806090715020.29723@schroedinger.engr.sgi.com>
References: <48439916.2070108@cosmosbay.com> <20080602160548.B6D4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
 <4844BC75.8040705@cosmosbay.com> <20080603144054.973284bb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2008, Andrew Morton wrote:

> > +	if (NUMA_BUILD) {
> > +		unsigned int *counters, nr;
> > +
> > +		counters = kzalloc(nr_node_ids * sizeof(unsigned int),
> 
> This is kcalloc().  If you like that sorts of thing - I think kcalloc()
> is pretty pointless personally.

Same here. I think its generally ignored. I tried to remove it at some 
point in the past. If we want kcalloc then we also need kczalloc. It would 
be best to keep the interface simple.

> Do we actually need dynamic allocation here?  There's a small,
> constant, known-at-compile-time upper bound to the number of nodes IDs?

The number of node ids may reach 1024.
