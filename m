Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbYIAXSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbYIAXSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYIAXQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:16:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:45045 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbYIAXP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:15:59 -0400
Date: Mon, 1 Sep 2008 16:09:45 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
Subject: [PATCH 7/13] hrtimer: convert kvm-ia64 to the new hrtimer apis
Message-ID: <20080901160945.55663aa9@infradead.org>
In-Reply-To: <20080901160343.75a89ec9@infradead.org>
References: <20080901160343.75a89ec9@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] hrtimer: convert kvm-ia64 to the new hrtimer apis

In order to be able to do range hrtimers we need to use accessor functions
to the "expire" member of the hrtimer struct.
This patch converts KVM-ia64 to these accessors.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/ia64/kvm/kvm-ia64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 7a37d06..cf8eae1 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1112,7 +1112,7 @@ static void kvm_migrate_hlt_timer(struct kvm_vcpu *vcpu)
 	struct hrtimer *p_ht = &vcpu->arch.hlt_timer;
 
 	if (hrtimer_cancel(p_ht))
-		hrtimer_start(p_ht, p_ht->expires, HRTIMER_MODE_ABS);
+		hrtimer_start_expires(p_ht, HRTIMER_MODE_ABS);
 }
 
 static enum hrtimer_restart hlt_timer_fn(struct hrtimer *data)
-- 
1.5.5.1

