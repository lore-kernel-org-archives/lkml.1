Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab0CCHEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 02:04:43 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49020 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab0CCHEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 02:04:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lt6xQrjEgMYk5pc6FsQ5g/G0wsyrGicxCtTX5cgr4NIIW5M5QzP2dlzqp5trk/ttMI
         42xrp2mrC9cEeMFtmCaKHX7PYPn0P9KbdFYJd2gJ+VfcRC5uy6iqRwcGvCjusNOw4uDX
         FghFUah93+V3VnNaoryeaXKRGjLWBI7opowqs=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org
Subject: [PATCH 1/2] perf trace/scripting: remove extraneous header read
Date: Wed,  3 Mar 2010 01:04:32 -0600
Message-Id: <1267599873-8193-2-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1267599873-8193-1-git-send-email-tzanussi@gmail.com>
References: <1267599873-8193-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_header__read() is already done in perf_session__open(), so remove
it from the script gen case.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-trace.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 5db687f..b8153db 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -608,7 +608,6 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 			return -1;
 		}
 
-		perf_header__read(&session->header, input);
 		err = scripting_ops->generate_script("perf-trace");
 		goto out;
 	}
-- 
1.6.4.GIT

