Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbYAONoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbYAONoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 08:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbYAONob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 08:44:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47368 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbYAONob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 08:44:31 -0500
Message-ID: <478CB75B.70503@zytor.com>
Date: Tue, 15 Jan 2008 08:38:35 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Huang, Ying" <ying.huang@intel.com>, venkatesh.pallipadi@intel.com,
       akpm@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/3] i386 boot: replace boot_ioremap with enhanced
 bt_ioremap
References: <1200375902.3505.29.camel@caritas-dev.intel.com> <20080115084417.GA16449@elte.hu> <1200390535.3505.62.camel@caritas-dev.intel.com> <478CAC70.80309@zytor.com> <20080115133942.GI7025@elte.hu>
In-Reply-To: <20080115133942.GI7025@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> I did a quick scan over the patchset (not quite awake yet, so I may 
>> very well have missed something), but it looks like EFI (again!) is 
>> the only user of ioremapping before paging_init().  This makes me 
>> wonder if that code can't be restructured so that isn't necessary.
> 
> i think that in general making access to unmapped memory a bit easier is 
> generally a good robustness idea as ACPI could be impacted by it as 
> well.
> 
> Fundamentally, paging_init() has obvious dependency on "figuring out the 
> memory setup" of the box, and "figuring out the memory setup" means 
> interpreting various data structures passed in by the BIOS - some of 
> which might be in not yet mapped areas or iommu areas (if we have to do 
> some early quirk). So having a robust implementation of ioremap_early() 
> sounds like a definitive plus.
> 

Fair enough.  If it's generally useful, I certainly have no objections.

	-hpa
