Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbZCLM2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbZCLM2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZCLM1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:27:53 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:37105 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbZCLM1x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:27:53 -0400
Message-Id: <49B90DFE.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 12 Mar 2009 12:28:30 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <sam@ravnborg.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] remove pointless strdup() on arguments passed to
	 new_module()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

new_module() itself already calls strdup() on its modname parameter.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 scripts/mod/modpost.c |   4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.29-rc7/scripts/mod/modpost.c	2008-12-25 00:26:37.000000000 +0100
+++ 2.6.29-rc7-module-modpost/scripts/mod/modpost.c	2009-01-20 09:47:23.000000000 +0100
@@ -1910,7 +1910,7 @@ static void read_dump(const char *fname,
 		if (!mod) {
 			if (is_vmlinux(modname))
 				have_vmlinux = 1;
-			mod = new_module(NOFAIL(strdup(modname)));
+			mod = new_module(modname);
 			mod->skip = 1;
 		}
 		s = sym_add_exported(symname, mod, export_no(export));
@@ -1994,7 +1994,7 @@ static void read_markers(const char *fna
 
 		mod = find_module(modname);
 		if (!mod) {
-			mod = new_module(NOFAIL(strdup(modname)));
+			mod = new_module(modname);
 			mod->skip = 1;
 		}
 		if (is_vmlinux(modname)) {



