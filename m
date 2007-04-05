Return-Path: <linux-kernel-owner+w=401wt.eu-S964784AbXDEDwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784AbXDEDwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 23:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964828AbXDEDwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 23:52:17 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:12169 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784AbXDEDwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 23:52:16 -0400
X-IronPort-AV: i="4.14,373,1170651600"; 
   d="scan'208"; a="33798568:sNHT23833313"
Subject: [PATCH] blackfin arch: use boot_command_line instead of
	saved_command_line in setup c file
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1175743271.17315.10.camel@roc-desktop>
References: <1175668103.10608.39.camel@roc-desktop>
	 <20070404080752.4c2375b2.randy.dunlap@oracle.com>
	 <1175743271.17315.10.camel@roc-desktop>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 05 Apr 2007 11:53:58 +0800
Message-Id: <1175745238.17315.18.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] blackfin arch
As boot_command_line is added in init/main.c for arch-specific boot
command line, replace old saved_command_line to boot_command_line for
right boot command passing in -mm tree.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/setup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index ce51882..7d24229 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -221,8 +221,8 @@ void __init setup_arch(char **cmdline_p)
 
 	/* Keep a copy of command line */
 	*cmdline_p = &command_line[0];
-	memcpy(saved_command_line, command_line, COMMAND_LINE_SIZE);
-	saved_command_line[COMMAND_LINE_SIZE - 1] = 0;
+	memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
+	boot_command_line[COMMAND_LINE_SIZE - 1] = 0;
 
 	/* setup memory defaults from the user config */
 	physical_mem_end = 0;
-- 
1.5.0.5

