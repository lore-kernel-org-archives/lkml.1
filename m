Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbZJZWCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbZJZWCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 18:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbZJZWCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 18:02:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:19890 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873AbZJZWCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 18:02:33 -0400
X-ExtLoop1: 1
Message-Id: <20091026222430.313656103@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 26 Oct 2009 14:24:30 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, ebiederm@xmission.com
Cc: garyhade@us.ibm.com, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org
Subject: [patch 0/6] x86: cleanups and fixes for irq migration code during cpu offline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First four patches in the series unify the fixup_irqs() along with
couple of cleanups. It also fixes an issue where the interrupt subsystem can 
point the interrupt to the offlined cpu (for non interrupt-remapping case)
causing the device to not work. This was observed by Gary.

These four patches are ready for inclusion and while there was a debate
in the past that fixup_irqs() is kind of broken (because of migrating
interrupts in the process context for non intr-remapping platforms)
we think that these patches enhance the existing code and not introduce any
more new races.

The last two patches in the series are titled as RFC. These patches
address removing the local_irq_enable()/local_irq_disable() in
the fixup_irqs(). All the patches (including these last two RFC patches) are
tested on Intel platforms (by myself) and on AMD platforms(by Gary).

We labeled the last two patches as RFC mainly because they need more testing and
thoughts from Eric and others who did some unsuccessful experiments in this
area (migrating irq in the process context for non intr-remapping platforms)
before.

thanks,
suresh

