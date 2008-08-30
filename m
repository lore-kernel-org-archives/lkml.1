Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbYH3ICo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbYH3ICo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 04:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbYH3IC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 04:02:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:2992 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbYH3IC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 04:02:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kOdxK9J7hn1VI5yQydnvMja5L3BJ5R3mbfD7goK4pRhfy5yDDtUQTW+o0w6MV17W34
         A6EbedpXe9aVx9PvhTzIlaM5USLBQWHP89tOJ7KVmJ/CEtPTwax0HgRg10HVXbYpsdau
         dKpurs9AuCzGUF9iFK8W9777WVx6ydZKEKM4E=
Message-ID: <86802c440808300102nfd878adqc68d53159858f94e@mail.gmail.com>
Date: Sat, 30 Aug 2008 01:02:25 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0808292312120.3290@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0808291751480.3300@nehalem.linux-foundation.org>
	 <86802c440808291830t4547140dx9b12353649edd975@mail.gmail.com>
	 <alpine.LFD.1.10.0808291919080.3300@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0808291954410.3300@nehalem.linux-foundation.org>
	 <86802c440808292007t3588edfnef95b723320ff023@mail.gmail.com>
	 <alpine.LFD.1.10.0808292017440.5010@nehalem.linux-foundation.org>
	 <86802c440808292141g6ffd1329p54e58ee04c26540a@mail.gmail.com>
	 <alpine.LFD.1.10.0808292216310.3290@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0808292312120.3290@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check fix v3

[PATCH] x86: split e820 reserved entries record to late v4 - fix v3

try to insert_resource second time, by expand the resource...

for case: e820 reserved entry is partially overlapped with bar res...

hope it will never happen

v3: use reserve_region_with_split() instead to hand overlapping
       with test case by extend 0xe0000000 - 0xeffffff to 0xdd800000 -
       get
               e0000000-efffffff : PCI MMCONFIG 0
                        e0000000-efffffff : reserved
       in /proc/iomem
       get
               found conflict for reserved [dd800000, efffffff], try
to reserve with split
                   __reserve_region_with_split: (PCI Bus #80)
[dd000000, ddffffff], res: (reserved) [dd800000, efffffff]
                   __reserve_region_with_split: (PCI Bus #00)
[de000000, dfffffff], res: (reserved) [de000000, efffffff]
               initcall pci_subsys_init+0x0/0x121 returned 0 after 381 msecs
       in dmesg

YH
