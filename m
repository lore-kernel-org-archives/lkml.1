Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbZBRTNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbZBRTNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbZBRTMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:12:55 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:43955 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbZBRTMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:12:54 -0500
Message-ID: <499C5DB6.5010908@oracle.com>
Date: Wed, 18 Feb 2009 11:12:54 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       Andres Salomon <dilinger@debian.org>
Subject: [PATCH -mmotm] asiliantfb: fix ISO declaration/code warning
References: <200902181018.n1IAISW7012483@imap1.linux-foundation.org>
In-Reply-To: <200902181018.n1IAISW7012483@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010206.499C5D85.0213:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Move data declaration before any code:

drivers/video/asiliantfb.c:515: warning: ISO C90 forbids mixed declarations and code

(from asiliantfb-fix-cmap-memory-leaks.patch)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/video/asiliantfb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- mmotm-2009-0218-0215.orig/drivers/video/asiliantfb.c
+++ mmotm-2009-0218-0215/drivers/video/asiliantfb.c
@@ -507,12 +507,13 @@ static struct fb_var_screeninfo asiliant
 
 static int __devinit init_asiliant(struct fb_info *p, unsigned long addr)
 {
+	int err;
+
 	p->fix			= asiliantfb_fix;
 	p->fix.smem_start	= addr;
 	p->var			= asiliantfb_var;
 	p->fbops		= &asiliantfb_ops;
 	p->flags		= FBINFO_DEFAULT;
-	int err;
 
 	err = fb_alloc_cmap(&p->cmap, 256, 0);
 	if (err) {

