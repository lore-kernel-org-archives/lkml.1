Return-Path: <linux-kernel-owner+w=401wt.eu-S1757096AbXFKX3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbXFKX3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 19:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbXFKX26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 19:28:58 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52665 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754339AbXFKX26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 19:28:58 -0400
Date: Mon, 11 Jun 2007 16:28:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
In-Reply-To: <200706120016.58317.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0706111627340.23990@schroedinger.engr.sgi.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
 <20070611204442.GA4074@linux-os.sc.intel.com> <20070611141449.bfbc4769.akpm@linux-foundation.org>
 <200706120016.58317.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2007, Andi Kleen wrote:

> > If the only option is to panic then something's busted.  If it's network IO
> > then there should be a way of dropping the frame.  If it's disk IO then we
> > should report the failure and cause an IO error.
> 
> An block IO error is basically catastrophic for the system too. There isn't really
> a concept of "temporary IO error that will resolve itself" concept in Unix.

In Unix? You mean the block layer cannot handle a I/O error? Not too 
familiar with it but from what I can tell an I/O operation can be aborted 
in the request function.

> There are still lots of users of pci_map_single() that don't check the return
> value unfortunately.   That is mostly in old drivers; it is generally
> picked on in reviews now. But then there is no guarantee that these rarely
> used likely untested error handling paths actually work.

Then we need to review the code and clean these up.
