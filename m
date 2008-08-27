Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbYH0Hpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbYH0Hpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 03:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbYH0Hp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 03:45:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:18101 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbYH0Hp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 03:45:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ucP2MvScyPA/HXzLprkAV5tCo18mtedcY+/T7x2PlWYJU1scts5HI2cVChk+lwfd9n
         xf4xMdvvvxUH2S6VuNH2FzLzEXsjLXBU9piKPyvs6d/ACU4lZMJkqqLlQljA/WWzm943
         ijKKChfGEY+hsaGlEWVLDHt3KFMIRHqcC7sGo=
Message-ID: <86802c440808270045o2d2390d3ka969095da671bd81@mail.gmail.com>
Date: Wed, 27 Aug 2008 00:45:26 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: benh@kernel.crashing.org
Subject: Re: RFC [PATCH] x86/pci: reserve extra page to avoid error caused by P2P pref DMA reads
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Pavel Machek" <pavel@suse.cz>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
In-Reply-To: <1219822840.13162.184.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219822159-17245-1-git-send-email-yhlu.kernel@gmail.com>
	 <1219822840.13162.184.camel@pasglop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 12:40 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Wed, 2008-08-27 at 00:29 -0700, Yinghai Lu wrote:
>> Diag guys, found one system when loading is high, will have gart wark error.
>> root cause is P2P bridge try to prefetch for several intel e1000 under
>> it. and that skb is near GART iommu area.
>>
>> try to reserve page in the boundary at first.
>> last page near TOM2, and last page near MMIO
>> also gart first and last page.
>>
>> need one better way for all arch support PCI and memory with a lot of holes etc.
>
> Sounds like a similar problem for which we don't unmap GART pages,
> just map them read-only and route them to a dummy page. In that
> case, the right approach is to write the last page of the GART
> to the dummy page as well and mark it occupied. That shouldn't
> involve actually reserving memory.

i should split it into two patches. that patch include two patch
second part is doing map to scratch memory.

but memory near TOP of MEMORY and TOP of MEMORY2, could have the same problem.

YH
