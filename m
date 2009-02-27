Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbZB0LOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbZB0LOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 06:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbZB0LON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 06:14:13 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:48284 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbZB0LOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 06:14:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BzGM9xgryn+M5ORRtL7GiHrFLQLkYI9KH8wf1uFWGB99dEodWygS3KyPu3k6aLGE3z
         07xJ7FrXHNezDEQtXHvLQRkzB2SGXw5AvnzKVdD6CdT9JsTmx3UCc9ShR/E2OBwZEYu5
         mxxA/GlOupn8rw+RwseepgHOgf/MvYDrxzzx4=
MIME-Version: 1.0
In-Reply-To: <49A55742.5030104@redhat.com>
References: <8db1092f0902230646o78a07a09t920ad65369b5a20d@mail.gmail.com>
	 <1235419343.4816.27.camel@gaiman> <200902232230.29501.rjw@sisk.pl>
	 <8db1092f0902231340k7c7d0fd1me49302f2efd03491@mail.gmail.com>
	 <86802c440902231701q1e169a67oa12bd84ac0e4c7aa@mail.gmail.com>
	 <20090224032304.GA26344@hexapodia.org>
	 <86802c440902232150m2b22e3cfg8993193f8867dfbf@mail.gmail.com>
	 <20090224064830.GA12600@hexapodia.org>
	 <20090224225424.GB12600@hexapodia.org> <49A55742.5030104@redhat.com>
Date: Fri, 27 Feb 2009 12:14:08 +0100
Message-ID: <8db1092f0902270314j6c4b4285gf74f4f74deebbc21@mail.gmail.com>
Subject: Re: [Linux 2.6.29-rc6] [drm:i915_set_status_page] *ERROR* can not 
	ioremap virtual address for G33 hw status page
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: Andy Isaacson <adi@hexapodia.org>, Yinghai Lu <yinghai@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "lenb@kernel.org" <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       mjg@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       rui.zhang@intel.com, airlied@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I already test 2.6.29-rc6-git4, and seems work OK (X Window works
without any problems). I have "MTRR allocation failed" in dmesg:

[   40.484827] [drm] Initialized drm 1.1.0 20060810
[   40.535196] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   40.535206] pci 0000:00:02.0: setting latency timer to 64
[   40.537427] mtrr: type mismatch for d0000000,10000000 old:
write-back new: write-combining
[   40.537434] [drm] MTRR allocation failed
[   40.537435] .  Graphics performance may suffer.
[   40.537463] pci 0000:00:02.0: irq 27 for MSI/MSI-X
[   40.537492] [drm] Initialized i915 1.6.0 20080730 on minor 0
[   40.572646] mtrr: type mismatch for d0000000,10000000 old:
write-back new: write-combining
[   40.867365] set status page addr 0x00043000

But I don't use CONFIG_MTRR_SANITIZER:
root@zlom:/home/maciek/kernel.org/2.6.29-rc6-git4# cat
config-2.6.29-rc6-git4 | grep MTRR
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set

Config, and dmesg:
http://unixy.pl/maciek/download/kernel/2.6.29-rc6-git4/zlom/

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
