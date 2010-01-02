Return-Path: <linux-kernel-owner+w=401wt.eu-S1752317Ab0ABCZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab0ABCZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 21:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251Ab0ABCZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 21:25:47 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:17990 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab0ABCZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 21:25:46 -0500
Date: Fri, 1 Jan 2010 18:25:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org
Subject: [PATCH v2] sunrpc: fix build-time warning
Message-Id: <20100101182514.cb1f49ef.randy.dunlap@oracle.com>
In-Reply-To: <20091231205454.0f84f091@tupile.poochiereds.net>
References: <1262226195-27733-1-git-send-email-jlayton@redhat.com>
	<20091231091815.a1ea7e51.rdunlap@xenotime.net>
	<20091231205454.0f84f091@tupile.poochiereds.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B3EAE8D.00EB:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix auth_gss printk format warning:

net/sunrpc/auth_gss/auth_gss.c:660: warning: format '%ld' expects type 'long int', but argument 3 has type 'ssize_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 net/sunrpc/auth_gss/auth_gss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20091229.orig/net/sunrpc/auth_gss/auth_gss.c
+++ linux-next-20091229/net/sunrpc/auth_gss/auth_gss.c
@@ -657,7 +657,7 @@ gss_pipe_downcall(struct file *filp, con
 			break;
 		default:
 			printk(KERN_CRIT "%s: bad return from "
-				"gss_fill_context: %ld\n", __func__, err);
+				"gss_fill_context: %zd\n", __func__, err);
 			BUG();
 		}
 		goto err_release_msg;
---
