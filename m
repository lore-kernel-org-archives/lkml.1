Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbYJOXlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbYJOXlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 19:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbYJOXky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 19:40:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752706AbYJOXky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 19:40:54 -0400
Date: Wed, 15 Oct 2008 16:40:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bob Montgomery <bob.montgomery@hp.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       vojtech@suse.cz, chandru@in.ibm.com
Subject: Re: [PATCH] disable CPU side GART accesses
In-Reply-To: <1224107317.2215.238.camel@amd.troyhebe>
Message-ID: <alpine.LFD.2.00.0810151630050.3288@nehalem.linux-foundation.org>
References: <1224107317.2215.238.camel@amd.troyhebe>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Oct 2008, Bob Montgomery wrote:
> 
> This patch changes the initialization of the GART to set the DISGARTCPU
> bit in the GART Aperture Control Register (AMD64_GARTAPERTURECTL).
> Setting the bit prevents requests from the CPUs from accessing the
> GART.  In other words, CPU memory accesses to the aperture address
> range will not cause the GART to perform an address translation.
> The aperture area is currently being unmapped at the kernel level
> with set_memory_np() in gart_iommu_init to prevent accesses from the
> CPU [...]

Would this allow us to get rid of that particular hackup code sequence 
entirely? Or do we still need them for other chip versions etc?

Also, the whole iommu/gart thing seems to have a lot of people who have 
worked on it, are the right people cc'd? Pavel seems to have touched the 
code last, but it seems to be originally done by Andi and then with 
touches by DaveJ. 

I get the feeling that the people cc'd are kdump people, not iommu/gart 
people, which is a bit sad.

		Linus
