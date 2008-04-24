Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbYDXEzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbYDXEzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 00:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbYDXEz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 00:55:27 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:36371 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbYDXEz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 00:55:26 -0400
X-Greylist: delayed 1738 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2008 00:55:26 EDT
Date: Thu, 24 Apr 2008 14:26:27 +1000
To: David Miller <davem@davemloft.net>, linux-net@vger.kernel.org
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Silence 'may be used uninitialized' warning in net/sunrpc/svc.c.
Message-ID: <20080424042627.GP20457@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current kernels warn about:
net/sunrpc/svc.c: In function '__svc_create_thread':
net/sunrpc/svc.c:593: warning: 'oldmask.bits[0u]' may be used uninitialized in this function

As far as I can see oldmask will be initialised to something in each
case it's used.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
---
 net/sunrpc/svc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 090af78..0e75a43 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -590,7 +590,7 @@ __svc_create_thread(svc_thread_fn func, struct svc_serv *serv,
 	struct svc_rqst	*rqstp;
 	int		error = -ENOMEM;
 	int		have_oldmask = 0;
-	cpumask_t	oldmask;
+	cpumask_t	uninitialized_var(oldmask);
 
 	rqstp = svc_prepare_thread(serv, pool);
 	if (IS_ERR(rqstp)) {
-- 
1.5.5.1


Yours Tony

  linux.conf.au    http://www.marchsouth.org/
  Jan 19 - 24 2009 The Australian Linux Technical Conference!

