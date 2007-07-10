Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbXGJMbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbXGJMbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 08:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbXGJMbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 08:31:24 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:35785 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbXGJMbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 08:31:23 -0400
Date: Tue, 10 Jul 2007 09:16:32 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: [KBUILD] Whitelist references from __dbe_table to .init
Message-ID: <20070710081632.GA10559@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed on MIPS where the same mechanism as get_user() is used to
intercept bus error exceptions for some hardware probes.  Without this
patch modpost will throw spurious warnings:

  LD      vmlinux
  SYSMAP  System.map
  SYSMAP  .tmp_System.map
  MODPOST vmlinux
WARNING: arch/mips/sgi-ip22/built-in.o(__dbe_table+0x0): Section mismatch: reference to .init.text:

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 3645e98..c337246 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1047,6 +1047,7 @@ static int init_section_ref_ok(const char *name)
 		".pdr",
 		"__param",
 		"__ex_table",
+		"__dbe_table",
 		".fixup",
 		".smp_locks",
 		".plt",  /* seen on ARCH=um build on x86_64. Harmless */
