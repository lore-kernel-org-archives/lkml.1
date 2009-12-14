Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbZLNDme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbZLNDme (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 22:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbZLNDme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 22:42:34 -0500
Received: from sh.osrg.net ([192.16.179.4]:57747 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913AbZLNDmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 22:42:33 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 0/2] x86: gart: fix the HW IOMMU initialization rewrite breakage
Date: Mon, 14 Dec 2009 11:52:13 +0900
Message-Id: <1260759135-6450-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 14 Dec 2009 12:41:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes GART issues due to the commit
75f1cdf1dda92cae037ec848ae63690d91913eac (x86: Handle HW IOMMU
initialization failure gracefully).

This is a revised version of:

http://marc.info/?l=linux-kernel&m=126027050409121&w=2

I replaced the first patch with a simpler one (*1). With the new
patch, systems that use swiotlb temporarily allocate more memory than
they do now. But swiotlb uses any area in ZONE_DMA32 so I doubt that
it matters. If swiotlb can't allocate memory, the system panics. So
there is no danger of data corruption (or something really bad). We
can use more complicated tricks (such as I posted before) when we find
that this simple approach doesn't work.

(*1) http://marc.info/?l=linux-kernel&m=125905247710259&w=2


