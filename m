Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbXLGO6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbXLGO6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 09:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756230AbXLGO5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 09:57:32 -0500
Received: from mo10.iij4u.or.jp ([210.138.174.78]:50230 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209AbXLGO5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 09:57:30 -0500
Date: Fri, 7 Dec 2007 23:56:37 +0900
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       muli@il.ibm.com, benh@kernel.crashing.org, paulus@samba.org,
       olof@lixom.net, anton@samba.org
Cc: fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH -mm 0/6] fix iommu segment boundary problems (powerpc and
 x86)
From: FUJITA Tomonori <tomof@acm.org>
Message-Id: <21710c4b9cd6848e70e29949dfb54894e9aabbe6.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is a sequel to my patchset to fix iommu segment boundary
problems:

http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg11919.html

This adds new IOMMU helper functions for the free area
management. These functions take care of LLD's segment boundary limit
for IOMMUs. They are useful for IOMMUs that use bitmap for the free
area management.

The helper functions are very low level. They just find a free area in
bitmap appropriate for low level drivers. The IOMMUs continue to use
their hardware specific techniques easily with the low level helper
functions.

This patchset converts three IOMMUs: POWERPC, X86 calgary, and X86 gart
but I tested POWERPC patch. The rest are only compile tested since I
don't have hardware.

This is against 2.6.24-rc4-mm1.
