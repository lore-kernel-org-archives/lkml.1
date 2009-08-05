Return-Path: <linux-kernel-owner+w=401wt.eu-S1752977AbZHEXMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbZHEXMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 19:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbZHEXMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 19:12:38 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:55042 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbZHEXMh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 19:12:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sn+DoTpOGStPfTlSoJfkTcENMHApQxnhgRzR736beLTB62SODM2CNM/wQTQp8UAyba
         JudXbIws3hmv1kfL4XjPfEMW7qaj4U6KOn8HoGeYm/0yUppLywuvmYyvSFrDzmZrsjv/
         dZmhRIckP8LacNJkhdV3slEGX96zblM5CF1bM=
MIME-Version: 1.0
In-Reply-To: <4A79CEEC.9030008@goop.org>
References: <1248707041.6100.35.camel@macbook.infradead.org>
	 <21d7e9970907282328l4a44b9a2of4500c5c84a3586b@mail.gmail.com>
	 <1248851712.19733.214.camel@macbook.infradead.org>
	 <21d7e9970907290143q6778511cvda1c6b915f61654a@mail.gmail.com>
	 <1248860205.19733.238.camel@macbook.infradead.org>
	 <4A78C9C6.6010103@goop.org>
	 <1249454696.9324.325.camel@macbook.infradead.org>
	 <21d7e9970908042357m6080e88fyeaaad171888766f2@mail.gmail.com>
	 <4A79CEEC.9030008@goop.org>
Date: Thu, 6 Aug 2009 09:12:37 +1000
Message-ID: <21d7e9970908051612v140c2ebfu591e8fe817237889@mail.gmail.com>
Subject: Re: [Xen-devel] Re: [RFC] Make AGP work with IOMMU
From: Dave Airlie <airlied@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Keir Fraser <kier.fraser@eu.citrix.com>, xen-devel@lists.xensource.com,
       Joerg Roedel <joerg.roedel@amd.com>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyu.z.wang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 6, 2009 at 4:26 AM, Jeremy Fitzhardinge<jeremy@goop.org> wrote:
> On 08/04/09 23:57, Dave Airlie wrote:
>>> All we've done so far is make intel-agp use the DMA API correctly. And
>>> that's conditional on CONFIG_DMAR. But we could make it unconditional,
>>> and make the other drivers do it too. The code is all fairly generic.
>>>
>>> Without an IOMMU, the overhead would be fairly minimal.
>>>
>>>
>>
>> I'm not sure how prevalent Xen is on AGP systems, I'm going to guess
>> not enough that anyone cares.
>
> What do you mean by AGP here?  Do you mean "machine with physical AGP
> port", or "machine with graphics using the AGP aperature"?  There's an
> increasing interest in putting Xen on desktop machines, so the former is
> debatable, but the latter (I think?) definitely isn't true.
>

I split my mail along those lines already, an AGP system is one
with a physical AGP port, I think you'll probably find a few people
still running some Athlons with VIA chipset and radeon 9200s I think,

The graphics using AGP-like apertures are only Intel and we've fixed those.

>>  Intel integrated chips are the only AGP
>> codebase user that are made any more, and they don't really use AGP
>> its just a legacy of the previous designs.
>>
>>
>
> Plenty of people are using older machines for testing, etc, so I
> wouldn't want to exclude them too lightly.  I've got bug reports from
> people using older Radeons, etc.

My main problem with doing this is getting testing coverage on older
systems, if we change all the AGP drivers, the time to find we busted
something is probably not until the next major distro release with this code
in it. So people can run stuff on 5 year old hardware in 6 months? I'm
not sure the gains justify the costs, but if you guys really want to do it
I'll take the patch, just be prepared to have it ripped out the minute
we get a regression we can't figure out because we haven't got the hw anymore.

Dave.
