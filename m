Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbYHTO0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbYHTO0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 10:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbYHTO0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 10:26:38 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:43902 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbYHTO0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 10:26:37 -0400
Message-ID: <48AC29CA.1060203@keyaccess.nl>
Date: Wed, 20 Aug 2008 16:27:22 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Airlie <airlied@gmail.com>, "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "dri-users@lists.sourceforge.net" <dri-users@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: AGP and PAT (induced?) problem (on AMD family 6)
References: <48972EA8.8040001@keyaccess.nl> <20080815142218.GC12954@elte.hu> <48A59FAC.7050605@keyaccess.nl> <48AA9C3B.5030309@keyaccess.nl> <20080819102633.GE6722@elte.hu> <48AAD680.7020508@keyaccess.nl> <20080819190757.GA17470@linux-os.sc.intel.com> <20080820100440.GE28492@elte.hu> <48ABF6DC.8070305@keyaccess.nl>
In-Reply-To: <48ABF6DC.8070305@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20-08-08 12:50, Rene Herman wrote:

> On 20-08-08 12:04, Ingo Molnar wrote:
> 
>> * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
>>
>>>> I'd really like a reply from the AGP or PAT side right about now.
>>> Hmm. Looks like there are more than 16000 entries in the PAT list!
>>
>> hm, btw., why is that?
> 
> Because 64M of AGP memory divided by 4K pages is 16K. That is, the 
> underlying problem seems to be AGP drivers using order 0 allocations. 
> I'm looking.
> 
> Do note also that this means that Venki's change would not constitite a 
> correct/final fix. Sure, caching the last entry speeds up traversing a 
> 16K entry list but the issue is that there shouldn't be a 16K entry 
> list. Through AGP, or maybe even by coalescing entries in the PAT list 
> if that's at all possible (I guess it's not really).
> 
> Even if such a more fundamental fix isn't (easily) available, the PAT 
> code already comments that the list, which is sorted by ->start value, 
> is expected to be short, and should be turned into an rbtree if it isn't 
> which might be slightly less of a bandaid.
> 
> Dave Airlie (as the MAINTAINERS entry) can't be arsed to answer email it 
> seems so I've added Dave Jones for a possible comment from the AGP side.
> If I'm reading this right upto now, still many AGP driver (among which 
> my amd-k7-agp) are affected.

This was based on a wrong reading; I was looking at the GATT allocation.

I'm giving up looking until someone can tell me whether or not those 16K 
entries are expected though. I have just one AGP card in a PAT capable 
machine.

How many entries in /debug/x86/pat_memtype_list are there on other AGP 
systems with Option "AGPSize" "64" in their xorg.conf:"Device" section 
(and their AGP aperture set to 64M or bigger in the BIOS)?

Rene.
