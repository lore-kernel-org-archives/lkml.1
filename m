Return-Path: <linux-kernel-owner+w=401wt.eu-S1764030AbXGYMnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764030AbXGYMnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbXGYMm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:42:59 -0400
Received: from il.qumranet.com ([82.166.9.18]:39208 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbXGYMm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:42:58 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       shaohua.li@intel.com, rusty@rustcorp.com.au, Andi Kleen <ak@suse.de>
Subject: [PATCH 0/3] Scheduler preemption hooks, #2
Date: Wed, 25 Jul 2007 15:43:04 +0300
Message-Id: <11853673872732-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since #2:
- better Kconfig
- documentation
- spinlock->mutex conversion from Shaohua

This patchset adds a general sceduler mechanism that allows tasks to
be notified when they are preempted and scheduled back in, and converts
kvm to use it.  The main benefits are that the kvm mmu can now perform
allocations, enabling features such as guest paging, and reducing preemption
latency to a bounded value for realtime workloads.
