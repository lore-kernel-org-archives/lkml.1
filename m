Return-Path: <linux-kernel-owner+w=401wt.eu-S1757260AbZDXGqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbZDXGqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 02:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbZDXGqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 02:46:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:53834 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbZDXGqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 02:46:37 -0400
Date: Fri, 24 Apr 2009 06:45:58 GMT
From: tip-bot for Len Brown <len.brown@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, tglx@linutronix.de, mingo@elte.hu,
       len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, tglx@linutronix.de, len.brown@intel.com,
       mingo@elte.hu
In-Reply-To: <alpine.LFD.2.00.0904231918510.15843@localhost.localdomain>
References: <alpine.LFD.2.00.0904231918510.15843@localhost.localdomain>
Subject: [tip:x86/urgent] x86, hpet: Stop soliciting hpet=force users on ICH4M
Message-ID: <tip-d2c8604121648b744ebb127991f1c5876931885e@git.kernel.org>
Git-Commit-ID: d2c8604121648b744ebb127991f1c5876931885e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 24 Apr 2009 06:46:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d2c8604121648b744ebb127991f1c5876931885e
Gitweb:     http://git.kernel.org/tip/d2c8604121648b744ebb127991f1c5876931885e
Author:     Len Brown <len.brown@intel.com>
AuthorDate: Thu, 23 Apr 2009 19:19:42 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 24 Apr 2009 08:41:39 +0200

x86, hpet: Stop soliciting hpet=force users on ICH4M

The HPET in the ICH4M is not documented in the data sheet
because it was not officially validated.

While it is fine for hackers to continue to use "hpet=force"
to enable the hardware that they have, it is not prudent to
solicit additional "hpet=force" users on this hardware.

[ Impact: remove hpet=force syslog message on old-ICH systems ]

Signed-off-by: Len Brown <len.brown@intel.com>
Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
LKML-Reference: <alpine.LFD.2.00.0904231918510.15843@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/quirks.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index e95022e..7563b31 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -261,8 +261,6 @@ static void old_ich_force_enable_hpet_user(struct pci_dev *dev)
 {
 	if (hpet_force_user)
 		old_ich_force_enable_hpet(dev);
-	else
-		hpet_print_force_info();
 }
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB_1,
