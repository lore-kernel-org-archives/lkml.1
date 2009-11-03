Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbZKCSiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbZKCSiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 13:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbZKCSiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 13:38:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:60444 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbZKCSiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 13:38:10 -0500
Subject: [PATCH] strstrip incorrectly marked __must_check
From: James Bottomley <James.Bottomley@suse.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Nov 2009 12:38:08 -0600
Message-Id: <1257273488.9427.27.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

strstrip strips whitespace from the beginning and end of a string.  I
agree you have to take the returned pointer if you want to strip from
the beginning.  However, if you wish to keep the whitespace at the
beginning and only wish strstrip to remove it from the end, then it's
entirely legitimate to discard the returned pointer.

This is what we have in drivers/scsi/ipr.c and the patch to make
strstrip __must_check is now causing SCSI spurious warnings in that
code.

Signed-off-by: James Bottomley <James.Bottomley@suse.de>

---

diff --git a/include/linux/string.h b/include/linux/string.h
index b850886..489019e 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -62,7 +62,7 @@ extern char * strnchr(const char *, size_t, int);
 #ifndef __HAVE_ARCH_STRRCHR
 extern char * strrchr(const char *,int);
 #endif
-extern char * __must_check strstrip(char *);
+extern char * strstrip(char *);
 #ifndef __HAVE_ARCH_STRSTR
 extern char * strstr(const char *,const char *);
 #endif


