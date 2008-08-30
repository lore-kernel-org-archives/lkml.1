Return-Path: <linux-kernel-owner+w=401wt.eu-S1752887AbYH3KfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbYH3KfX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 06:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbYH3KfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 06:35:10 -0400
Received: from main.gmane.org ([80.91.229.2]:51405 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbYH3KfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 06:35:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Helge Deller <deller@gmx.de>
Subject: [PATCH] Re: Linux 2.6.27-rc5
Date: Sat, 30 Aug 2008 12:34:51 +0200
Message-ID: <g9b7oa$g8l$1@ger.gmane.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: mnhm-590e0194.pool.einsundeins.de
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit da574983de9f9283ba35662c8723627096e160de
Author: Al Viro <viro@zeniv.linux.org.uk>
[PATCH] fix hpux_getdents() - Missing checks for -EFAULT, broken handling of
overflow.

introduced a build breakage:
  CC      arch/parisc/hpux/fs.o
arch/parisc/hpux/fs.c: In function `filldir':
arch/parisc/hpux/fs.c:107: error: `buffer' undeclared (first use in this
function)
make[1]: *** [arch/parisc/hpux/fs.o] Error 1


This patch fixes it.

Signed-off-by: Helge Deller <deller@gmx.de>


diff --git a/arch/parisc/hpux/fs.c b/arch/parisc/hpux/fs.c
index 69ff671..12c04c5 100644
--- a/arch/parisc/hpux/fs.c
+++ b/arch/parisc/hpux/fs.c
@@ -104,7 +104,7 @@ static int filldir(void * __buf, const char * name, int
namlen, loff_t offset,
        buf->count -= reclen;
        return 0;
 Efault:
-       buffer->error = -EFAULT;
+       buf->error = -EFAULT;
        return -EFAULT;
 }
 


