Return-Path: <linux-kernel-owner+w=401wt.eu-S932434AbZHDGHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbZHDGHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 02:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932410AbZHDGHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 02:07:12 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:61549 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbZHDGHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 02:07:11 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>, Paul Mundt <lethal@linux-sh.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gelixner <tglx@linuxtronix.de>
Subject: [PATCH 1/2] ftrace: Fix the conditional that updates $ref_func
Date: Tue,  4 Aug 2009 07:06:40 +0100
Message-Id: <cd93d98e778a63832822ad6389c464b59fa8dbad.1249365713.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.6.4.rc0
In-Reply-To: <cover.1249365713.git.matt@console-pimps.org>
References: <cover.1249365713.git.matt@console-pimps.org>
In-Reply-To: <cover.1249365713.git.matt@console-pimps.org>
References: <cover.1249365713.git.matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the conditional that checks if we already have a $ref_func and that
the new function is weak. The code as previously checking whether either
condition was false, and we really need to only update $ref_func is both
cconditions are false.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
---
 scripts/recordmcount.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 7109e2b..16c5563 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -414,7 +414,7 @@ while (<IN>) {
 	    $read_function = 0;
 	} else {
 	    # if we already have a function, and this is weak, skip it
-	    if (!defined($ref_func) || !defined($weak{$text})) {
+	    if (!defined($ref_func) && !defined($weak{$text})) {
 		$ref_func = $text;
 	    }
 	}
-- 
1.6.4.rc0

