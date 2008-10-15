Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYJOJO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYJOJO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 05:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYJOJOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 05:14:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58965 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbYJOJOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 05:14:47 -0400
Date: Wed, 15 Oct 2008 20:03:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>
Subject: [PATCH] make do_mounts_md use of msleep more robust
Message-Id: <20081015200352.17b12999.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 589f800bb12c5cd6c9167bbf9bf3cb70cd8e422c ("fastboot: make the raid
autodetect code wait for all devices to init") added a call to msleep to
do_mounts_md.c but the declaration of that was only included implicitly
through linux/raid/md.h.  Make the include of linux/delay.h explicit.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

---
 init/do_mounts_md.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

Discovered when commit 6caa3b0bbdb474647f6bdd8a958ffc46f78d8d58 ("md:
Remove unnecessary #includes, #defines, and function declarations") was
added to linux-next from the md tree.

diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
index 48b3fad..cbc447d 100644
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -1,4 +1,5 @@
 
+#include <linux/delay.h>
 #include <linux/raid/md.h>
 
 #include "do_mounts.h"
-- 
1.5.6.5

Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

