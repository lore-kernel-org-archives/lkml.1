Return-Path: <linux-kernel-owner+w=401wt.eu-S934794AbYBCEpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934794AbYBCEpf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 23:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbYBCEpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 23:45:19 -0500
Received: from c60.cesmail.net ([216.154.195.49]:54657 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbYBCEpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 23:45:16 -0500
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] module: remove module taint on ndiswrapper
To: linux-kernel@vger.kernel.org
Cc: Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 02 Feb 2008 23:45:13 -0500
Message-ID: <20080203044513.29742.69286.stgit@dv.roinet.com>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert 0aa5bd52d0c49ca56d24584c646e6544ccbb3dc9, which disallowed
ndiswrapper to use GPL-only symbols.

Add comments why ndiswrapper and driverloader are tainted to avoid
similar mistakes in the future.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 kernel/module.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index bd60278..c7f3fa6 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1933,8 +1933,13 @@ static struct module *load_module(void __user *umod,
 	/* Set up license info based on the info section */
 	set_license(mod, get_modinfo(sechdrs, infoindex, "license"));
 
+	/* ndiswrapper can load proprietary drivers.  Don't use
+	   add_taint_module(), as ndiswrapper needs GPL-only symbols. */
 	if (strcmp(mod->name, "ndiswrapper") == 0)
-		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
+		add_taint(TAINT_PROPRIETARY_MODULE);
+
+	/* driverloader is proprietary, but it's known to be lying about
+	   its license in the license info */
 	if (strcmp(mod->name, "driverloader") == 0)
 		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
 
