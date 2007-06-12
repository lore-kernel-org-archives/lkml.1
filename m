Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbXFLBau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbXFLBau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 21:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960AbXFLBam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 21:30:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58374 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755715AbXFLBam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 21:30:42 -0400
Date: Mon, 11 Jun 2007 18:30:41 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org, gregkh@suse.de,
       muli@il.ibm.com, asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com, davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool handling
In-Reply-To: <466DF290.2040503@linux.intel.com>
Message-ID: <Pine.LNX.4.64.0706111828360.24808@schroedinger.engr.sgi.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
 <200706090056.49279.ak@suse.de> <Pine.LNX.4.64.0706081558090.4373@schroedinger.engr.sgi.com>
 <200706091147.24705.ak@suse.de> <20070611204442.GA4074@linux-os.sc.intel.com>
 <20070611141449.bfbc4769.akpm@linux-foundation.org>
 <20070611235208.GC25022@linux-os.sc.intel.com> <20070611173001.e0355af3.akpm@linux-foundation.org>
 <466DF290.2040503@linux.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2007, Arjan van de Ven wrote:

> the problem with that is that if anything downstream from the iommu layer ALSO
> needs memory, we've now eaten up the last free page and things go splat.

Hmmm... We need something like a reservation system right? Higher levels 
in a atomic context could register their future needs. Then we can avoid 
overallocating in the iommu layer.

