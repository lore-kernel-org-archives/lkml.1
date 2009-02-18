Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbZBRSCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbZBRSCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZBRSCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:02:00 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:26099 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbZBRSB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:01:59 -0500
Message-ID: <499C4D35.9000104@oracle.com>
Date: Wed, 18 Feb 2009 10:02:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] module: fix build for CONFIG_SYSFS=n
References: <20090218191640.0b023029.sfr@canb.auug.org.au>
In-Reply-To: <20090218191640.0b023029.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.499C4D07.00F2:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix this build error when CONFIG_SYSFS=n:

kernel/built-in.o: In function `free_module':
module.c:(.text+0x4f8a2): undefined reference to `destroy_params'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20090218.orig/kernel/module.c
+++ linux-next-20090218/kernel/module.c
@@ -1464,8 +1464,10 @@ static void free_module(struct module *m
 	/* Module unload stuff */
 	module_unload_free(mod);
 
+#ifdef CONFIG_SYSFS
 	/* Free any allocated parameters. */
 	destroy_params(mod->kp, mod->num_kp);
+#endif
 
 	/* release any pointers to mcount in this module */
 	ftrace_release(mod->module_core, mod->core_size);
