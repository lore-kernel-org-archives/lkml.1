Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbXFIKJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbXFIKJz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 06:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbXFIKJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 06:09:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:33195 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbXFIKJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 06:09:46 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
Date: Sat, 9 Jun 2007 11:47:23 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
References: <20070606185658.138237000@askeshav-devel.jf.intel.com> <200706090056.49279.ak@suse.de> <Pine.LNX.4.64.0706081558090.4373@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0706081558090.4373@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706091147.24705.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Now there is a anon dirty limit since a few releases, but I'm not
> > fully convinced it solves the problem completely.
> 
> A gut feeling or is there more?

Lots of other subsystem can allocate a lot of memory
and they usually don't cooperate and have similar dirty limit concepts.
So you could run out of usable memory anyways and then have a similar
issue.

For example a flood of network packets could always steal your
GFP_ATOMIC pools very quickly in the background (gigabit or 10gig 
can transfer a lot of data very quickly) 

Also iirc try_to_free_pages() is not completely fair and might fail
under extreme load for some requesters.

Not requiring memory allocation for any IO would be certainly safer.

Anyways, it's a theoretic question because you can't sleep in 
there anyways unless something drastic changes in the driver interfaces.

-Andi
