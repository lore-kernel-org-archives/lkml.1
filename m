Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbZJQOzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbZJQOzG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 10:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbZJQOzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 10:55:06 -0400
Received: from sh.osrg.net ([192.16.179.4]:47297 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZJQOzD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 10:55:03 -0400
Date: Sat, 17 Oct 2009 23:51:32 +0900
To: akinobu.mita@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       sparclinux@vger.kernel.org, benh@kernel.crashing.org, paulus@samba.org,
       linuxppc-dev@ozlabs.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, x86@kernel.org, gregkh@suse.de, LW@karo-electronics.de,
       linux-usb@vger.kernel.org, rolandd@cisco.com, yevgenyp@mellanox.co.il,
       netdev@vger.kernel.org, tony.luck@intel.com, fenghua.yu@intel.com,
       linux-ia64@vger.kernel.org, linux-altix@sgi.com
Subject: Re: [PATCH 2/8] bitmap: Introduce bitmap_set, bitmap_clear, 
	bitmap_find_next_zero_area
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <961aa3350910170743n4c9947d1ka0bd31aa1c7b9917@mail.gmail.com>
References: <20091013091017.GA18431@localhost.localdomain>
	<20091017224028V.fujita.tomonori@lab.ntt.co.jp>
	<961aa3350910170743n4c9947d1ka0bd31aa1c7b9917@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-Id: <20091017235117U.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 17 Oct 2009 23:51:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Oct 2009 23:43:56 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> 2009/10/17 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:
> > On Tue, 13 Oct 2009 18:10:17 +0900
> > Akinobu Mita <akinobu.mita@gmail.com> wrote:
> >
> >> My user space testing exposed off-by-one error find_next_zero_area
> >> in iommu-helper. Some zero area cannot be found by this bug.
> >>
> >> Subject: [PATCH] Fix off-by-one error in find_next_zero_area
> >>
> >> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> >> ---
> >>  lib/iommu-helper.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
> >> index 75dbda0..afc58bc 100644
> >> --- a/lib/iommu-helper.c
> >> +++ b/lib/iommu-helper.c
> >> @@ -19,7 +19,7 @@ again:
> >>       index = (index + align_mask) & ~align_mask;
> >>
> >>       end = index + nr;
> >> -     if (end >= size)
> >> +     if (end > size)
> >
> > I think that this is intentional; the last byte of the limit doesn't
> > work.
> 
> It looks ok to me. Without above change, find_next_zero_area cannot
> find a 64 bits zeroed area in next sample code.

I meant that we don't want to find such area for IOMMUs (IIRC, it code
came from POWER IOMMU).


>         unsigned long offset;
> 
>         DECLARE_BITMAP(map, 64);
> 
>         bitmap_clear(map, 0, 64);
>         offset = find_next_zero_area(map, 64, 0, 64, 0);
>         if (offset >= 64)
>                 printf("not found\n");
>         else
>                 printf("found\n");
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ia64" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
