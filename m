Return-Path: <linux-kernel-owner+w=401wt.eu-S1751722AbZJAEe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbZJAEe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 00:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbZJAEez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 00:34:55 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:64235 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbZJAEez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 00:34:55 -0400
Message-ID: <4AC43118.6050409@ct.jp.nec.com>
Date: Thu, 01 Oct 2009 13:33:28 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Steven Rostedt <srostedt@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] trace: fix missing assignment in trace_ctxwake_*
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

The state char variable S should be reassigned, if S == 0.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 kernel/trace/trace_output.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index f572f44..cda766f 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -883,7 +883,7 @@ static int trace_ctxwake_raw(struct trace_iterator *iter, char S)
 	trace_assign_type(field, iter->ent);
 
 	if (!S)
-		task_state_char(field->prev_state);
+		S = task_state_char(field->prev_state);
 	T = task_state_char(field->next_state);
 	if (!trace_seq_printf(&iter->seq, "%d %d %c %d %d %d %c\n",
 			      field->prev_pid,
@@ -918,7 +918,7 @@ static int trace_ctxwake_hex(struct trace_iterator *iter, char S)
 	trace_assign_type(field, iter->ent);
 
 	if (!S)
-		task_state_char(field->prev_state);
+		S = task_state_char(field->prev_state);
 	T = task_state_char(field->next_state);
 
 	SEQ_PUT_HEX_FIELD_RET(s, field->prev_pid);
-- 
1.6.3.3

