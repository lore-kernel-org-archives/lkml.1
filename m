Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbXFSX0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbXFSX0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 19:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbXFSX0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 19:26:00 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48504 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754476AbXFSXZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 19:25:59 -0400
Date: Tue, 19 Jun 2007 16:25:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, davem@davemloft.net
Subject: Re: [Intel IOMMU 06/10] Avoid memory allocation failures in dma map
 api calls
In-Reply-To: <20070619213808.798646000@askeshav-devel.jf.intel.com>
Message-ID: <Pine.LNX.4.64.0706191624110.15951@schroedinger.engr.sgi.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
 <20070619213808.798646000@askeshav-devel.jf.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Keshavamurthy, Anil S wrote:


> So far in our test scenario, we were unable to create
> any memory allocation failure inside dma map api calls.

All these functions should have gfp_t flags passed to them.
Otherwise you are locked into the use of GFP_ATOMIC. If this is a 
parameter then you may be able to use GFP_KERNEL in various places and you 
may develop the code to have less GFP_ATOMIC allocs in the future.

