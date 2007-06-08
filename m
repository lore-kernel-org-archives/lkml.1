Return-Path: <linux-kernel-owner+w=401wt.eu-S970766AbXFHW7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970766AbXFHW7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbXFHW7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:59:34 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:44199 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751112AbXFHW7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:59:33 -0400
Date: Fri, 8 Jun 2007 15:59:32 -0700 (PDT)
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
In-Reply-To: <200706090056.49279.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0706081558090.4373@schroedinger.engr.sgi.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
 <6901450.1181335390183.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
 <Pine.LNX.4.64.0706081534520.3966@schroedinger.engr.sgi.com>
 <200706090056.49279.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007, Andi Kleen wrote:

> > Why was it not allowed? Because interrupts are disabled?
> 
> Allocating memory during page out under low memory could 
> lead to deadlocks. That is because Linux used to make no attempt
> to limit dirty pages for anonymous mappings and then you could
> end up with most of your memory dirty and not enough 
> memory cleanable for page out and then when page out 
> needs more memory you could be dead.
> 
> [yes that implies that mmap over NFS was always broken]

Right. We got that fixed in 2.6.19.

> Now there is a anon dirty limit since a few releases, but I'm not
> fully convinced it solves the problem completely.

A gut feeling or is there more?

