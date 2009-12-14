Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbZLNRKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbZLNRKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 12:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758036AbZLNRKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 12:10:17 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:59650 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013AbZLNRKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 12:10:15 -0500
Date: Mon, 14 Dec 2009 09:10:05 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] fs: fix compat_ioctl build for CONFIG_BLOCK=n
Message-Id: <20091214091005.b4df65d9.randy.dunlap@oracle.com>
In-Reply-To: <20091214165927.c08c4784.sfr@canb.auug.org.au>
References: <20091214165927.c08c4784.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090202.4B267170.006D:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build failure when CONFIG_BLOCK=n:

fs/compat_ioctl.c:1604: error: 'SG_SET_TRANSFORM' undeclared

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/compat_ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20091214.orig/fs/compat_ioctl.c
+++ linux-next-20091214/fs/compat_ioctl.c
@@ -1600,8 +1600,10 @@ static long do_ioctl_trans(int fd, unsig
 	case KDSKBMETA:
 	case KDSKBLED:
 	case KDSETLED:
+#ifdef CONFIG_BLOCK
 	/* SG stuff */
 	case SG_SET_TRANSFORM:
+#endif
 	/* AUTOFS */
 	case AUTOFS_IOC_READY:
 	case AUTOFS_IOC_FAIL:
