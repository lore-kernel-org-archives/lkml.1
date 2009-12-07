Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbZLGGXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbZLGGXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 01:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbZLGGXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 01:23:18 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:41775 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbZLGGWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 01:22:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vtKcgKWf4Q2JjcPfB2FGN2Fw/qppwow8bRlYOX1SsAol+eEoNIl+qC7tTsSAqT4Q3g
         WmHISLzAajggpCCsAxHoHOJDnps9LM3Z+dmLM56uJE9oyLjOoytrRDJgp2+mRrx0Pio+
         8iwrHKc3hEQOTW56oBWm6jByqBW1OE2/z6iNA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Walt <w41ter@gmail.com>,
       Prasad <prasad@linux.vnet.ibm.com>
Subject: [PATCH 1/2] hw-breakpoints: Zeroe the breakpoint attrs on initialization
Date: Mon,  7 Dec 2009 07:22:56 +0100
Message-Id: <1260166977-5894-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1260166977-5894-1-git-send-regression-fweisbec@gmail.com>
References: <1260166977-5894-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf attrs used to set up breakpoint parameters are often allocated
in the stack and not zeroed out before calling hw_breakpoint_init().
Handle it from this helper to avoid random attributes set by the stack.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
---
 include/linux/hw_breakpoint.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 4d14a38..42da1ce 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -22,6 +22,8 @@ enum {
 
 static inline void hw_breakpoint_init(struct perf_event_attr *attr)
 {
+	memset(attr, 0, sizeof(*attr));
+
 	attr->type = PERF_TYPE_BREAKPOINT;
 	attr->size = sizeof(*attr);
 	/*
-- 
1.6.2.3

