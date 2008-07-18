Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbYGROTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbYGROTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 10:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbYGROTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 10:19:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750770AbYGROTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 10:19:12 -0400
Message-ID: <4880A613.1060002@linux-foundation.org>
Date: Fri, 18 Jul 2008 09:17:55 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Richard Kennedy <richard@rsk.demon.co.uk>
CC: penberg@cs.helsinki.fi, mpm@selenic.com, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH][RFC] slub: increasing order reduces memory usage	of	some
 key caches
References: <1216211371.3122.46.camel@castor.localdomain>	 <487DF5D4.9070101@linux-foundation.org>	 <1216216730.3122.60.camel@castor.localdomain>	 <487DFFBE.5050407@linux-foundation.org> <1216375025.3082.7.camel@castor.localdomain>
In-Reply-To: <1216375025.3082.7.camel@castor.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Kennedy wrote:

> Slabcache: dentry                Aliases:  0 Order :  0 Objects: 22553
> ** Reclaim accounting active
> 
> Sizes (bytes)     Slabs              Debug                Memory
> ------------------------------------------------------------------------
> Object :     208  Total  :    1188   Sanity Checks : Off  Total: 4866048
> SlabObj:     208  Full   :    1186   Redzoning     : Off  Used : 4691024
> SlabSiz:    4096  Partial:       0   Poisoning     : Off  Loss :  175024
> Loss   :       0  CpuSlab:       2   Tracking      : Off  Lalig:       0
> Align  :       8  Objects:      19   Tracing       : Off  Lpadd:  171072

So we are using 1188 pages before make

> and after a make kernel & a small delay

2399 pages after make

> on 2.6.26 + my patch

579 * 2 = 1158 (saved 30 pages even before doing anything) before make


> after the make

2025 *2 = 4050 pages which are much more than the 2399 with order 0.
So we are wasting a lot more space. You'd probably need to run slab defrag to get that memory back.

