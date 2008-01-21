Return-Path: <linux-kernel-owner+w=401wt.eu-S1760672AbYAUV1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760672AbYAUV1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756919AbYAUV0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:26:22 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:42680 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbYAUV0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:26:18 -0500
X-Greylist: delayed 2554 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jan 2008 16:26:18 EST
Date: Mon, 21 Jan 2008 20:43:41 +0000
From: Jon Masters <jonathan@jonmasters.org>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, jcm@jonmasters.org
Subject: [PATCH] add module taint on ndiswrapper
Message-ID: <20080121204341.GA29679@dallas.jonmasters.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: jcm@dallas.jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct module taints member is supposed to store per-module taint
data. The kernel knows about certain specific external modules that will
taint the kernel, such as ndiswrapper. Use of ndiswrapper possibly
should set the per-module taint in addition to the global kernel
taint flag, unless we're arguing not because wrapper module itself
is not what actually causes the kernel to be tainted as such?

Signed-off-by: Jon Masters <jcm@jonmasters.org>

diff -urp linus_26/kernel/module.c jcm_26/kernel/module.c
--- linus_26/kernel/module.c	2008-01-21 13:16:39.000000000 -0500
+++ jcm_26/kernel/module.c	2008-01-21 15:25:41.000000000 -0500
@@ -1893,7 +1893,7 @@ static struct module *load_module(void _
 	set_license(mod, get_modinfo(sechdrs, infoindex, "license"));
 
 	if (strcmp(mod->name, "ndiswrapper") == 0)
-		add_taint(TAINT_PROPRIETARY_MODULE);
+		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
 	if (strcmp(mod->name, "driverloader") == 0)
 		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
 
