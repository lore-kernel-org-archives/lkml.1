Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbZFKJHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbZFKJHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 05:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZFKJH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 05:07:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39069 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbZFKJH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 05:07:27 -0400
Date: Thu, 11 Jun 2009 19:07:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: rr tree build failure
Message-Id: <20090611190728.510af289.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

Today's linux-next build (sparc defconfig) failed like this:

arch/sparc/mm/extable.c: In function 'trim_init_extable':
arch/sparc/mm/extable.c:78: error: too few arguments to function 'within_module_init'

Caused by commit 2ac595c3960b80139e895c4e13e851ed6dfd127a ("module: trim
exception table on init free").

I applied the following patch (because I did not want to have to rebuild
everything again).

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 11 Jun 2009 18:53:13 +1000
Subject: [PATCH] rr: fix up for sparc32 extable

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sparc/mm/extable.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/mm/extable.c b/arch/sparc/mm/extable.c
index 6b5c373..a61c349 100644
--- a/arch/sparc/mm/extable.c
+++ b/arch/sparc/mm/extable.c
@@ -75,7 +75,7 @@ void trim_init_extable(struct module *m)
 	for (i = 0; i < m->num_exentries; i += range ? 2 : 1) {
 		range = m->extable[i].fixup == 0;
 
-		if (within_module_init(m->extable[i].insn)) {
+		if (within_module_init(m->extable[i].insn, m)) {
 			m->extable[i].fixup = -1;
 			if (range)
 				m->extable[i+1].fixup = -1;
-- 
1.6.3.1

