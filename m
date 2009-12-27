Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbZL0NTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbZL0NTA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 08:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbZL0NS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 08:18:58 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:40015 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbZL0NSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 08:18:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=kwIu1VHKG0F1m1XWaKdo0na59taKzp6kiP1GEFtXtM8SlEYybGOURaJ/xxQDAuP75J
         3ZGGDeAcFnNCBDpnq9OMmPkixQ422DWU20JhYKwHAEGJG1c9SF4CDCYUI6dOPtAvq5Y7
         lT72opuqklihcCoLlvSpcRd+Rnl85BPZOqHvo=
Message-ID: <4B375F68.80301@gmail.com>
Date: Sun, 27 Dec 2009 14:21:44 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       "James E.J. Bottomley" <jejb@parisc-linux.org>,
       linux-parisc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] parisc: test off by one in sgl_frem() and dbl_frem()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With `while (stepcount-- > 0)' stepcount reaches -1 after the loop.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/parisc/math-emu/dfrem.c |    2 +-
 arch/parisc/math-emu/sfrem.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Unless I am missing something?

diff --git a/arch/parisc/math-emu/dfrem.c b/arch/parisc/math-emu/dfrem.c
index b983785..3283445 100644
--- a/arch/parisc/math-emu/dfrem.c
+++ b/arch/parisc/math-emu/dfrem.c
@@ -234,7 +234,7 @@ dbl_frem (dbl_floating_point * srcptr1, dbl_floating_point * srcptr2,
 		Dbl_subtract(opnd1p1,opnd1p2,opnd2p1,opnd2p2,opnd1p1,opnd1p2);
 		roundup = TRUE;
 	}
-	if (stepcount > 0 || Dbl_iszero(opnd1p1,opnd1p2)) {
+	if (stepcount >= 0 || Dbl_iszero(opnd1p1,opnd1p2)) {
 		/* division is exact, remainder is zero */
 		Dbl_setzero_exponentmantissa(resultp1,resultp2);
 		Dbl_copytoptr(resultp1,resultp2,dstptr);
diff --git a/arch/parisc/math-emu/sfrem.c b/arch/parisc/math-emu/sfrem.c
index 3a1b7a3..ad87832 100644
--- a/arch/parisc/math-emu/sfrem.c
+++ b/arch/parisc/math-emu/sfrem.c
@@ -229,7 +229,7 @@ sgl_frem (sgl_floating_point * srcptr1, sgl_floating_point * srcptr2,
 		Sgl_subtract(opnd1,opnd2,opnd1);
 		roundup = TRUE;
 	}
-	if (stepcount > 0 || Sgl_iszero(opnd1)) {
+	if (stepcount >= 0 || Sgl_iszero(opnd1)) {
 		/* division is exact, remainder is zero */
 		Sgl_setzero_exponentmantissa(result);
 		*dstptr = result;
