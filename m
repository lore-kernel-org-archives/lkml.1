Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbYANWIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbYANWIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 17:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbYANWIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 17:08:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:33019 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbYANWIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 17:08:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=wtok2IYOLVnjC7m3ORLMTMt07Wk5ht5lyjNcdahgjoqSaxi26mch1VnIV3wXb3JLcI1suDrc1q8EjI1FDi1oxKl7ydqjXUDwqJils4Ns2JvkieN/fPzV9Bz9iEVoBRPuT8E8DsejJveVPhrctZG207AfU2Uw9RQpJd+SztVZafg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH] scripts/checkpatch.pl: warn about using __FUNCTION__
Date: Mon, 14 Jan 2008 23:19:48 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801142319.48150.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


__FUNCTION__ is gcc specific, __func__ is C99

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 scripts/checkpatch.pl |    5 +++++
 1 file changed, 5 insertions(+)

Index: b/scripts/checkpatch.pl
===================================================================
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1557,6 +1557,11 @@ sub process {
 		if ($line =~ /\*\s*\)\s*k[czm]alloc\b/) {
 			WARN("unnecessary cast may hide bugs, see 
http://c-faq.com/malloc/mallocnocast.html\n" . $herecurr);
 		}
+
+# check for gcc specific __FUNCTION__
+		if ($line =~ /__FUNCTION__/) {
+			WARN("__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr);
+		}
 	}
 
 	# In mailback mode only produce a report in the negative, for
