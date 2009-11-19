Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbZKSNim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbZKSNim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbZKSNgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:36:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbZKSNfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:09 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 26/35] KVM: MMU: update invlpg handler comment
Date: Thu, 19 Nov 2009 15:35:02 +0200
Message-Id: <1258637711-11674-27-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Large page translations are always synchronized (either in level 3
or level 2), so its not necessary to properly deal with them
in the invlpg handler.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/paging_tmpl.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 72558f8..a601713 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -467,7 +467,6 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 		level = iterator.level;
 		sptep = iterator.sptep;
 
-		/* FIXME: properly handle invlpg on large guest pages */
 		if (level == PT_PAGE_TABLE_LEVEL  ||
 		    ((level == PT_DIRECTORY_LEVEL && is_large_pte(*sptep))) ||
 		    ((level == PT_PDPE_LEVEL && is_large_pte(*sptep)))) {
-- 
1.6.5.2

