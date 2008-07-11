Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbYGKNW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbYGKNW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbYGKNWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:22:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbYGKNWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:22:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix try_to_freeze_tasks()'s use of do_div()
To: rjw@sisk.pl, akpm@linux-foundation.org
Cc: dhowells@redhat.com, pavel@ucw.cz, linux-kernel@vger.kernel.org
Date: Fri, 11 Jul 2008 14:21:46 +0100
Message-ID: <20080711132146.31912.76254.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix try_to_freeze_tasks()'s use of do_div() on an s64 by making elapsed_csecs64
a u64 instead and dividing that.

Possibly this should be guarded lest the interval calculation turn up negative,
but the possible negativity of the result of the division is cast away anyway.

This was introduced by patch 438e2ce68dfd4af4cfcec2f873564fb921db4bb5.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/power/process.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/kernel/power/process.c b/kernel/power/process.c
index 5fb8765..278946a 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -149,7 +149,7 @@ static int try_to_freeze_tasks(bool sig_only)
 	unsigned long end_time;
 	unsigned int todo;
 	struct timeval start, end;
-	s64 elapsed_csecs64;
+	u64 elapsed_csecs64;
 	unsigned int elapsed_csecs;
 
 	do_gettimeofday(&start);

