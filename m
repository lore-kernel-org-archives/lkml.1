Return-Path: <linux-kernel-owner+w=401wt.eu-S1752123AbYHHHrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbYHHHrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 03:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbYHHHr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 03:47:28 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:39607 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbYHHHr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 03:47:27 -0400
Date: Fri, 8 Aug 2008 09:47:24 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] DocBook: don't compress mandocs
Message-ID: <20080808074724.GA28249@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mandocs target uses gzip to compress the resulting manpages. If this
target runs more than once (using make -jX) at the same time, gzip may
run more then once with the same set of files. It just bails out if it
is not able to find a file because a concurrent run already removed it.

Fix this by removing the gzip call and only work with uncompressed
manpages.

Signed-off-by: Bastian Blank <waldi@debian.org>

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 1d1b345..3fb6ef2 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -51,7 +51,7 @@ mandocs: $(MAN)
 
 installmandocs: mandocs
 	mkdir -p /usr/local/man/man9/
-	install Documentation/DocBook/man/*.9.gz /usr/local/man/man9/
+	install Documentation/DocBook/man/*.9 /usr/local/man/man9/
 
 ###
 #External programs used
@@ -156,7 +156,7 @@ quiet_cmd_db2html = HTML   $@
             cp $(PNG-$(basename $(notdir $@))) $(patsubst %.html,%,$@); fi
 
 quiet_cmd_db2man = MAN     $@
-      cmd_db2man = if grep -q refentry $<; then xmlto man $(XMLTOFLAGS) -o $(obj)/man $< ; gzip -f $(obj)/man/*.9; fi
+      cmd_db2man = if grep -q refentry $<; then xmlto man $(XMLTOFLAGS) -o $(obj)/man $<; fi
 %.9 : %.xml
 	@(which xmlto > /dev/null 2>&1) || \
 	 (echo "*** You need to install xmlto ***"; \
-- 
Only a fool fights in a burning house.
		-- Kank the Klingon, "Day of the Dove", stardate unknown
