Return-Path: <linux-kernel-owner+w=401wt.eu-S1761930AbXHXQqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761930AbXHXQqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbXHXQql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:46:41 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48091 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755495AbXHXQql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:46:41 -0400
Date: Fri, 24 Aug 2007 09:46:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/6] SLUB: Avoid touching page struct when freeing to
 per cpu slab
In-Reply-To: <Pine.LNX.4.64.0708231229030.14478@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0708240944020.20501@schroedinger.engr.sgi.com>
References: <20070823064653.081843729@sgi.com>  <20070823064734.558994491@sgi.com>
 <1187881558.6114.400.camel@twins> <Pine.LNX.4.64.0708231229030.14478@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007, Christoph Lameter wrote:

> So we need to also check for -1 if !NUMA
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>

Sorry. No we do not need this fix. The patch is fine as is.

In slab_alloc() the slow path is entered if c->lockless is NULL. So it
does not matter for slow path determination that node_match always returns 
1 in the !NUMA case.

c->node only needs to be checked for slow path determination in 
slab_free(). And there the node_match is not called.
