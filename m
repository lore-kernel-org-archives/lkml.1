Return-Path: <linux-kernel-owner+w=401wt.eu-S1758140AbZIOISh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbZIOISh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 04:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757314AbZIOIS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 04:18:29 -0400
Received: from lider.pardus.org.tr ([193.140.100.216]:59277 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834AbZIOIS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 04:18:28 -0400
Message-ID: <4AAF4ECD.5010401@pardus.org.tr>
Date: Tue, 15 Sep 2009 11:22:37 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.22 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: mingo@redhat.com
Subject: Tricks to speed up kernel builds
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd googled a lot about the $subject but couldn't find any detailed
guide about it. So, the followings are what I understand from what I've
found:

1. Build inside a tmpfs to avoid I/O bottlenecks,
2. Use ccache,
3. Switch governor to performance if supported,
4. Pass -j to gnu make to parallelize the build process,
5. Don't build debug symbols a.k.a set CONFIG_DEBUG_INFO=n
6. There are a bunch of sched patches in tip which apparently improves
things during kbuild
7. Distribute the work into the local network using icecream, distcc.

For the -j part, how many jobs should we pass to it? I've seen people
passing

- NR_of_cores+1
- NR_of_cores x 2 (I think that this is useful when there's 2 threads of
execution per core like HyperThreading?)
- 64, 128, etc. regardless of the number of cores (Is it really useful
regardless of the CPU)

The curious question is *what build times can you get* with your typical
systems using your speedup tricks (quad core, dual core, etc.) ? What
are other tricks that I can use to even more speed up the build?

Do you really use icecream/distcc on your daily test builds?

How about nicing/ionicing make on an idle system? Will it make any
difference?

Thanks a lot
Ozan Caglayan




