Return-Path: <linux-kernel-owner+w=401wt.eu-S1764196AbYBLTuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764196AbYBLTuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbYBLTts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:49:48 -0500
Received: from ns2.suse.de ([195.135.220.15]:32905 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbYBLTtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:49:47 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] [7/8] Implement true end_pfn_mapped for 32bit
Date: Tue, 12 Feb 2008 20:49:41 +0100
User-Agent: KMail/1.9.6
Cc: ying.huang@intel.com, mingo@elte.hu, linux-kernel@vger.kernel.org
References: <200802111034.764275766@suse.de> <20080211093435.E6FC21B41CE@basil.firstfloor.org> <alpine.LFD.1.00.0802122035270.12988@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0802122035270.12988@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802122049.41477.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2008 20:39:48 Thomas Gleixner wrote:
> On Mon, 11 Feb 2008, Andi Kleen wrote:
> > Even on 32bit 2MB pages can map more memory than is in the true
> > max_low_pfn if end_pfn is not highmem and not aligned to 2MB. 
> > Add a end_pfn_map similar to x86-64 that accounts for this 
> > fact. This is important for code that really needs to know about
> > all mapping aliases. Needed for followup patches (in this case EFI)
> 
> It's not only necessary for followup patches, it is a question of
> general correctness.

True. ioremap already requires it.

> > @@ -36,7 +36,7 @@
> >  #define max_pfn_mapped		end_pfn_map
> >  #else
> >  #include <asm/page_32.h>
> > -#define max_pfn_mapped		max_low_pfn
> > +#define max_pfn_mapped		end_pfn_map
> 
> We can nuke either max_pfn_mapped or end_pfn_map completely. I don't
> care about which one, but keeping both makes no sense at all.

I didn't want to bundle such a clean up into the bug fix
because my experience is that you usually reject that categorically.

I can send the removal of max_pfn_mapped as a follow up patch
if you apply this one.

-Andi

