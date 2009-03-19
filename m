Return-Path: <linux-kernel-owner+w=401wt.eu-S1757127AbZCSN2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbZCSN2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 09:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756466AbZCSN2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 09:28:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:40195 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756550AbZCSN2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:28:18 -0400
Date: Thu, 19 Mar 2009 13:27:28 GMT
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, xen-devel@lists.xensource.com,
       jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jeremy.fitzhardinge@citrix.com,
       xen-devel@lists.xensource.com, mingo@elte.hu
In-Reply-To: <1237406613-2929-1-git-send-email-jeremy@goop.org>
References: <1237406613-2929-1-git-send-email-jeremy@goop.org>
Subject: [tip:x86/mm] x86/32: no need to use set_pte_present in set_pte_vaddr
Message-ID: <tip-b40c757964bbad76ecfa88eda9eb0b4d76dd8b40@git.kernel.org>
Git-Commit-ID: b40c757964bbad76ecfa88eda9eb0b4d76dd8b40
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 19 Mar 2009 13:27:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b40c757964bbad76ecfa88eda9eb0b4d76dd8b40
Gitweb:     http://git.kernel.org/tip/b40c757964bbad76ecfa88eda9eb0b4d76dd8b40
Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
AuthorDate: Wed, 18 Mar 2009 13:03:32 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 19 Mar 2009 14:04:18 +0100

x86/32: no need to use set_pte_present in set_pte_vaddr

Impact: cleanup, remove last user of set_pte_present

set_pte_vaddr() is only used to install ptes in fixmaps, and
should never be used to overwrite a present mapping.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Xen-devel <xen-devel@lists.xensource.com>
LKML-Reference: <1237406613-2929-1-git-send-email-jeremy@goop.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/pgtable_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
index f2e477c..46c8834 100644
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -50,7 +50,7 @@ void set_pte_vaddr(unsigned long vaddr, pte_t pteval)
 	}
 	pte = pte_offset_kernel(pmd, vaddr);
 	if (pte_val(pteval))
-		set_pte_present(&init_mm, vaddr, pte, pteval);
+		set_pte_at(&init_mm, vaddr, pte, pteval);
 	else
 		pte_clear(&init_mm, vaddr, pte);
 
