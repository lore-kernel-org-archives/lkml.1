Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332Ab0ANRBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab0ANRBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 12:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756962Ab0ANRBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 12:01:52 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:42661 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851Ab0ANRBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 12:01:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=u3NenAfKaqzQymNRNnDHq/cDnYpkYTALN46D7qEvP5V3JZ/sTUGtPSG4//z++YLhka
         3Q3TJqib0nao/zUzkhlQ3hjGetulcoKeYRtZwZGwgKw9TBKYea6T7tID+jXyt8nNQ5Ke
         ZUL21zSQWPLjp5kJUOoAb6jJrL1wbyJqYyujY=
Message-ID: <4B4F4EF6.2050202@gmail.com>
Date: Thu, 14 Jan 2010 18:05:58 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Xiantao Zhang <xiantao.zhang@intel.com>, kvm-ia64@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
CC: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH] KVM: remove redundant NULL tests
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm_get_exit_data() cannot return a NULL pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/ia64/kvm/kvm_fw.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/arch/ia64/kvm/kvm_fw.c b/arch/ia64/kvm/kvm_fw.c
index e4b8231..cb548ee 100644
--- a/arch/ia64/kvm/kvm_fw.c
+++ b/arch/ia64/kvm/kvm_fw.c
@@ -75,7 +75,7 @@ static void set_pal_result(struct kvm_vcpu *vcpu,
 	struct exit_ctl_data *p;
 
 	p = kvm_get_exit_data(vcpu);
-	if (p && p->exit_reason == EXIT_REASON_PAL_CALL) {
+	if (p->exit_reason == EXIT_REASON_PAL_CALL) {
 		p->u.pal_data.ret = result;
 		return ;
 	}
@@ -87,7 +87,7 @@ static void set_sal_result(struct kvm_vcpu *vcpu,
 	struct exit_ctl_data *p;
 
 	p = kvm_get_exit_data(vcpu);
-	if (p && p->exit_reason == EXIT_REASON_SAL_CALL) {
+	if (p->exit_reason == EXIT_REASON_SAL_CALL) {
 		p->u.sal_data.ret = result;
 		return ;
 	}
@@ -322,7 +322,7 @@ static  u64 kvm_get_pal_call_index(struct kvm_vcpu *vcpu)
 	struct exit_ctl_data *p;
 
 	p = kvm_get_exit_data(vcpu);
-	if (p && (p->exit_reason == EXIT_REASON_PAL_CALL))
+	if (p->exit_reason == EXIT_REASON_PAL_CALL)
 		index = p->u.pal_data.gr28;
 
 	return index;
@@ -646,18 +646,16 @@ static void kvm_get_sal_call_data(struct kvm_vcpu *vcpu, u64 *in0, u64 *in1,
 
 	p = kvm_get_exit_data(vcpu);
 
-	if (p) {
-		if (p->exit_reason == EXIT_REASON_SAL_CALL) {
-			*in0 = p->u.sal_data.in0;
-			*in1 = p->u.sal_data.in1;
-			*in2 = p->u.sal_data.in2;
-			*in3 = p->u.sal_data.in3;
-			*in4 = p->u.sal_data.in4;
-			*in5 = p->u.sal_data.in5;
-			*in6 = p->u.sal_data.in6;
-			*in7 = p->u.sal_data.in7;
-			return ;
-		}
+	if (p->exit_reason == EXIT_REASON_SAL_CALL) {
+		*in0 = p->u.sal_data.in0;
+		*in1 = p->u.sal_data.in1;
+		*in2 = p->u.sal_data.in2;
+		*in3 = p->u.sal_data.in3;
+		*in4 = p->u.sal_data.in4;
+		*in5 = p->u.sal_data.in5;
+		*in6 = p->u.sal_data.in6;
+		*in7 = p->u.sal_data.in7;
+		return ;
 	}
 	*in0 = 0;
 }
