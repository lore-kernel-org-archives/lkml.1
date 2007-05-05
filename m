Return-Path: <linux-kernel-owner+w=401wt.eu-S933982AbXEEQo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933982AbXEEQo0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933966AbXEEQo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:44:26 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38916 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933947AbXEEQoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:44:25 -0400
Date: Sat, 5 May 2007 18:44:23 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, trond.myklebust@fys.uio.no,
       davem@davemloft.net, David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [-mm patch] fix fs/nfs/nfsroot.c compile error
Message-ID: <20070505164422.GD8975@stusta.de>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070505014955.8f3990b5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 01:49:55AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.21-rc7-mm2:
>...
>  git-net.patch
>...
>  git trees
>...

match_table_t was made "const" and gcc doesn't like "const __initdata":

<--  snip  -->

...
  CC      fs/nfs/nfsroot.o
/home/bunk/linux/kernel-2.6/linux-2.6.21-mm1/fs/nfs/nfsroot.c:131: error: tokens causes a section type conflict
make[3]: *** [fs/nfs/nfsroot.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

BTW: Why is this change to include/linux/parser.h in the net tree?

--- linux-2.6.21-mm1/fs/nfs/nfsroot.c.old	2007-05-05 18:36:26.000000000 +0200
+++ linux-2.6.21-mm1/fs/nfs/nfsroot.c	2007-05-05 18:36:44.000000000 +0200
@@ -128,7 +128,7 @@
 	Opt_err
 };
 
-static match_table_t __initdata tokens = {
+static match_table_t tokens = {
 	{Opt_port, "port=%u"},
 	{Opt_rsize, "rsize=%u"},
 	{Opt_wsize, "wsize=%u"},
