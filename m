Return-Path: <linux-kernel-owner+w=401wt.eu-S1751718AbZIXNGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718AbZIXNGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 09:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbZIXNGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 09:06:04 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:52272 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbZIXNGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 09:06:03 -0400
Message-ID: <4ABB6EB7.7000002@gmail.com>
Date: Thu, 24 Sep 2009 15:05:59 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       linux-perf-users@vger.kernel.org
Subject: [PATCH] perf tools: fix buffer allocation
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 24 Sep 2009 15:05:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo

Here is a patch for perf.

BTW, use of openat() is a nuisance, since many machines have old glibc
(RHEL 4 Update 5 -> glibc-2.3.4-2.36 on my dev machine for example)

Thanks


[PATCH] perf tools: fix buffer allocation

"perf top" cores dump on my dev machine, if run from a directory where
vmlinux is present.

*** glibc detected *** malloc(): memory corruption: 0x085670d0 ***

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 tools/perf/util/module.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/module.c b/tools/perf/util/module.c
index 8f81622..0d8c85d 100644
--- a/tools/perf/util/module.c
+++ b/tools/perf/util/module.c
@@ -423,7 +423,7 @@ static int mod_dso__load_module_paths(struct mod_dso *self)
 	len += strlen(uts.release);
 	len += strlen("/modules.dep");
 
-	dpath = calloc(1, len);
+	dpath = calloc(1, len + 1);
 	if (dpath == NULL)
 		return err;
 
