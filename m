Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbZCJVwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbZCJVwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 17:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbZCJVv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 17:51:56 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:33501 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbZCJVvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 17:51:55 -0400
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH] KVM: make 'lapic_timer_ops' and 'kpit_ops' static
Date: Tue, 10 Mar 2009 22:51:09 +0100
Message-ID: <20090310215053.11822.79188.stgit@f10box.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:
  arch/x86/kvm/lapic.c:916:22: warning: symbol 'lapic_timer_ops' was not declared. Should it be static?
  arch/x86/kvm/i8254.c:268:22: warning: symbol 'kpit_ops' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---

 arch/x86/kvm/i8254.c |    2 +-
 arch/x86/kvm/lapic.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 4e2e3f2..cf09bb6 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -265,7 +265,7 @@ static bool kpit_is_periodic(struct kvm_timer *ktimer)
 	return ps->is_periodic;
 }
 
-struct kvm_timer_ops kpit_ops = {
+static struct kvm_timer_ops kpit_ops = {
 	.is_periodic = kpit_is_periodic,
 };
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index dd934d2..4d76bb6 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -913,7 +913,7 @@ void kvm_apic_nmi_wd_deliver(struct kvm_vcpu *vcpu)
 		kvm_apic_local_deliver(apic, APIC_LVT0);
 }
 
-struct kvm_timer_ops lapic_timer_ops = {
+static struct kvm_timer_ops lapic_timer_ops = {
 	.is_periodic = lapic_is_periodic,
 };
 

