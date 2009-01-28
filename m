Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbZA1Nhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbZA1Nhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 08:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbZA1NgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:36:05 -0500
Received: from ozlabs.org ([203.10.76.45]:55204 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725AbZA1NgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:36:04 -0500
To: linux-kernel@vger.kernel.org
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 29 Jan 2009 00:05:58 +1030
CC: Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 6/6] module: remove the SHF_ALLOC flag on the __versions section.
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200901290005.59200.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK, the rest of this series was really intellectual masturbation.
This patch just takes off the SHF_ALLOC flag on __versions so we don't
keep them around after module load.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2010,6 +2010,9 @@ static noinline struct module *load_modu
 		if (strncmp(secstrings+sechdrs[i].sh_name, ".exit", 5) == 0)
 			sechdrs[i].sh_flags &= ~(unsigned long)SHF_ALLOC;
 #endif
+		/* Don't keep __versions around; it's just for loading. */
+		if (strcmp(secstrings + sechdrs[i].sh_name, "__versions") == 0)
+			sechdrs[i].sh_flags &= ~(unsigned long)SHF_ALLOC;
 	}
 
 	modindex = find_sec(hdr, sechdrs, secstrings,

