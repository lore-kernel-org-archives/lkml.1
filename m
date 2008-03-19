Return-Path: <linux-kernel-owner+w=401wt.eu-S1762237AbYCSUBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762237AbYCSUBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757009AbYCSTiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757AbYCSTh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:37:59 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 45/79] [PATCH] fix apic acking of irqs
Date: Wed, 19 Mar 2008 14:25:40 -0300
Message-Id: <12059477792893-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059477751776-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

EOI is a write-only register. Using write around will have the effect
of reading it, which will make all subsequent reads of the ESR register
to return an error code. It was unnotices for quite a while because main sources
of reading the ESR register where done prior to apic interrupt enabling.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/apic.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/apic.h b/include/asm-x86/apic.h
index db5f750..0d6ea74 100644
--- a/include/asm-x86/apic.h
+++ b/include/asm-x86/apic.h
@@ -103,7 +103,7 @@ static inline void ack_APIC_irq(void)
 	 */
 
 	/* Docs say use 0 for future compatibility */
-	apic_write_around(APIC_EOI, 0);
+	apic_write(APIC_EOI, 0);
 }
 
 extern int lapic_get_maxlvt(void);
-- 
1.5.0.6

