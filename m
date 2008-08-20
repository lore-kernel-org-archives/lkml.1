Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbYHTVCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbYHTVCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 17:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbYHTVCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 17:02:07 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:57620 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbYHTVCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 17:02:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xrkC79+ldZMZHibGvFLOWxgROG/up4CSCz3MDxmbWkPk+K11SZ9dnT8Vk4Ya63sGcI
         aqthctofU70Km7S944BGgRZ8GssNgADy9KqGwIpwIvOfi3SvecGTZZ6mlLSIaSzjd591
         yI0q5eYOAAEBwsyc4xoFaMbkhxueOx9ZzR1bM=
Message-ID: <21d7e9970808201402n4d7f5f18waba0685636bb51bf@mail.gmail.com>
Date: Thu, 21 Aug 2008 07:02:00 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Rene Herman" <rene.herman@keyaccess.nl>
Subject: Re: AGP and PAT (induced?) problem (on AMD family 6)
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Venki Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "dri-users@lists.sourceforge.net" <dri-users@lists.sourceforge.net>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Dave Jones" <davej@codemonkey.org.uk>
In-Reply-To: <48ABF6DC.8070305@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48972EA8.8040001@keyaccess.nl> <20080815142218.GC12954@elte.hu>
	 <48A59FAC.7050605@keyaccess.nl> <48AA9C3B.5030309@keyaccess.nl>
	 <20080819102633.GE6722@elte.hu> <48AAD680.7020508@keyaccess.nl>
	 <20080819190757.GA17470@linux-os.sc.intel.com>
	 <20080820100440.GE28492@elte.hu> <48ABF6DC.8070305@keyaccess.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 8:50 PM, Rene Herman <rene.herman@keyaccess.nl> wrote:
> On 20-08-08 12:04, Ingo Molnar wrote:
>
>> * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
>>
>>>> I'd really like a reply from the AGP or PAT side right about now.
>>>
>>> Hmm. Looks like there are more than 16000 entries in the PAT list!
>>
>> hm, btw., why is that?
>
> Because 64M of AGP memory divided by 4K pages is 16K. That is, the
> underlying problem seems to be AGP drivers using order 0 allocations. I'm
> looking.
>
> Do note also that this means that Venki's change would not constitite a
> correct/final fix. Sure, caching the last entry speeds up traversing a 16K
> entry list but the issue is that there shouldn't be a 16K entry list.
> Through AGP, or maybe even by coalescing entries in the PAT list if that's
> at all possible (I guess it's not really).
>
> Even if such a more fundamental fix isn't (easily) available, the PAT code
> already comments that the list, which is sorted by ->start value, is
> expected to be short, and should be turned into an rbtree if it isn't which
> might be slightly less of a bandaid.
>
> Dave Airlie (as the MAINTAINERS entry) can't be arsed to answer email it
> seems so I've added Dave Jones for a possible comment from the AGP side.
> If I'm reading this right upto now, still many AGP driver (among which my
> amd-k7-agp) are affected.

I haven't anything to add, I'm the maintainer not the author, all the
people who wrote the offending code were
already involved.

Dave.
>
> In the short run and if I'm not just mistaken, the best fix might be to make
> PAT dependent on not having a dumb AGP driver (but as said, still looking).
>
> Note that my chipset is capable of a 2G AGP aperture. That's 512K pages if
> fully used, 256K for 1G, 128K for 512M, ...
>
> Rene.
>
