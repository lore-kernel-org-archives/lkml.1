Return-Path: <linux-kernel-owner+w=401wt.eu-S1757318AbZD1T26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbZD1T26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 15:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbZD1T16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 15:27:58 -0400
Received: from relay.ptn-ipout01.plus.net ([212.159.7.35]:59195 "EHLO
	relay.ptn-ipout01.plus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753531AbZD1T14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 15:27:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAM/y9knUnw4R/2dsb2JhbAC/MpAgg3MF
From: Stuart Bennett <stuart@freedesktop.org>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       Stuart Bennett <stuart@freedesktop.org>
Subject: [PATCH] x86 mmiotrace: fix range test
Date: Tue, 28 Apr 2009 20:17:48 +0100
Message-Id: <1240946271-7083-2-git-send-email-stuart@freedesktop.org>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <1240946271-7083-1-git-send-email-stuart@freedesktop.org>
References: <1240946271-7083-1-git-send-email-stuart@freedesktop.org>
X-Plusnet-Relay: 10c3fb6c353b9f59cc2c623fcf952a41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matching on (addr == (p->addr + p->len)) causes problems when mappings
are adjacent

Signed-off-by: Stuart Bennett <stuart@freedesktop.org>
Acked-by: Pekka Paalanen <pq@iki.fi>
---
 arch/x86/mm/kmmio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 4f115e0..50dc802 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -87,7 +87,7 @@ static struct kmmio_probe *get_kmmio_probe(unsigned long addr)
 {
 	struct kmmio_probe *p;
 	list_for_each_entry_rcu(p, &kmmio_probes, list) {
-		if (addr >= p->addr && addr <= (p->addr + p->len))
+		if (addr >= p->addr && addr < (p->addr + p->len))
 			return p;
 	}
 	return NULL;
-- 
1.5.4.4

