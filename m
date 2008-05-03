Return-Path: <linux-kernel-owner+w=401wt.eu-S1763532AbYECKdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763532AbYECKdQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 06:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758237AbYECKc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 06:32:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:57236 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442AbYECKc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 06:32:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=W7bWUfVklwV5xgfq9S95GTmt8nxbHtMpdkL1wbUohqvcNJ2gzQ3Qi55ZaiGemRoWHxKx/L3RQFFhy64SuG4up+UK/pqyu8Rh3Vfd2l/oSdFT8CnWvbwqgycomr7jlNHJ9YIIZFZRpuWa1FKT1QVN2uXv/Sz7gi2jNlUFHiBZcG0=
References: <20080503101800.417039810@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 03 May 2008 14:18:02 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
       ralf@linux-mips.org
Cc: linux-kernel@vger.kernel.org, gorcunov@gmail.com
Subject: [patch 2/4] module loading ELF handling - use SELFMAG instead of numeric constant
Content-Disposition: inline; filename=elf-kernel-module
Message-ID: <481c3f58.0305560a.104c.ffffc432@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/kernel/module.c
===================================================================
--- linux-2.6.git.orig/kernel/module.c	2008-05-02 09:12:55.000000000 +0400
+++ linux-2.6.git/kernel/module.c	2008-05-02 21:36:51.000000000 +0400
@@ -1758,7 +1758,7 @@ static struct module *load_module(void _
 
 	/* Sanity checks against insmoding binaries or wrong arch,
            weird elf version */
-	if (memcmp(hdr->e_ident, ELFMAG, 4) != 0
+	if (memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0
 	    || hdr->e_type != ET_REL
 	    || !elf_check_arch(hdr)
 	    || hdr->e_shentsize != sizeof(*sechdrs)) {

-- 
