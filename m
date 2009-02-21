Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbZBUBSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbZBUBSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 20:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756267AbZBUBST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 20:18:19 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:59273 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744AbZBUBSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 20:18:18 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 1/2] KVM: fix sparse warnings: context imbalance
To: Avi Kivity <avi@redhat.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 21 Feb 2009 02:18:13 +0100
Message-ID: <20090221011806.7022.88651.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090221011723.7022.97639.stgit@vmbox.hanneseder.net>
References: <20090221011723.7022.97639.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Attribute function with __acquires(...) resp. __releases(...).

Fix this sparse warnings:
  arch/x86/kvm/i8259.c:34:13: warning: context imbalance in 'pic_lock' - wrong count at exit
  arch/x86/kvm/i8259.c:39:13: warning: context imbalance in 'pic_unlock' - unexpected unlock

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 arch/x86/kvm/i8259.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 9316037..a095415 100644
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

