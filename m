Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbYBEKjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbYBEKjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 05:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbYBEKi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 05:38:56 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:45264 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754426AbYBEKiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 05:38:54 -0500
Date: Tue, 5 Feb 2008 11:38:49 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Sam Ravnborg <sam@ravnborg.org>
cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [REVIEW for merge] kbuild updates including silence of section
 mismatch check
In-Reply-To: <20080202203503.GA26415@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0802051116410.1588@vixen.sonytel.be>
References: <20080202203503.GA26415@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-421666238-1202207929=:1588"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-421666238-1202207929=:1588
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sat, 2 Feb 2008, Sam Ravnborg wrote:
> The most visible change is that I have made all the section mismatch
> go away and in the end of the build modpost report the number
> of section mismatch warnings and how to see detail.
> 
> The typical output is now:
> 
> modpost: Found 35 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'

Can we get a `warning' string literal in that message, so I notice it when
grepping for compiler warnings?

... Ah, there already exists a warn() routine, so let's use it.

Subject: modpost: Use warn() for announcing section mismatches

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

modpost: Use warn() for announcing section mismatches, for easy grepping for
warnings in build logs.

Also change an existing call from fprintf() to warn() while we're at it.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 scripts/mod/modpost.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1129,10 +1129,10 @@ static void report_sec_mismatch(const ch
 	if (!sec_mismatch_verbose)
 		return;
 
-	fprintf(stderr, "WARNING: %s(%s+0x%llx): Section mismatch in"
-	                " reference from the %s %s%s to the %s %s:%s%s\n",
-                        modname, fromsec, fromaddr, from, fromsym, from_p,
-	                to, tosec, tosym, to_p);
+	warn("%s(%s+0x%llx): Section mismatch in reference from the %s %s%s "
+	     "to the %s %s:%s%s\n",
+	     modname, fromsec, fromaddr, from, fromsym, from_p, to, tosec,
+	     tosym, to_p);
 
 	switch (mismatch) {
 	case TEXT_TO_INIT:
@@ -1938,10 +1938,10 @@ int main(int argc, char **argv)
 	if (dump_write)
 		write_dump(dump_write);
 	if (sec_mismatch_count && !sec_mismatch_verbose)
-		fprintf(stderr, "modpost: Found %d section mismatch(es).\n"
-		        "To see full details build your kernel with:\n"
-		        "'make CONFIG_DEBUG_SECTION_MISMATCH=y'\n",
-		        sec_mismatch_count);
+		warn("modpost: Found %d section mismatch(es).\n"
+		     "To see full details build your kernel with:\n"
+		     "'make CONFIG_DEBUG_SECTION_MISMATCH=y'\n",
+		     sec_mismatch_count);
 
 	return err;
 }

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Network and Software Technology Center Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584349381-421666238-1202207929=:1588--
