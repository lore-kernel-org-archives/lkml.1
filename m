Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbXHROGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbXHROGU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 10:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbXHROGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 10:06:08 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:5093 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbXHROGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 10:06:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=b3szxwfxf1Yw+bChOxQ10Z7rKmLFv1Mx53eMwuNWgQwQvCFAyhu+IcI3GjkarNITukZ7ioQM8/DBMk3/Oz6CThroM9s9GY+CwL7SXe2tFz6f3eLczrZQPY9GNac/SW8zR54U+2As38gj7ednF66QmkAL+3r6I89nCvQ+DybkL2w=
Message-ID: <e5bfff550708180706n48e67d24qc74847ea4462c149@mail.gmail.com>
Date: Sat, 18 Aug 2007 16:06:05 +0200
From: "Marco Costalba" <mcostalba@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] qconf: show red links for disabled options
Cc: zippel@linux-m68k.org, sam@ravnborg.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When 'Show debug info' is checked then a list of links
to dependant symbols is shown in info view right bottom pane.

Currently all links are in standard blue. With this patch
links to disabled symbols are shown in red instead.

This, together with 'Show all options', allows to quickly
check out why a given option is hidden.

Signed-off-by: Marco Costalba <mcostalba@gmail.com>
---

I understand that color coding could be a poor choice due to people
with color differencing problems.

I chose this anyway to avoid crufting the output with additional signs/symbols,
this could became very ugly in case of long option lists.


  scripts/kconfig/qconf.cc |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index e4eeb59..e4927c1 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -1157,9 +1157,14 @@ void ConfigInfoView::expr_print_help(void
*data, struct symbol *sym, const char
  	QString str2 = print_filter(str);

  	if (sym && sym->name && !(sym->flags & SYMBOL_CONST)) {
+		bool disabled = (print_filter(sym_get_string_value(sym)) != "y");
+		if (disabled)
+			*text += "<font color=\"red\">";
  		*text += QString().sprintf("<a href=\"s%p\">", sym);
 		*text += str2;
 		*text += "</a>";
+		if (disabled)
+			*text += "</font>";
 	} else
 		*text += str2;
 }
-- 
1.5.3.rc4.67.gf9286
