Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbZLOIyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbZLOIyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 03:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759069AbZLOIxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 03:53:50 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:53661 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbZLOIxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 03:53:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=htEfPv7ZRhvpKgzSVzFN5AX+fIdRXV0D49CGIoFPTHxGfV5pHeWH1ICB6/fOboiEYU
         +snzOVtxkumeBZcpP3N9lkFmfX+EJ6SU2BmKsKS1jNmlRpvXDVMT+u5FMB5ylPOtpgLy
         K2i0Z8KrO1Ehb6aU4yiJnkssN3EScujppp2H8=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org
Subject: [PATCH 3/6] perf trace/scripting: check return val of perl_run()
Date: Tue, 15 Dec 2009 02:53:37 -0600
Message-Id: <1260867220-15699-4-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1260867220-15699-1-git-send-email-tzanussi@gmail.com>
References: <1260867220-15699-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value from perl_run() is currently ignored, but it should
be checked and used to exit perf if there are problems loading the
script.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/util/trace-event-perl.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/trace-event-perl.c b/tools/perf/util/trace-event-perl.c
index 6f10e76..6d6d76b 100644
--- a/tools/perf/util/trace-event-perl.c
+++ b/tools/perf/util/trace-event-perl.c
@@ -379,7 +379,11 @@ static int perl_start_script(const char *script, int argc, const char **argv)
 		goto error;
 	}
 
-	perl_run(my_perl);
+	if (perl_run(my_perl)) {
+		err = -1;
+		goto error;
+	}
+
 	if (SvTRUE(ERRSV)) {
 		err = -1;
 		goto error;
-- 
1.6.4.GIT

