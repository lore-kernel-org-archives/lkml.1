Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab0BJTmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 14:42:45 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:39855 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab0BJTmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 14:42:43 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@redhat.com
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Aristeu Sergio <arozansk@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       x86@kernel.org
Subject: [PATCH 1/1] X86: pci, fix section mismatch
Date: Wed, 10 Feb 2010 20:42:37 +0100
Message-Id: <1265830957-6966-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcibios_scan_specific_bus calls pci_scan_bus_on_node which is
__devinit. Mark pcibios_scan_specific_bus __devinit as well since
all users are now __init or __devinit.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Aristeu Sergio <arozansk@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org
Cc: x86@kernel.org
---
 arch/x86/pci/legacy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index a8194c8..8cf7835 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -39,7 +39,7 @@ static int __init pci_legacy_init(void)
 	return 0;
 }
 
-void pcibios_scan_specific_bus(int busn)
+void __devinit pcibios_scan_specific_bus(int busn)
 {
 	int devfn;
 	long node;
-- 
1.6.6.1

