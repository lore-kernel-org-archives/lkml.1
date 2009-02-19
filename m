Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbZBSPMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbZBSPMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 10:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbZBSPMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 10:12:44 -0500
Received: from a.mx.secunet.com ([213.68.205.161]:56571 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbZBSPMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 10:12:42 -0500
X-Greylist: delayed 1215 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Feb 2009 10:12:42 EST
From: Helge Bahmann <helge.bahmann@secunet.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] trivial: fix arg reversal in fs/proc/page.c
Date: Thu, 19 Feb 2009 15:54:47 +0100
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902191554.47382.helge.bahmann@secunet.com>
X-OriginalArrivalTime: 19 Feb 2009 14:52:26.0397 (UTC) FILETIME=[AE08C4D0:01C992A1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix arguments passed to macro in wrong order (expr always evaluates to zero 
otherwise)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index 767d95a..2d13451 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -107,7 +107,7 @@ static ssize_t kpageflags_read(struct file *file, char 
__user *buf,
 		else
 			kflags = ppage->flags;
 
-		uflags = kpf_copy_bit(KPF_LOCKED, PG_locked, kflags) |
+		uflags = kpf_copy_bit(kflags, KPF_LOCKED, PG_locked) |
 			kpf_copy_bit(kflags, KPF_ERROR, PG_error) |
 			kpf_copy_bit(kflags, KPF_REFERENCED, PG_referenced) |
 			kpf_copy_bit(kflags, KPF_UPTODATE, PG_uptodate) |
-- 
Dipl. Math.
Helge Bahmann
Berater
Gesch‰ftsbereich Hochsicherheit
secunet Security Networks AG
Ammonstraﬂe 74
01067 Dresden, Germany
Fon: +49 201 54 54-3586
Fax: +49 201 54 54-1323
Email: helge.bahmann@secunet.com

Sitz: Kronprinzenstraﬂe 30, 45128 Essen
Amtsgericht Essen HRB 13615
Vorstand: Dr. Rainer Baumgart, Thomas Koelzer, Thomas Pleines
Aufsichtsratsvorsitzender: Dr. Karsten Ottenberg
