Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbZJ2Ix2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbZJ2Ix2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbZJ2Ix1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:53:27 -0400
Received: from mail-qy0-f174.google.com ([209.85.221.174]:44540 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbZJ2IxZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:53:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GBRpl977WMugn//tpmeQa2Tlr2l9Vof/fuQ7wcc3+70V3Rs9yMvfsTNxzAC6TeQPva
         1DkJaEzM1BYekzVTxnX/wXB7LIb1I9fzJQYlsxpwbEiXsaIu5Jt8U+wESUEIp26e+lv7
         t0/B6EX7zxejQu0vVb3gjmNoa7fKB9iT8Qxng=
MIME-Version: 1.0
In-Reply-To: <20091028131141.523854cb.akpm@linux-foundation.org>
References: <1256719397-4258-1-git-send-email-akinobu.mita@gmail.com>
	 <20091028131141.523854cb.akpm@linux-foundation.org>
Date: Thu, 29 Oct 2009 17:53:29 +0900
Message-ID: <961aa3350910290153n70c3d982w10699ac28be63b6c@mail.gmail.com>
Subject: Re: [PATCH 1/7] bitmap: Introduce bitmap_set, bitmap_clear, 
	bitmap_find_next_zero_area
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Lothar Wassmann <LW@karo-electronics.de>, linux-usb@vger.kernel.org,
       Roland Dreier <rolandd@cisco.com>,
       Yevgeny Petrilin <yevgenyp@mellanox.co.il>, netdev@vger.kernel.org,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org, linux-altix@sgi.com,
       Joerg Roedel <joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/29 Andrew Morton <akpm@linux-foundation.org>:
>
> Why were these patches resent?  What changed?
>
> Everybody who is going to review these patches has already reviewed
> them and now they need to review them all again?

I resent the patches because the iommu-helper change was not correct
and I introduced serious bug in bitmap_find_next_zero_area()
if align_mask != 0 in follow-up patch then those were dropped from
the -mm tree.

Only [PATCH 1/7] and [PATCH 2/7] have changes since the first submission of
this patch set.

* [PATCH 1/7]
- Rewrite bitmap_set() and bitmap_clear()
- Let bitmap_find_next_zero_area() check the last bit of the limit
- Add kerneldoc for bitmap_find_next_zero_area()

* [PATCH 2/7]
- Convert find_next_zero_area() to use bitmap_find_next_zero_area() correctly
  iommu-helper doesn't want to search the last bit of the limist in bitmap

* [PATCH 3/7] - [PATCH 7/7]
- No changes
