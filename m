Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578AbXE2W43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbXE2W43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbXE2W4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:56:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:59409 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbXE2W4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:56:21 -0400
Date: Wed, 30 May 2007 00:56:19 +0200
From: Karsten Keil <kkeil@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthias Goebl <matthias@goebl.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix broken CLIR in isdn driver
Message-ID: <20070529225619.GA19702@pingi.kke.suse.de>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Matthias Goebl <matthias@goebl.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that CLIR (aka "hide your calling number") in isdn_tty is broken:
The at-command parser filters out the required "R" (e.g. ATDR089123456)
It's been broken for a *very* long time.

Signed-off-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Matthias Goebl <matthias.goebl@goebl.net>
---
 drivers/isdn/i4l/isdn_tty.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index ea5f30d..4e5f87c 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -2693,8 +2693,9 @@ isdn_tty_getdial(char *p, char *q,int cnt)
 	int limit = ISDN_MSNLEN - 1;	/* MUST match the size of interface var to avoid
 					buffer overflow */
 
-	while (strchr(" 0123456789,#.*WPTS-", *p) && *p && --cnt>0) {
+	while (strchr(" 0123456789,#.*WPTSR-", *p) && *p && --cnt>0) {
 		if ((*p >= '0' && *p <= '9') || ((*p == 'S') && first) ||
+		    ((*p == 'R') && first) ||
 		    (*p == '*') || (*p == '#')) {
 			*q++ = *p;
 			limit--;


-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
