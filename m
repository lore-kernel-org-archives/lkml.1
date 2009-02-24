Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbZBXJT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbZBXJT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 04:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbZBXJTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 04:19:08 -0500
Received: from mail-bw0-f167.google.com ([209.85.218.167]:37476 "EHLO
	mail-bw0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbZBXJTG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 04:19:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YxYnkcWJ4y9z1yQfrV3FpusfT+nUclEXpuzoOQeIYq1scIWpxzAB/xQ0CNK/Q542KY
         uyHD1BvhwC8/4GGtwx2+ro6LVnPExq6bL9scNpSPJqouG1EOj4daFGM5mbz3U2yQ/1Rl
         oFvAeSvfim4k/3O4b7pbQMa/nKwlbRB7IEDMc=
MIME-Version: 1.0
In-Reply-To: <8db1092f0902240054jc2fd751m2c707bd687ddeab8@mail.gmail.com>
References: <8db1092f0902230646o78a07a09t920ad65369b5a20d@mail.gmail.com>
	 <1235419343.4816.27.camel@gaiman> <200902232230.29501.rjw@sisk.pl>
	 <8db1092f0902231340k7c7d0fd1me49302f2efd03491@mail.gmail.com>
	 <86802c440902231701q1e169a67oa12bd84ac0e4c7aa@mail.gmail.com>
	 <8db1092f0902232254q10826fei8b8125b3da5f233@mail.gmail.com>
	 <8db1092f0902240054jc2fd751m2c707bd687ddeab8@mail.gmail.com>
Date: Tue, 24 Feb 2009 10:01:17 +0100
Message-ID: <8db1092f0902240101p1673cdfal6bf6c98f4d1d1e97@mail.gmail.com>
Subject: Re: [Linux 2.6.29-rc6] [drm:i915_set_status_page] *ERROR* can not 
	ioremap virtual address for G33 hw status page
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "lenb@kernel.org" <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       mjg@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       rui.zhang@intel.com, airlied@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/24 Maciej Rutecki <maciej.rutecki@gmail.com>:
> 2009/2/24 Maciej Rutecki <maciej.rutecki@gmail.com>:
>> 2009/2/24 Yinghai Lu <yinghai@kernel.org>:
>>
>>>
>>> CONFIG_MTRR=y
>>> CONFIG_MTRR_SANITIZER=y
>>> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
>>> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
>>>
>>> should help mtrr ones.
>>>
>>> please post bootlog with those option set.
>>>
>>> YH
>>>
>>
>> It doesn't help, see previous mails.
>>
>>
>
> l also update bios, and try:
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
>
[...]

> [   16.383701] [drm] Initialized drm 1.1.0 20060810
> [   16.418166] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   16.418176] pci 0000:00:02.0: setting latency timer to 64
> [   16.420993] pci 0000:00:02.0: irq 27 for MSI/MSI-X
> [   16.421076] [drm] Initialized i915 1.6.0 20080730 on minor 0
> [   16.747905] set status page addr 0x00043000
> [   16.747932] [drm:i915_set_status_page] *ERROR* can not ioremap
> virtual address for G33 hw status page
>

Hmm. Its one difference, previous I had:
[   18.170614] [drm] Initialized drm 1.1.0 20060810
[   18.247445] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   18.247455] pci 0000:00:02.0: setting latency timer to 64
[   18.249610] mtrr: type mismatch for d0000000,10000000 old:
write-back new: write-combining
[   18.249621] [drm] MTRR allocation failed
[   18.249622] .  Graphics performance may suffer.
[   18.249658] pci 0000:00:02.0: irq 27 for MSI/MSI-X
[   18.249691] [drm] Initialized i915 1.6.0 20080730 on minor 0
[   18.290152] mtrr: type mismatch for d0000000,10000000 old:
write-back new: write-combining
[   18.567435] set status page addr 0x00043000
[   18.567463] [drm:i915_set_status_page] *ERROR* can not ioremap
virtual address for G33 hw status page

So warning about mtrr has gone. But still Xwindow doesn't start.
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
