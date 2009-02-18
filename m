Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbZBRSf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbZBRSf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756614AbZBRSez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:34:55 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:27398 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606AbZBRSex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:34:53 -0500
Message-ID: <499C54E8.7060004@oracle.com>
Date: Wed, 18 Feb 2009 10:35:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH v2] module: fix build for CONFIG_SYSFS=n
References: <20090218191640.0b023029.sfr@canb.auug.org.au> <499C4D35.9000104@oracle.com> <20090218180932.GC19995@elte.hu>
In-Reply-To: <20090218180932.GC19995@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.499C54B7.00ED:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is destroy_params() dependent on SYSFS? If yes then it would be 

Yes.

> far cleaner if there was a NOP destroy_params() inline for the 
> !SYSFS case.




From: Randy Dunlap <randy.dunlap@oracle.com>

Fix this build error when CONFIG_SYSFS=n:

kernel/built-in.o: In function `free_module':
module.c:(.text+0x4f8a2): undefined reference to `destroy_params'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/params.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-next-20090218.orig/kernel/params.c
+++ linux-next-20090218/kernel/params.c
@@ -761,6 +761,12 @@ static int __init param_sysfs_init(void)
 }
 subsys_initcall(param_sysfs_init);
 
+#else	/* !CONFIG_SYSFS */
+
+inline void destroy_params(const struct kernel_param *params, unsigned num)
+{
+}
+
 #endif /* CONFIG_SYSFS */
 
 EXPORT_SYMBOL(param_set_byte);
