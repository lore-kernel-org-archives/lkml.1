Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbYEPJcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbYEPJcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 05:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYEPJch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 05:32:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbYEPJcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 05:32:36 -0400
Subject: thinkpad_acpi: fix possible NULL pointer dereference if kstrdup
	for ec_version_str failed
From: Jan Lieskovsky <jlieskov@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-RVrRYBaWwoWRvagmkCgV"
Organization: Red Hat Inc.
Date: Fri, 16 May 2008 11:34:09 +0200
Message-Id: <1210930449.3812.15.camel@dhcp-lab-164.englab.brq.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RVrRYBaWwoWRvagmkCgV
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello guys,

  apologize for bothering you if wrong, but based on patch from Cyrill:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=90fe17f4df2f830601ffd422b11d1f7f9a9d0355

There is a potential NULL pointer dereference in thinkpad_acpi_module_exit() -- in case,
kstrdup for thinkpad_id.ec_version_str failed.

Kind regards
Jan Lieskovsky

--=-RVrRYBaWwoWRvagmkCgV
Content-Disposition: attachment; filename=kstrdup_ec_version_str.patch
Content-Type: text/x-patch; name=kstrdup_ec_version_str.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- linux-2.6.25.3.old/drivers/misc/thinkpad_acpi.c	2008-05-12 11:43:16.000000000 +0200
+++ linux-2.6.25.3/drivers/misc/thinkpad_acpi.c	2008-05-16 11:20:48.000000000 +0200
@@ -6072,7 +6072,8 @@
 		remove_proc_entry(TPACPI_PROC_DIR, acpi_root_dir);
 
 	kfree(thinkpad_id.bios_version_str);
-	kfree(thinkpad_id.ec_version_str);
+	if (thinkpad_id.ec_version_str)	
+	      	kfree(thinkpad_id.ec_version_str);
 	kfree(thinkpad_id.model_str);
 }
 

--=-RVrRYBaWwoWRvagmkCgV--

