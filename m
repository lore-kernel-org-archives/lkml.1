Return-Path: <linux-kernel-owner+w=401wt.eu-S932324AbXE2Udc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbXE2Udc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766014AbXE2UdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:33:05 -0400
Received: from gw.goop.org ([64.81.55.164]:37128 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766010AbXE2UdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:33:01 -0400
Message-ID: <465C8DFD.6080500@goop.org>
Date: Tue, 29 May 2007 13:33:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>, Sam Ravnborg <sam@ravnborg.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: The .paravirtprobe section is obsolete, so modpost doesn't need to
 handle it
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The .paravirtprobe section is obsolete, so modpost doesn't need to handle it.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sam Ravnborg <sam@ravnborg.org>

---
 scripts/mod/modpost.c |   11 -----------
 1 file changed, 11 deletions(-)

===================================================================
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -634,12 +634,6 @@ static int strrcmp(const char *s, const 
  *  fromsec    = .text*
  *  refsymname = logo_
  *
- * Pattern 8:
- *  Symbols contained in .paravirtprobe may safely reference .init.text.
- *  The pattern is:
- *  tosec   = .init.text
- *  fromsec  = .paravirtprobe
- *
  * Pattern 10:
  *  ia64 has machvec table for each platform and
  *  powerpc has a machine desc table for each platform.
@@ -721,11 +715,6 @@ static int secref_whitelist(const char *
 	if ((strcmp(tosec, ".init.data") == 0) &&
 	    (strncmp(fromsec, ".text", strlen(".text")) == 0) &&
 	    (strncmp(refsymname, "logo_", strlen("logo_")) == 0))
-		return 1;
-
-	/* Check for pattern 8 */
-	if ((strcmp(tosec, ".init.text") == 0) &&
-	    (strcmp(fromsec, ".paravirtprobe") == 0))
 		return 1;
 
 	/* Check for pattern 10 */


