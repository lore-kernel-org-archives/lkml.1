Return-Path: <linux-kernel-owner+w=401wt.eu-S1762770AbZAPRxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762770AbZAPRxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 12:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761335AbZAPRxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 12:53:04 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44699 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758959AbZAPRxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 12:53:00 -0500
Subject: Re: 2.6.28-rc9 panics with crashkernel=256M while booting
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Chandru <chandru@in.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <200901161746.36584.chandru@in.ibm.com>
References: <200812241325.49404.chandru@in.ibm.com>
	 <200901091637.24658.chandru@in.ibm.com>
	 <200901151335.27649.chandru@in.ibm.com>
	 <200901161746.36584.chandru@in.ibm.com>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 09:52:57 -0800
Message-Id: <1232128377.27278.69.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-16 at 17:46 +0530, Chandru wrote:
> On Thursday 15 January 2009 13:35:27 Chandru wrote:
> > Hello Dave, From the debug console output, if there is anything you can add
> > here, pls let me know.
> 
> As we can see from the console output here,  physbase isn't page aligned when 
> the panic occurs.  So we could as well send (start_pfn << PAGE_SHIFT) to 
> reserve_bootmem_node() instead of physbase. your thoughts ?.
> 
> Also end_pfn in mark_reserved_region_for_nid() is defined as 
> 
> unsigned long end_pfn = ((physbase + size) >> PAGE_SHIFT);
> 
> Does this refer to the pfn after the area that we are interested in ?.  We have 
> atleast two fixes here,  
> 1. Limit start and end to bdata->node_min_pfn  and bdata->node_low_pfn in 
> reserve_bootmem_node() and add comments out in there that the caller of the 
> funtion should be aware of how much are they reserving. 
> 2. send (start_pfn << PAGE_SHIFT) to reserve_bootmem_node() instead of 
> physbase. 

Just looking at it, that calculation is OK.  But, there was one in your
dmesg that looked a page too long, like page 0x1001 instead of 0x1000.
I'd find out how that happened.

-- Dave

