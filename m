Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbZCJS6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbZCJS6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 14:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbZCJS5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 14:57:55 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:51371 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZCJS5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 14:57:54 -0400
Message-ID: <49B6B898.6010902@oracle.com>
Date: Tue, 10 Mar 2009 11:59:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: [PATCH -next] staging/p9auth: fix dependency/build error
References: <20090310195534.8f8f3c7a.sfr@canb.auug.org.au>
In-Reply-To: <20090310195534.8f8f3c7a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.49B6B827.0180:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix p9auth dependency/build failure.  It needs to depend on
CRYPTO.

p9auth.c:(.text+0x107297): undefined reference to `crypto_alloc_base'
p9auth.c:(.text+0x1073d4): undefined reference to `crypto_destroy_tfm'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/p9auth/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20090310.orig/drivers/staging/p9auth/Kconfig
+++ linux-next-20090310/drivers/staging/p9auth/Kconfig
@@ -1,6 +1,7 @@
 config PLAN9AUTH
 	tristate "Plan 9 style capability device implementation"
 	default n
+	depends on CRYPTO
 	help
 	  This module implements the Plan 9 style capability device.
 
