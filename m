Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab0BMQCy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 11:02:54 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:56896 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab0BMQCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 11:02:50 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 2/9] proc_devtree: fix THIS_MODULE without module.h
To: monstr@monstr.eu, sfr@canb.auug.org.au, benh@kernel.crashing.org,
       jeremy.kerr@canonical.com, davem@davemloft.net,
       microblaze-uclinux@itee.uq.edu.au, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
       linux-kernel@vger.kernel.org
Date: Sat, 13 Feb 2010 09:02:37 -0700
Message-ID: <20100213160236.4767.48310.stgit@angua>
In-Reply-To: <20100213154838.4767.83881.stgit@angua>
References: <20100213154838.4767.83881.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Kerr <jeremy.kerr@canonical.com>

Commit e22f628395432b967f2f505858c64450f7835365 introduced a build
breakage for ARM devtree work: the THIS_MODULE macro was added, but we
don't have module.h

This change adds the necessary #include to get THIS_MODULE defined.
While we could just replace it with NULL (PROC_FS is a bool, not a
tristate), using THIS_MODULE will prevent unexpected breakage if we
ever do compile this as a module.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 fs/proc/proc_devtree.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
index 0ec4511..f8650dc 100644
--- a/fs/proc/proc_devtree.c
+++ b/fs/proc/proc_devtree.c
@@ -11,6 +11,7 @@
 #include <linux/stat.h>
 #include <linux/string.h>
 #include <linux/of.h>
+#include <linux/module.h>
 #include <asm/prom.h>
 #include <asm/uaccess.h>
 #include "internal.h"

