Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbYAWSfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbYAWSfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 13:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbYAWSfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 13:35:34 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60513 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752545AbYAWSfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 13:35:34 -0500
Date: Wed, 23 Jan 2008 10:35:32 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: Mel Gorman <mel@csn.ul.ie>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       hanth Aravamudan <nacc@us.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       lee.schermerhorn@hp.com, Linux MM <linux-mm@kvack.org>,
       Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH] Fix boot problem in situations where the boot CPU is
 running on a memoryless node
In-Reply-To: <Pine.LNX.4.64.0801231611160.20050@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0801231034110.11430@schroedinger.engr.sgi.com>
References: <20080118213011.GC10491@csn.ul.ie>
 <Pine.LNX.4.64.0801181414200.8924@schroedinger.engr.sgi.com>
 <20080118225713.GA31128@aepfle.de> <20080122195448.GA15567@csn.ul.ie>
 <20080122214505.GA15674@aepfle.de> <Pine.LNX.4.64.0801221417480.1912@schroedinger.engr.sgi.com>
 <20080123075821.GA17713@aepfle.de> <20080123105044.GD21455@csn.ul.ie>
 <20080123121459.GA18631@aepfle.de> <20080123125236.GA18876@aepfle.de>
 <20080123135513.GA14175@csn.ul.ie> <Pine.LNX.4.64.0801231611160.20050@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2008, Pekka J Enberg wrote:

> I still think Christoph's kmem_getpages() patch is correct (to fix 
> cache_grow() oops) but I overlooked the fact that none the callers of 
> ____cache_alloc_node() deal with bootstrapping (with the exception of 
> __cache_alloc_node() that even has a comment about it).

My patch is useless. kmem_getpages called with nodeid == -1 falls back 
correctly to the available node. The problem is that the node structures 
for the page does not exist.
 
> But what I am really wondering about is, why wasn't the 
> N_NORMAL_MEMORY revert enough? I assume this used to work before so what 
> more do we need to revert for 2.6.24?

I think that is because SLUB relaxed the requirements on having regular 
memory on the boot node. Now the expectation is that SLAB can do the same.


