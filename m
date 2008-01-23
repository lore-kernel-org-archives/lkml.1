Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbYAWSmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbYAWSmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 13:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbYAWSmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 13:42:03 -0500
Received: from relay2.sgi.com ([192.48.171.30]:38814 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752856AbYAWSmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 13:42:01 -0500
Date: Wed, 23 Jan 2008 10:41:59 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       hanth Aravamudan <nacc@us.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       lee.schermerhorn@hp.com, Linux MM <linux-mm@kvack.org>,
       Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH] Fix boot problem in situations where the boot CPU is
 running on a memoryless node
In-Reply-To: <20080123135513.GA14175@csn.ul.ie>
Message-ID: <Pine.LNX.4.64.0801231040160.11430@schroedinger.engr.sgi.com>
References: <20080118213011.GC10491@csn.ul.ie>
 <Pine.LNX.4.64.0801181414200.8924@schroedinger.engr.sgi.com>
 <20080118225713.GA31128@aepfle.de> <20080122195448.GA15567@csn.ul.ie>
 <20080122214505.GA15674@aepfle.de> <Pine.LNX.4.64.0801221417480.1912@schroedinger.engr.sgi.com>
 <20080123075821.GA17713@aepfle.de> <20080123105044.GD21455@csn.ul.ie>
 <20080123121459.GA18631@aepfle.de> <20080123125236.GA18876@aepfle.de>
 <20080123135513.GA14175@csn.ul.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2008, Mel Gorman wrote:

> This patch adds the necessary checks to make sure a kmem_list3 exists for
> the preferred node used when growing the cache. If the preferred node has
> no nodelist then the currently running node is used instead. This
> problem only affects the SLAB allocator, SLUB appears to work fine.

That is a dangerous thing to do. SLAB per cpu queues will contain foreign 
objects which may cause troubles when pushing the objects back. I think we 
may be lucky that these objects are consumed at boot. If all of the 
foreign objects are consumed at boot then we are fine. At least an 
explanation as to this issue should be added to the patch.

