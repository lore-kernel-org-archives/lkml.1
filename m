Return-Path: <linux-kernel-owner+w=401wt.eu-S1762952AbZB1Bv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762952AbZB1Bv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757015AbZB1Bm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:42:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41782 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754AbZB1Bl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:58 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 29/30] KVM: fix sparse warnings: context imbalance
Date: Sat, 28 Feb 2009 03:41:48 +0200
Message-Id: <1235785309-12835-30-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>

Impact: Attribute function with __acquires(...) resp. __releases(...).

Fix this sparse warnings:
  arch/x86/kvm/i8259.c:34:13: warning: context imbalance in 'pic_lock' - wrong count at exit
  arch/x86/kvm/i8259.c:39:13: warning: context imbalance in 'pic_unlock' - unexpected unlock

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8259.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index b4e662e..1ccb50c 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -32,11 +32,13 @@
 #include <linux/kvm_host.h>
 
 static void pic_lock(struct kvm_pic *s)
+	__acquires(&s->lock)
 {
 	spin_lock(&s->lock);
 }
 
 static void pic_unlock(struct kvm_pic *s)
+	__releases(&s->lock)
 {
 	struct kvm *kvm = s->kvm;
 	unsigned acks = s->pending_acks;
-- 
1.6.0.6

