Return-Path: <linux-kernel-owner+w=401wt.eu-S1759897AbYEAJ7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897AbYEAJ7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 05:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758668AbYEAJ7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 05:59:19 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:53806 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756931AbYEAJ7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 05:59:18 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de, hpa@zytor.com
Subject: [PATCH 1/2] x86_64: fix mm.txt documentation
Date: Thu,  1 May 2008 11:58:18 +0200
Message-Id: <1209635899-23018-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 85eb69a16aab5a394ce043c2131319eae35e6493 introduced 512 MiB
sized kernel and 1.5 GiB sized module space but omitted to change
documentation properly. Fix that.

[Wasn't the hole intentional protection hole?]

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: tglx@linutronix.de
Cc: mingo@redhat.com
Cc: hpa@zytor.com
---
 Documentation/x86_64/mm.txt |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/x86_64/mm.txt b/Documentation/x86_64/mm.txt
index b89b6d2..efce750 100644
--- a/Documentation/x86_64/mm.txt
+++ b/Documentation/x86_64/mm.txt
@@ -11,9 +11,8 @@ ffffc10000000000 - ffffc1ffffffffff (=40 bits) hole
 ffffc20000000000 - ffffe1ffffffffff (=45 bits) vmalloc/ioremap space
 ffffe20000000000 - ffffe2ffffffffff (=40 bits) virtual memory map (1TB)
 ... unused hole ...
-ffffffff80000000 - ffffffff82800000 (=40 MB)   kernel text mapping, from phys 0
-... unused hole ...
-ffffffff88000000 - fffffffffff00000 (=1919 MB) module mapping space
+ffffffff80000000 - ffffffffa0000000 (=512 MB)  kernel text mapping, from phys 0
+ffffffffa0000000 - fffffffffff00000 (=1536 MB) module mapping space
 
 The direct mapping covers all memory in the system up to the highest
 memory address (this means in some cases it can also include PCI memory
-- 
1.5.4.5

