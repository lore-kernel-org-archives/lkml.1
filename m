Return-Path: <linux-kernel-owner+w=401wt.eu-S2993054AbXCIH1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993054AbXCIH1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:27:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993058AbXCIH1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:27:11 -0500
Received: from nz-out-0506.google.com ([64.233.162.232]:8005 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993054AbXCIH1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:27:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:organization:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=BkAAppUSdvCF2VfnaY6x2OmZqr1n7M/eErRmCFPYumHA6WjBkydP7Z/2qEKtkaL0EFuxQ/JJleD3a6kZr4R/G+Jdy8mnjUXubJEoRXezB9/bLEaWuNcPpaE7DE34zeKGmRt7p/tzOAj9t7BEWl9MF9N9LhExiOHz8LncEJaWs9M=
Date: Thu, 8 Mar 2007 23:26:54 -0800
From: Amit Choudhary <amit2030@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] net/wanrouter/wanmain.c: check kmalloc() return value.
Message-Id: <20070308232654.d0334ccd.amit2030@gmail.com>
Organization: X
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.8.15; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Description: Check the return value of kmalloc() in function dbg_kmalloc(), in file net/wanrouter/wanmain.c.

Signed-off-by: Amit Choudhary <amit2030@gmail.com>

diff --git a/net/wanrouter/wanmain.c b/net/wanrouter/wanmain.c
index 316211d..263450c 100644
--- a/net/wanrouter/wanmain.c
+++ b/net/wanrouter/wanmain.c
@@ -67,6 +67,8 @@ static void * dbg_kmalloc(unsigned int s
 	int i = 0;
 	void * v = kmalloc(size+sizeof(unsigned int)+2*KMEM_SAFETYZONE*8,prio);
 	char * c1 = v;
+	if (!v)
+		return NULL;
 	c1 += sizeof(unsigned int);
 	*((unsigned int *)v) = size;
 
