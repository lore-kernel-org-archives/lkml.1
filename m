Return-Path: <linux-kernel-owner+w=401wt.eu-S1760960AbXEJUea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760960AbXEJUea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843AbXEJUeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:34:23 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:35664 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755592AbXEJUeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:34:22 -0400
X-YMail-OSG: GbaogcMVM1no3q2g6dS3TLxfbfEB2A5lH3HHs7bIfjUJchRZDkEHu6JhwBEGtcAyC9EtmGVXLw--
Date: Thu, 10 May 2007 13:34:18 -0700
From: Chris Wedgwood <cw@f00f.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>, Sam Ravnborg <sam@ravnborg.org>
Subject: (hacky) [PATCH] silence MODPOST section mismatch warnings
Message-ID: <20070510203417.GA23019@tuatara.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

MODPOST seems to be spewing bogus warnings.  It's not clear how best
to fix it so perhaps we should silence it for now?

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 113dc77..bd6fe7b 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -872,6 +872,10 @@ static void warn_sec_mismatch(const char *modname, const char *fromsec,
 				 sechdrs[hdr->e_shstrndx].sh_offset;
 	const char *secname = secstrings + sechdrs[sym->st_shndx].sh_name;
 
+	/* FIXME: this function doesn't work correctly anymore, it's
+	 * not clear if it should be fixed or removed. */
+	return;
+
 	find_symbols_between(elf, r.r_offset, fromsec, &before, &after);
 
 	refsym = find_elf_symbol(elf, r.r_addend, sym);
