Return-Path: <linux-kernel-owner+w=401wt.eu-S1761358AbYACA5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761358AbYACA5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761059AbYACA4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:56:54 -0500
Received: from mga06.intel.com ([134.134.136.21]:22587 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761274AbYACA4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:56:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,237,1196668800"; 
   d="scan'208";a="248250535"
Message-ID: <477C3252.1080001@linux.intel.com>
Date: Thu, 03 Jan 2008 01:54:42 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: apw@uk.ibm.com
CC: linux-kernel@vger.kernel.org
Subject: Make checkpatch.pl's quiet option not print the summary on no errors
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Make checkpatch.pl's quiet option not print the summary on no errors
From: Arjan van de Ven <arjan@linux.intel.com>
CC: apw@uk.ibm.com

Right now, in quiet mode, checkpatch.pl still prints a summary line even
if the patch is 100% clean. IMO, "quiet mode" should mean "no output if clean",
the patch below makes that so. (This also makes the quilt integration
on my system work nicer :)

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
  scripts/checkpatch.pl |    2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.24-rc6/scripts/checkpatch.pl
===================================================================
--- linux-2.6.24-rc6.orig/scripts/checkpatch.pl
+++ linux-2.6.24-rc6/scripts/checkpatch.pl
@@ -1579,7 +1579,7 @@ sub process {
  	}

  	print report_dump();
-	if ($summary) {
+	if ($summary && ($clean == 0 || $quiet == 0)) {
  		print "total: $cnt_error errors, $cnt_warn warnings, " .
  			(($check)? "$cnt_chk checks, " : "") .
  			"$cnt_lines lines checked\n";
