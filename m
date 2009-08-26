Return-Path: <linux-kernel-owner+w=401wt.eu-S932655AbZHZKgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655AbZHZKgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932511AbZHZKdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:33:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757110AbZHZKaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:14 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 40/47] KVM: export kvm_para.h
Date: Wed, 26 Aug 2009 13:30:02 +0300
Message-Id: <1251282609-12835-41-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

kvm_para.h contains userspace interface and so
should be exported.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 include/asm-generic/Kbuild.asm |    5 +++++
 include/linux/Kbuild           |    4 ++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/Kbuild.asm b/include/asm-generic/Kbuild.asm
index 290910e..96d7c98 100644
--- a/include/asm-generic/Kbuild.asm
+++ b/include/asm-generic/Kbuild.asm
@@ -3,6 +3,11 @@ ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h \
 header-y  += kvm.h
 endif
 
+ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm_para.h \
+		  $(srctree)/include/asm-$(SRCARCH)/kvm_para.h),)
+header-y  += kvm_para.h
+endif
+
 ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h \
       		  $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
 unifdef-y += a.out.h
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 334a359..cff4a10 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -268,6 +268,10 @@ ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h \
       		  $(srctree)/include/asm-$(SRCARCH)/kvm.h),)
 unifdef-y += kvm.h
 endif
+ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm_para.h \
+		  $(srctree)/include/asm-$(SRCARCH)/kvm_para.h),)
+unifdef-y += kvm_para.h
+endif
 unifdef-y += llc.h
 unifdef-y += loop.h
 unifdef-y += lp.h
-- 
1.6.4.1

