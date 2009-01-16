Return-Path: <linux-kernel-owner+w=401wt.eu-S933645AbZAPMgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933645AbZAPMgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 07:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760119AbZAPMgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 07:36:37 -0500
Received: from [202.81.31.141] ([202.81.31.141]:45429 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759225AbZAPMgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 07:36:37 -0500
X-Greylist: delayed 1197 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jan 2009 07:36:36 EST
From: Chandru <chandru@in.ibm.com>
Organization: ibm
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: 2.6.28-rc9 panics with crashkernel=256M while booting
Date: Fri, 16 Jan 2009 17:46:36 +0530
User-Agent: KMail/1.9.10
Cc: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <200812241325.49404.chandru@in.ibm.com> <200901091637.24658.chandru@in.ibm.com> <200901151335.27649.chandru@in.ibm.com>
In-Reply-To: <200901151335.27649.chandru@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901161746.36584.chandru@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2009 13:35:27 Chandru wrote:
> Hello Dave, From the debug console output, if there is anything you can add
> here, pls let me know.

As we can see from the console output here,  physbase isn't page aligned when 
the panic occurs.  So we could as well send (start_pfn << PAGE_SHIFT) to 
reserve_bootmem_node() instead of physbase. your thoughts ?.

Also end_pfn in mark_reserved_region_for_nid() is defined as 

unsigned long end_pfn = ((physbase + size) >> PAGE_SHIFT);

Does this refer to the pfn after the area that we are interested in ?.  We have 
atleast two fixes here,  
1. Limit start and end to bdata->node_min_pfn  and bdata->node_low_pfn in 
reserve_bootmem_node() and add comments out in there that the caller of the 
funtion should be aware of how much are they reserving. 
2. send (start_pfn << PAGE_SHIFT) to reserve_bootmem_node() instead of 
physbase. 

Chandru
