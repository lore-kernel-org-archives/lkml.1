Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbXFLH3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbXFLH3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbXFLH2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:28:53 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:52546 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750995AbXFLH2w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:28:52 -0400
Message-Id: <466E6785.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 12 Jun 2007 09:29:41 +0200
From: "Jan Beulich" <jbeulich@novell.com>
To: <sam@ravnborg.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] modpost white list pattern adjustment
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

gcc puts data into .data.rel or .data.rel.* on some architectures (e.g.
ia64) or under certain conditions, so whatever is legal relative to
.data should also be legal for those other sections. Fixes a few
modpost warnings on ia64.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 scripts/mod/modpost.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

--- linux-2.6.22-rc4/scripts/mod/modpost.c	2007-06-11 18:10:54.000000000 +0200
+++ 2.6.22-rc4-modpost-data-rel/scripts/mod/modpost.c	2007-06-11 11:35:34.000000000 +0200
@@ -605,7 +605,7 @@ static int strrcmp(const char *s, const 
  *   warn here.
  *   the pattern is identified by:
  *   tosec   = .init.text | .exit.text | .init.data
- *   fromsec = .data
+ *   fromsec = .data | .data.rel | .data.rel.*
  *   atsym = *driver, *_template, *_sht, *_ops, *_probe, *probe_one, *_console
  *
  * Pattern 3:
@@ -692,7 +692,9 @@ static int secref_whitelist(const char *
 	    (strcmp(tosec, ".exit.text") != 0) &&
 	    (strcmp(tosec, ".init.data") != 0))
 		f2 = 0;
-	if (strcmp(fromsec, ".data") != 0)
+	if (strcmp(fromsec, ".data") != 0 &&
+	    strcmp(fromsec, ".data.rel") != 0 &&
+	    strncmp(fromsec, ".data.rel.", strlen(".data.rel.")) != 0)
 		f2 = 0;
 
 	for (s = pat2sym; *s; s++)



