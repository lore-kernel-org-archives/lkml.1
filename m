Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700AbZJQPmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbZJQPmE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 11:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbZJQPmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 11:42:03 -0400
Received: from mail-qy0-f194.google.com ([209.85.221.194]:35671 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbZJQPmA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 11:42:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nYDhqAAztxCDoitVx1qkyN/SkOflITH9V9x/BlZXRzF6bv+yedHIcu1WCx/U5NKGcC
         XF56bB0jdPpORWKrInIbL9hnq2LG35X5AvTYdDdgnHqWQgy21P009NOALTl6n1G6ntY8
         tCTvid3ZG/9KxcS5pkg8KR3sT5HWPg5WeI55A=
MIME-Version: 1.0
In-Reply-To: <20091017235117U.fujita.tomonori@lab.ntt.co.jp>
References: <20091013091017.GA18431@localhost.localdomain>
	 <20091017224028V.fujita.tomonori@lab.ntt.co.jp>
	 <961aa3350910170743n4c9947d1ka0bd31aa1c7b9917@mail.gmail.com>
	 <20091017235117U.fujita.tomonori@lab.ntt.co.jp>
Date: Sun, 18 Oct 2009 00:42:04 +0900
Message-ID: <961aa3350910170842w58a72be0id5fbd0e3a5058a1c@mail.gmail.com>
Subject: Re: [PATCH 2/8] bitmap: Introduce bitmap_set, bitmap_clear, 
	bitmap_find_next_zero_area
From: Akinobu Mita <akinobu.mita@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davem@davemloft.net, sparclinux@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       gregkh@suse.de, LW@karo-electronics.de, linux-usb@vger.kernel.org,
       rolandd@cisco.com, yevgenyp@mellanox.co.il, netdev@vger.kernel.org,
       tony.luck@intel.com, fenghua.yu@intel.com, linux-ia64@vger.kernel.org,
       linux-altix@sgi.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> >> --- a/lib/iommu-helper.c
>> >> +++ b/lib/iommu-helper.c
>> >> @@ -19,7 +19,7 @@ again:
>> >>       index = (index + align_mask) & ~align_mask;
>> >>
>> >>       end = index + nr;
>> >> -     if (end >= size)
>> >> +     if (end > size)
>> >
>> > I think that this is intentional; the last byte of the limit doesn't
>> > work.
>>
>> It looks ok to me. Without above change, find_next_zero_area cannot
>> find a 64 bits zeroed area in next sample code.
>
> I meant that we don't want to find such area for IOMMUs (IIRC, it code
> came from POWER IOMMU).

OK, I see.  I think we need the comment about it.

So we cannot replace find_next_zero_area by bitmap_find_next_zero_area
and current -mmotm has the bug introduced by this patch in iommu-helper
and I also introduced the bug in bitmap_find_next_zero_area if
align_mask != 0 in
bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area-fix.patch

Andrew, please drop

lib-iommu-helperc-fix-off-by-one-error-in-find_next_zero_area.patch
iommu-helper-simplify-find_next_zero_area.patch
bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area.patch
bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area-fix.patch
iommu-helper-use-bitmap-library.patch
isp1362-hcd-use-bitmap_find_next_zero_area.patch
mlx4-use-bitmap_find_next_zero_area.patch
sparc-use-bitmap_find_next_zero_area.patch
ia64-use-bitmap_find_next_zero_area.patch
genalloc-use-bitmap_find_next_zero_area.patch

I'll overhaul the patchset and retry again.
