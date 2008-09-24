Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYIXLw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYIXLw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 07:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbYIXLwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 07:52:17 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:43001 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbYIXLwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 07:52:16 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, joerg.roedel@amd.com,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 0/3] x86: restore old GART alloc_coherent
Date: Wed, 24 Sep 2008 20:48:34 +0900
Message-Id: <1222256917-14321-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This pachset is against tip/iommu.

What this patchset does is restoring old GART alloc_coherent behavior
(before the alloc_coherent rewrite):

http://lkml.org/lkml/2008/8/12/200

Currently, GART alloc_coherent tries to allocate pages with GFP_DMA32
for a device having dma_masks > 24bit < 32bits. If GART gets an
address that a device can't access to, GART tries to map the address
to a virtual I/O address that the device can access to.

But Andi pointed out, "The GART is somewhere in the 4GB range so you
cannot use it to map anything < 4GB. Also GART is pretty small."

http://lkml.org/lkml/2008/9/12/43

So it's possible that GART doesn't have virtual I/O address space that
a device can access to. The current behavior might not work for a
device having dma_masks > 24bit < 32bits. This patchset restores old
GART alloc_coherent behavior, which doesn't use GART hardware (if an
user doesn't enable force_iommu option).


