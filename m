Return-Path: <linux-kernel-owner+w=401wt.eu-S934556AbZKYHPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934556AbZKYHPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 02:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934293AbZKYHPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 02:15:07 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:36833 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbZKYHPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 02:15:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Qpv2wyF+Blp1gP6McYK7jmey2bIAAW6VWHkdTZYFOy3mTB9F61FRZdVMonFRajo23j
         RZVpFZo48FY3uZpUMm3mGfn5UnQnRs1NdIaQnnWRSQj34CCzGmDzNnHVBRyH3jbzF6hK
         5N9jDP2nbLZqeR1bFXuBzHI/vz7VSx4m1Flf8=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org
Subject: [PATCH 1/2] perf tools: Add 'signed' flag setting back into trace-event-parse.c
Date: Wed, 25 Nov 2009 01:14:58 -0600
Message-Id: <1259133299-23594-2-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1259133299-23594-1-git-send-email-tzanussi@gmail.com>
References: <1259133299-23594-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 13999e59343b042b0807be2df6ae5895d29782a0 (perf tools: Handle
the case with and without the "signed" trace field) removed code to
set the FIELD_IS_SIGNED flag that was originally added by commit
26a50744b21fff65bd754874072857bee8967f4d (tracing/events: Add 'signed'
field to format files).  This adds it back.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/util/trace-event-parse.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 180368b..0302405 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -946,7 +946,8 @@ static int event_read_fields(struct event *event, struct format_field **fields)
 			if (read_expect_type(EVENT_ITEM, &token))
 				goto fail;
 
-			/* add signed type */
+			if (strtoul(token, NULL, 0))
+				field->flags |= FIELD_IS_SIGNED;
 
 			free_token(token);
 			if (read_expected(EVENT_OP, ";") < 0)
-- 
1.6.4.GIT

