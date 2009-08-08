Return-Path: <linux-kernel-owner+w=401wt.eu-S1752871AbZHHPtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbZHHPtk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 11:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZHHPtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 11:49:39 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:49561 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbZHHPti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 11:49:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=IFEgwD9lHaVpQrvpcWiC97psbsvjb5Nn5e0Wv07Ih00DixL9dKeYaEQObf5D0LlreK
         Kz5UUCTybieTag8N/wgB8/sydcbV2FIO1i2A+J6xw+8/Hviu5wfHsXiMsqaMrQPtb+KE
         icO7ZW/YojeV/YjJiYlOE8m9DxuLr8hb0Ft/o=
Subject: [tip PATCH] tracing/filters: don't use pred on alloc failure
From: Tom Zanussi <tzanussi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dan Carpenter <error27@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 08 Aug 2009 10:49:36 -0500
Message-Id: <1249746576.6453.30.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter sent me a fix to prevent pred from being used if it
couldn't be allocated.  This updates his patch for the same problem in
tip.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

The original report:

create_logical_pred() could sometimes return NULL.

It's a static checker complaining rather than problems at runtime...
---
 kernel/trace/trace_events_filter.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 27c2dbe..490337a 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1050,6 +1050,8 @@ static int replace_preds(struct event_subsystem *system,
 
 		pred = create_pred(elt->op, operand1, operand2);
 add_pred:
+		if (!pred)
+			return -ENOMEM;
 		if (call)
 			err = filter_add_pred(ps, call, pred, false);
 		else
-- 
1.5.6.3



