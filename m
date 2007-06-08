Return-Path: <linux-kernel-owner+w=401wt.eu-S939620AbXFHW5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939620AbXFHW5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbXFHW5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:57:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:39180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754847AbXFHW5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:57:17 -0400
From: Andi Kleen <ak@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
Date: Sat, 9 Jun 2007 00:56:48 +0200
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
References: <20070606185658.138237000@askeshav-devel.jf.intel.com> <6901450.1181335390183.SLOX.WebMail.wwwrun@imap-dhs.suse.de> <Pine.LNX.4.64.0706081534520.3966@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0706081534520.3966@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706090056.49279.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 June 2007 00:36, Christoph Lameter wrote:
> On Fri, 8 Jun 2007, Andreas Kleen wrote:
> > > That's what kmem_cache_alloc() is for?!?!
> >
> > Tradtionally that was not allowed in block layer path. Not sure
> > it is fully obsolete with the recent dirty tracking work, probably not.
>
> Why was it not allowed? Because interrupts are disabled?

Allocating memory during page out under low memory could 
lead to deadlocks. That is because Linux used to make no attempt
to limit dirty pages for anonymous mappings and then you could
end up with most of your memory dirty and not enough 
memory cleanable for page out and then when page out 
needs more memory you could be dead.

[yes that implies that mmap over NFS was always broken]

Now there is a anon dirty limit since a few releases, but I'm not
fully convinced it solves the problem completely.

> > Besides it would need to be GFP_ATOMIC and the default
> > atomic pools are not that big.
>
> Those could be increased. I think Mel has them already increased in mm.

That would be lots of wasted memory. I already got >100 MB free
on my workstation under steady caching state. Already far too much imho.

-Andi
