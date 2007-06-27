Return-Path: <linux-kernel-owner+w=401wt.eu-S1760704AbXF0RDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704AbXF0RDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbXF0RDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:03:06 -0400
Received: from mondriaan.macroscoop.nl ([82.94.9.2]:2895 "EHLO
	mondriaan.macroscoop.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbXF0RDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:03:05 -0400
Message-ID: <4682982B.8060200@macroscoop.nl>
Date: Wed, 27 Jun 2007 19:02:35 +0200
From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jesse Barnes <jesse.barnes@intel.com>
CC: Mauro Giachero <mauro.giachero@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Andi Kleen <andi@firstfloor.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
References: <200706251434.43863.jesse.barnes@intel.com> <200706270804.53263.jesse.barnes@intel.com> <468289A1.3080709@macroscoop.nl> <200706270922.05801.jesse.barnes@intel.com>
In-Reply-To: <200706270922.05801.jesse.barnes@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:

> It looks like end_pfn might be ~0UL now... can you print that out in 
> your configuration?

Er, do you need the value of end_pfn ?
Here's what I changed:

if ((highest_addr >> PAGE_SHIFT) != end_pfn) {
         printk(KERN_WARNING "***************\n");
         printk(KERN_WARNING "**** WARNING: likely BIOS bug\n");
         printk(KERN_WARNING "**** MTRRs don't cover all of "
                "memory, trimmed %lu pages\n", end_pfn -
                (highest_addr >> PAGE_SHIFT));
         printk(KERN_WARNING "**** end_pfn before = %lu\n", end_pfn);
         end_pfn = highest_addr >> PAGE_SHIFT;
         printk(KERN_WARNING "**** end_pfn after = %lu\n", end_pfn);
         printk(KERN_WARNING "***************\n");
}

Here's the result:
***************
**** WARNING: likely BIOS bug
**** MTRRs don't cover all of memory, trimmed 18446744073709486080 pages
**** end_pfn before = 2293760
**** end_pfn after = 2359296
***************

Hope that's what you needed.
Pim

