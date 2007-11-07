Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbXKGOUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbXKGOUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 09:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757759AbXKGOUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 09:20:41 -0500
Received: from il.qumranet.com ([82.166.9.18]:50632 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756802AbXKGOUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 09:20:40 -0500
From: Amit Shah <amit.shah@qumranet.com>
To: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: RFC: Paravirtualized DMA accesses for KVM
Date: Wed,  7 Nov 2007 16:21:01 +0200
Message-Id: <1194445269752-git-send-email-amit.shah@qumranet.com>
X-Mailer: git-send-email 1.5.3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset is work in progress and is sent out for comments.

Guests within KVM can have paravirtualized DMA access. I've tested
the e1000 driver, and that works fine. A few problems/conditions to
get things to work:

- The pv driver should only be used as a module. If built into the
  kernel, It freezes during the HD bringup
- Locks aren't taken on the host; multiple guests with passthrough
  won't work
- Only 64 bit host and 64 bit guests are supported

And there are several FIXMEs mentioned in the code, but none
as grave as the ones already mentioned above.

The bulk of the passthrough work is done in userspace (qemu). Patches
will be sent shortly to the kvm-devel and qemu lists.
