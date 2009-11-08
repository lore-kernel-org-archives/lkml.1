Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbZKHQKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbZKHQKf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 11:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbZKHQKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 11:10:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:33615 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290AbZKHQK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 11:10:28 -0500
Date: Sun, 8 Nov 2009 16:09:58 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, gorcunov@openvz.org, macro@linux-mips.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, yinghai@kernel.org, macro@linux-mips.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091108155356.GB25940@lenovo>
References: <20091108155356.GB25940@lenovo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic: Use PAGE_SIZE instead of numbers
Message-ID: <tip-46dc281b1bb02527195fe2ad50a3af6d7f7f7325@git.kernel.org>
Git-Commit-ID: 46dc281b1bb02527195fe2ad50a3af6d7f7f7325
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46dc281b1bb02527195fe2ad50a3af6d7f7f7325
Gitweb:     http://git.kernel.org/tip/46dc281b1bb02527195fe2ad50a3af6d7f7f7325
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Sun, 8 Nov 2009 18:53:56 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 17:06:22 +0100

x86, apic: Use PAGE_SIZE instead of numbers

The whole page is reserved for IO-APIC fixmap
due to non-cacheable requirement. So lets note
this explicitly instead of playing with numbers.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Maciej W. Rozycki <macro@linux-mips.org>
LKML-Reference: <20091108155356.GB25940@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/io_apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 31e9db3..9ee1c16 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4111,7 +4111,7 @@ fake_ioapic_page:
 		idx++;
 
 		ioapic_res->start = ioapic_phys;
-		ioapic_res->end = ioapic_phys + (4 * 1024) - 1;
+		ioapic_res->end = ioapic_phys + PAGE_SIZE-1;
 		ioapic_res++;
 	}
 }
