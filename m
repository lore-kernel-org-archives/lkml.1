Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbZHXXQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbZHXXQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 19:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbZHXXQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 19:16:33 -0400
Received: from smtp.zeugmasystems.com ([70.79.96.174]:7152 "EHLO
	zeugmasystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753778AbZHXXQc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 19:16:32 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] : eliminate code duplication in kernel/tracepoint.c
Date: Mon, 24 Aug 2009 16:16:31 -0700
Message-ID: <DDFD17CC94A9BD49A82147DDF7D545C501EA8FBB@exchange.ZeugmaSystems.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] : eliminate code duplication in kernel/tracepoint.c
Thread-Index: AcolEOpJrVwNzLCfSrC5JrmonBjhyA==
From: "Anirban Sinha" <ASinha@zeugmasystems.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>, "Oleg Nesterov" <oleg@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo:

I was going through the kernel tracepoints work. It's really impressive.
Congratulations! 

The following cleanup popped up immediately. May be you guys have
noticed it already.

Cheers,

Ani


>From 2068b87b9635a66e5e86b8ff4182d96a6e969584 Mon Sep 17 00:00:00 2001
From: Anirban Sinha <asinha@zeugmasystems.com>
Date: Mon, 24 Aug 2009 15:52:20 -0700
Subject: Cleanup: eliminate code duplication in kernel/tracepoint.c


Signed-off-by: Anirban Sinha <asinha@zeugmasystems.com>
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
-               tracepoint_update_probe_range(mod->tracepoints,
-                       mod->tracepoints + mod->num_tracepoints);
-               break;
        case MODULE_STATE_GOING:
                tracepoint_update_probe_range(mod->tracepoints,
                        mod->tracepoints + mod->num_tracepoints);
--
1.6.4


>From 5e09b156be90b936db9c1977abcc04b5cbb4bd4a Mon Sep 17 00:00:00 2001
From: Anirban Sinha <asinha@zeugmasystems.com>
Date: Mon, 24 Aug 2009 15:55:12 -0700
Subject: cleanup: remove redundant break statement.


Signed-off-by: Anirban Sinha <asinha@zeugmasystems.com>
---
 kernel/tracepoint.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 4840ab6..35eed9c 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -557,7 +557,6 @@ int tracepoint_module_notify(struct notifier_block
*self,
        case MODULE_STATE_GOING:
                tracepoint_update_probe_range(mod->tracepoints,
                        mod->tracepoints + mod->num_tracepoints);
-               break;
        }
        return 0;
 }
--
1.6.4
