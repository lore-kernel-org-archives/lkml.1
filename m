Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330Ab0AGWIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab0AGWIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240Ab0AGWIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:08:07 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53778 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab0AGWIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 17:08:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=oIUGxHaAHsrK4LX4kkk1lYPNmqQcg3Z1Ub2CcqMv7PXf/7g4ZwuERN+pub50ycAnHl
         vteNQ8hfzihFLJd+ulq8LJhOXe95kZNcRssJbq8V1Qv0Qfxs49fU1jq3C5bqCh0v/aBL
         EkJ8jDC6HH6W1aUgWAEdB4zmmiVONcetp3yeQ=
Message-ID: <4B465C2D.8030303@gmail.com>
Date: Thu, 07 Jan 2010 23:11:57 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Xiantao Zhang <xiantao.zhang@intel.com>, kvm-ia64@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: dereference of NULL pointer in set_pal_result()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not dereference a NULL pointer

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/ia64/kvm/kvm_fw.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kvm/kvm_fw.c b/arch/ia64/kvm/kvm_fw.c
index e4b8231..d28494f 100644
--- a/arch/ia64/kvm/kvm_fw.c
+++ b/arch/ia64/kvm/kvm_fw.c
@@ -75,9 +75,11 @@ static void set_pal_result(struct kvm_vcpu *vcpu,
 	struct exit_ctl_data *p;
 
 	p = kvm_get_exit_data(vcpu);
-	if (p && p->exit_reason == EXIT_REASON_PAL_CALL) {
+	if (!p)
+		return;
+	if (p->exit_reason == EXIT_REASON_PAL_CALL) {
 		p->u.pal_data.ret = result;
-		return ;
+		return;
 	}
 	INIT_PAL_STATUS_UNIMPLEMENTED(p->u.pal_data.ret);
 }
