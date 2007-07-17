Return-Path: <linux-kernel-owner+w=401wt.eu-S933522AbXGQOMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522AbXGQOMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762995AbXGQOIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:08:04 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35930 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879AbXGQOHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:52 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 21/33] kbuild: whitelist references from variables named _timer to .init.text
Date: Tue, 17 Jul 2007 16:08:50 +0200
Message-Id: <1184681344985-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11846813444171-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org> <11846813433593-git-send-email-sam@ravnborg.org> <11846813432300-git-send-email-sam@ravnborg.org> <11846813432072-git-send-email-sam@ravnborg.org> <11846813431389-git-send-email-sam@ravnborg.org> <1184681343412-git-send-email-sam@ravnborg.org> <11846813432249-git-send-email-sam@ravnborg.org> <1184681343297-git-send-email-sam@ravnborg.org> <11846813432231-git-send-email-sam@ravnborg.org> <1184681343423-git-send-email-sam@ravnborg.org> <11846813432234-git-send-email-sam@ravnborg.org> <11846813441521-git-send-email-sam@ravnborg.org> <11846813443387-git-send-email-sam@ravnborg.org> <1184681344594-git-send-email-sam@ravnborg.org> <11846813444176-git-send-email-sam@ravnborg.org> <11846813442297-git-send-email-sam@ravnborg.org> <11846813443187-git-send-email-sam@ravnborg.org> <11846813
 444171-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

arm uses a lot of ops structures named *_timer that has legitimite
references to .init.text.
So let's add this variable to the list of variables that may reference
.init.text without causing any warning.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 015c6b0..bb895b1 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -609,7 +609,7 @@ static int strrcmp(const char *s, const char *sub)
  *   the pattern is identified by:
  *   tosec   = .init.text | .exit.text | .init.data
  *   fromsec = .data
- *   atsym = *driver, *_template, *_sht, *_ops, *_probe, *probe_one, *_console
+ *   atsym = *driver, *_template, *_sht, *_ops, *_probe, *probe_one, *_console, *_timer
  *
  * Pattern 3:
  *   Whitelist all refereces from .text.head to .init.data
@@ -634,6 +634,7 @@ static int secref_whitelist(const char *modname, const char *tosec,
 	const char *pat2sym[] = {
 		"driver",
 		"_template", /* scsi uses *_template a lot */
+		"_timer",    /* arm uses ops structures named _timer a lot */
 		"_sht",      /* scsi also used *_sht to some extent */
 		"_ops",
 		"_probe",
-- 
1.5.0.6

