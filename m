Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbZHYOAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbZHYOAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 10:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbZHYOAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 10:00:14 -0400
Received: from smtp.zeugmasystems.com ([70.79.96.174]:13684 "EHLO
	zeugmasystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753860AbZHYOAM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 10:00:12 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] : eliminate code duplication in kernel/tracepoint.c
Date: Tue, 25 Aug 2009 07:00:02 -0700
Message-ID: <DDFD17CC94A9BD49A82147DDF7D545C501EA9047@exchange.ZeugmaSystems.local>
In-Reply-To: <20090825063901.GB14286@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] : eliminate code duplication in kernel/tracepoint.c
Thread-Index: AcolTtulvUsewwyOQPaaS3ZXnBir0AAPJ/uA
References: <DDFD17CC94A9BD49A82147DDF7D545C501EA8FBB@exchange.ZeugmaSystems.local> <4A933C55.4090808@cn.fujitsu.com> <DDFD17CC94A9BD49A82147DDF7D545C501EA902E@exchange.ZeugmaSystems.local> <4A93760C.4020107@cn.fujitsu.com> <20090825063901.GB14286@elte.hu>
From: "Anirban Sinha" <ASinha@zeugmasystems.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Li Zefan" <lizf@cn.fujitsu.com>
Cc: <linux-kernel@vger.kernel.org>, "Oleg Nesterov" <oleg@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> I still think it's better not to remove this break. every "case"
>> should have a break or a return, expect for the falling throught
>> cases.
>
>Correct. That might seem like a superfluous statement, but when we
>add new cases it stays robust while with the missing break one can
>create an unintended fall-through codepath.
>
>	Ingo

Thanks a lot Li and Ingo for all the feedback. Final patch goes below:

>From f9826874841a5b15b553cfb6540d1ecfa6b55531 Mon Sep 17 00:00:00 2001
From: Anirban Sinha <asinha@zeugmasystems.com>
Date: Tue, 25 Aug 2009 06:50:54 -0700
Subject: cleanup: eliminate code duplication in kernel/tracepoint.c


Signed-off-by: Anirban Sinha <asinha@zeugmasystems.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/tracepoint.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 1ef5d3a..4840ab6 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -554,9 +554,6 @@ int tracepoint_module_notify(struct notifier_block
*self,
 
 	switch (val) {
 	case MODULE_STATE_COMING:
-		tracepoint_update_probe_range(mod->tracepoints,
-			mod->tracepoints + mod->num_tracepoints);
-		break;
 	case MODULE_STATE_GOING:
 		tracepoint_update_probe_range(mod->tracepoints,
 			mod->tracepoints + mod->num_tracepoints);
-- 
1.6.4

