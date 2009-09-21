Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbZIUPIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbZIUPIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 11:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756310AbZIUPI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 11:08:29 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:52787 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554AbZIUPIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 11:08:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=QfhM3knLduwxcOhSVJ5ltVDZsVVPSshxgCsTxj3FCz6dn6uO9ythn8CJ+mVkvcR8Fy
         Xowno6DVEC/nq7ASS9N3yXkanuddJhOkLRgzDIa4jmjki04sXECLpM+hT94yjxI8VuUf
         lnz9t2X/9Dn19TNRYa9Bx1bAiaQj1FxgzjF9Q=
MIME-Version: 1.0
In-Reply-To: <2f11576a0909210800l639560e4jad6cfc2e7f74538f@mail.gmail.com>
References: <2f11576a0909210800l639560e4jad6cfc2e7f74538f@mail.gmail.com>
Date: Tue, 22 Sep 2009 00:08:28 +0900
Message-ID: <2f11576a0909210808r7912478cyd7edf3550fe5ce6@mail.gmail.com>
Subject: Re: a patch drop request in -mm
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/22 KOSAKI Motohiro <kosaki.motohiro@gmail.com>:
> Mel,
>
> Today, my test found following patch makes false-positive warning.
> because, truncate can free the pages
> although the pages are mlock()ed.
>
> So, I think following patch should be dropped.
> .. or, do you think truncate should clear PG_mlock before free the page?
>
> Can I ask your patch intention?

stacktrace is here.


------------[ cut here ]------------
WARNING: at mm/page_alloc.c:502 free_page_mlock+0x84/0xce()
Hardware name: PowerEdge T105
Page flag mlocked set for process dd at pfn:172d4b
page:ffffea00096a6678 flags:0x700000000400000
Modules linked in: fuse usbhid bridge stp llc nfsd lockd nfs_acl
exportfs sunrpc cpufreq_ondemand powernow_k8 freq_table dm_multipath
kvm_amd kvm serio_raw e1000e i2c_nforce2 i2c_core tg3 dcdbas sr_mod
cdrom pata_acpi sata_nv uhci_hcd ohci_hcd ehci_hcd usbcore [last
unloaded: scsi_wait_scan]
Pid: 27030, comm: dd Tainted: G        W  2.6.31-rc9-mm1 #13
Call Trace:
 [<ffffffff8105fd76>] warn_slowpath_common+0x8d/0xbb
 [<ffffffff8105fe31>] warn_slowpath_fmt+0x50/0x66
 [<ffffffff81102483>] ? mempool_alloc+0x80/0x146
 [<ffffffff811060fb>] free_page_mlock+0x84/0xce
 [<ffffffff8110640a>] free_hot_cold_page+0x105/0x20b
 [<ffffffff81106597>] __pagevec_free+0x87/0xb2
 [<ffffffff8110ad61>] release_pages+0x17c/0x1e8
 [<ffffffff810a24b8>] ? trace_hardirqs_on_caller+0x32/0x17b
 [<ffffffff8112ff82>] free_pages_and_swap_cache+0x72/0xa3
 [<ffffffff8111f2f4>] tlb_flush_mmu+0x46/0x68
 [<ffffffff8111f935>] unmap_vmas+0x61f/0x85b
 [<ffffffff810a24b8>] ? trace_hardirqs_on_caller+0x32/0x17b
 [<ffffffff8111fc2b>] zap_page_range+0xba/0xf9
 [<ffffffff8111fce4>] unmap_mapping_range_vma+0x7a/0xff
 [<ffffffff8111ff2f>] unmap_mapping_range+0x1c6/0x26d
 [<ffffffff8110c407>] truncate_pagecache+0x49/0x85
 [<ffffffff8117bd84>] simple_setsize+0x44/0x64
 [<ffffffff8110b856>] vmtruncate+0x25/0x5f
 [<ffffffff81170558>] inode_setattr+0x4a/0x83
 [<ffffffff811e817b>] ext4_setattr+0x26b/0x314
 [<ffffffff8117088f>] ? notify_change+0x19c/0x31d
 [<ffffffff811708ac>] notify_change+0x1b9/0x31d
 [<ffffffff81150556>] do_truncate+0x7b/0xac
 [<ffffffff811606c1>] ? get_write_access+0x59/0x76
 [<ffffffff81163019>] may_open+0x1c0/0x1d3
 [<ffffffff811638bd>] do_filp_open+0x4c3/0x998
 [<ffffffff81171d80>] ? alloc_fd+0x4a/0x14b
 [<ffffffff81171e5b>] ? alloc_fd+0x125/0x14b
 [<ffffffff8114f472>] do_sys_open+0x6f/0x14f
 [<ffffffff8114f5bf>] sys_open+0x33/0x49
 [<ffffffff8100bf72>] system_call_fastpath+0x16/0x1b
---[ end trace e76f92f117e9e06e ]---
