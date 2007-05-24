Return-Path: <linux-kernel-owner+w=401wt.eu-S1759238AbXEXMKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbXEXMKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 08:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbXEXMKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 08:10:20 -0400
Received: from il.qumranet.com ([82.166.9.18]:36437 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756039AbXEXMKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 08:10:18 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, shaohua.li@intel.com,
       lhcs-devel@lists.sourceforge.net
Subject: [PATCH 0/7] KVM: Suspend and cpu hotplug fixes
Date: Thu, 24 May 2007 15:10:08 +0300
Message-Id: <1180008615579-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset makes kvm more robust wrt cpu hotunplug, and
makes suspend-to-ram actually work.  Suspend-to-disk benefits from
the cpu hotunplug improvements as well.

The major issue is that KVM wants to disable the virtualization
extensions at a point in time when no user processes are schedulable
on the victim cpu.  No current notifier exists, so a new one, CPU_DYING,
is added for the purpose.

Should there be no objections, I will submit this patchset for inclusion
in 2.6.22, and backport it to 2.6.21.stable.
