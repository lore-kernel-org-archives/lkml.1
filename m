Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbYHTVQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbYHTVQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 17:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbYHTVQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 17:16:04 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:60774 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbYHTVQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 17:16:03 -0400
Message-ID: <48AC89C8.1040804@keyaccess.nl>
Date: Wed, 20 Aug 2008 23:16:56 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "dri-users@lists.sourceforge.net" <dri-users@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: AGP and PAT (induced?) problem (on AMD family 6)
References: <48972EA8.8040001@keyaccess.nl> <20080815142218.GC12954@elte.hu>	 <48A59FAC.7050605@keyaccess.nl> <48AA9C3B.5030309@keyaccess.nl>	 <20080819102633.GE6722@elte.hu> <48AAD680.7020508@keyaccess.nl>	 <20080819190757.GA17470@linux-os.sc.intel.com>	 <20080820100440.GE28492@elte.hu> <48ABF6DC.8070305@keyaccess.nl> <21d7e9970808201402n4d7f5f18waba0685636bb51bf@mail.gmail.com>
In-Reply-To: <21d7e9970808201402n4d7f5f18waba0685636bb51bf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20-08-08 23:02, Dave Airlie wrote:

> On Wed, Aug 20, 2008 at 8:50 PM, Rene Herman
> <rene.herman@keyaccess.nl> wrote:
>> On 20-08-08 12:04, Ingo Molnar wrote:
>> 
>>> * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
>>> 
>>>>> I'd really like a reply from the AGP or PAT side right about
>>>>> now.
>>>> Hmm. Looks like there are more than 16000 entries in the PAT
>>>> list!
>>> hm, btw., why is that?
>> Because 64M of AGP memory divided by 4K pages is 16K. That is, the 
>> underlying problem seems to be AGP drivers using order 0
>> allocations. I'm looking.

[ ... ]

> I haven't anything to add, I'm the maintainer not the author, all the
> people who wrote the offending code were already involved.

The underlying problem is the order 0 allocations (agp_allocate_memory 
--> agp_generic_allocate_page) where each single page is set uncached 
individually, creating a PAT entry.

Non order 0 allocations generally would ofcourse help. That's very much 
AGP internal -- do you feel that's the way to go?

All the current AGP drivers except sgi-agp use agp_generic_alloc_page().

Doing a quick local hack to collect pages in agp_allocate_memory() into 
regions and set the regions (generally 1) UC in one fell swoop, but I 
don't know if that's safe (and it feels like a rather poor hack anyway).

(not to mention that it's time for bed again).

Rene.
