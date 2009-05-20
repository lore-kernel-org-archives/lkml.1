Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbZETEad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbZETEad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 00:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbZETEaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 00:30:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:37765 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZETEaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 00:30:25 -0400
Subject: [PATCH -tip] x86: kvm/paging_tmpl.h intialize the variable before
 using it
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 May 2009 09:59:35 +0530
Message-Id: <1242793775.3260.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


May be in some cases paging64_fetch() and paging32_fetch() will return sptep
without initialization.

Also fixes compilation warning:
  CC      arch/x86/kernel/io_delay.o
 arch/x86/kvm/paging_tmpl.h: In function ‘paging64_fetch’:
 arch/x86/kvm/paging_tmpl.h:279: warning: ‘sptep’ may be used uninitialized in this function
 arch/x86/kvm/paging_tmpl.h: In function ‘paging32_fetch’:
 arch/x86/kvm/paging_tmpl.h:279: warning: ‘sptep’ may be used uninitialized in this function

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kvm/paging_tmpl.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 6bd7020..99cb10d 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -276,7 +276,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 {
 	unsigned access = gw->pt_access;
 	struct kvm_mmu_page *shadow_page;
-	u64 spte, *sptep;
+	u64 spte, *sptep = NULL;
 	int direct;
 	gfn_t table_gfn;
 	int r;
-- 
1.6.1.1



