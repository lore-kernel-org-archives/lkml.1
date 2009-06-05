Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbZFERbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbZFERbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 13:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbZFERbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 13:31:04 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:53363 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbZFERbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 13:31:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZUfJk0RPyxRGncMVOWd161YEZ9u+pgA/Wz998eaWnQjjyIS1uhzebOkEIyAbeegVJ/
         jKpaOjYTjtjVaVHT0okm+AHBG29PzKj9aMM4voRgDwCFLNFQGh3UtC3edCYJ7Kv9H0zi
         O+SgFsWnEXp4oYu1A9HbEkH7qrDhTx4pYlfdc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perfcounter: fix zero or negative refresh delay
Date: Fri,  5 Jun 2009 19:31:01 +0200
Message-Id: <1244223061-5399-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If perf top is executed with a zero value for the refresh rate,
we get a division by zero exception while computing samples_per_sec.

Also a zero refresh rate is not possible, neither do we want to
accept negative values.

[ Impact: fix division by zero in perf top ]

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 Documentation/perf_counter/builtin-top.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index ff7e13c..b2f480b 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -693,6 +693,9 @@ int cmd_top(int argc, const char **argv, const char *prefix)
 		event_id[0] = 0;
 	}
 
+	if (delay_secs < 1)
+		delay_secs = 1;
+
 	for (counter = 0; counter < nr_counters; counter++) {
 		if (event_count[counter])
 			continue;
-- 
1.6.2.3

