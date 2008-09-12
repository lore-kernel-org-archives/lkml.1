Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbYILKsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbYILKsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 06:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYILKrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 06:47:10 -0400
Received: from sh.osrg.net ([192.16.179.4]:37431 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbYILKrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 06:47:09 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu
Cc: joerg.roedel@amd.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 0/3] fix GART to respect device's dma_mask about virtual mappings
Date: Fri, 12 Sep 2008 19:42:32 +0900
Message-Id: <1221216155-17640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, gart IOMMU ignores device's dma_mask when it does virtual
mappings. So it could give a device a virtual address that the device
can't access to.

Some IOMMUs, in x86 IOMMUs GART and Calgary, have this issue. This
patchset fixes GART.

The first and second patches add helper functions, useful for some
IOMMUs (both are taken from POWER IOMMU code). I'll convert some
IOMMUs to use the functions after they are merged into mainline (to
avoid complicated dependence on multiple trees).

This is against tip/x86/iommu plus a patch that I sent yesterday:

http://lkml.org/lkml/2008/9/11/147.



