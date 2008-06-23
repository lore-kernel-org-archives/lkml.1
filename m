Return-Path: <linux-kernel-owner+w=401wt.eu-S1761227AbYFWRn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761227AbYFWRn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 13:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbYFWRnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 13:43:50 -0400
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:53343 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYFWRnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 13:43:49 -0400
Date: Mon, 23 Jun 2008 12:43:33 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com
Subject: [patch] hackbench: flush buffers before fork
Message-ID: <20080623174333.GF9594@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Pobox-Relay-ID: EED2DD5E-414B-11DD-B615-3113EBD4C077-04752483!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a fixlet for the hackbench program found at

http://people.redhat.com/mingo/cfs-scheduler/tools/hackbench.c

When redirecting hackbench output I am seeing multiple copies of the
"Running with %d*40 (== %d) tasks" line.  Need to flush the buffered
output before forking.


diff --git a/hackbench.c b/hackbench.c
index 7b90840..e830461 100644
--- a/hackbench.c
+++ b/hackbench.c
@@ -321,6 +321,8 @@ int main(int argc, char *argv[])
 	printf("Running with %d*40 (== %d) tasks.\n",
 		num_groups, num_groups*40);
 
+	fflush(NULL);
+
 	if (argc > 2) {
 		if ( !strcmp(argv[2], "process") )
 			process_mode = 1;
-- 
1.5.4.rc5.5.gab98

