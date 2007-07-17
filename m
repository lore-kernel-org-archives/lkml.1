Return-Path: <linux-kernel-owner+w=401wt.eu-S1759153AbXGQNW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759153AbXGQNW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 09:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbXGQNWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 09:22:46 -0400
Received: from il.qumranet.com ([82.166.9.18]:43817 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbXGQNWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 09:22:45 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: KVM: Late fixes for the 2.6.23 merge window
Date: Tue, 17 Jul 2007 16:22:49 +0300
Message-Id: <11846785722851-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A trio of issues were discovered and fixed while bringing up smp guests:

- An nx huge page table shadow could alias a real mode shadow page table,
  causing the real mode page to be treated as not executable.  For certain
  newer Linux kernels, this caused kvm to spin on the smp trampoline.

  This is not an smp issue per se, but only triggered in that scenario.

- The memory slot and memory alias manipulation functions were not handled
  properly in guest smp.  This causes hangs starting X.  With the patch
  applied, Linux can boot into graphical mode.

- Windows apparently uses rdmsr and wrmsr on its trampoline, so we need to
  add these instructions to the x86 emulator.

With these three patches atop the previously submitted patchset, guest smp
is fully operational.  Kernel build on 2-way smp is 40% faster than on a up
guest.  Expect significant performance improvements from in-kernel apic and
from further tuning.

Please review -- comments welcome.
