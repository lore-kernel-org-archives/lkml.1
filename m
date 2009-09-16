Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbZIPVjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbZIPVjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 17:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760099AbZIPVjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 17:39:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:17634 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbZIPVjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 17:39:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CNv7Dpqhor8ooIaEmYR9Dpq9FDwry4LFmyNhhczKhdYHEsP+/okC0j3DtH7sHqF1hu
         Gn9AoGDWj+LGiTbQikVyWlXCdDpTVhz9XZAV6zO5wnf7gbXKgZjbf49jXYRSrTB10vZr
         XWR9LV1iqzQAWVECuE9sl/Qfy4Mk1yX9MJ3C4=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH v2 2/6] kbuild: fix warning when domainname is not available
Date: Thu, 17 Sep 2009 00:38:39 +0300
Message-Id: <1253137123-18047-3-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1253137123-18047-2-git-send-email-felipe.contreras@gmail.com>
References: <1253137123-18047-1-git-send-email-felipe.contreras@gmail.com>
 <1253137123-18047-2-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we get:
"dnsdomainname: Unknown host"

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 scripts/mkcompile_h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/scripts/mkcompile_h b/scripts/mkcompile_h
index 6a12dd9..f060763 100755
--- a/scripts/mkcompile_h
+++ b/scripts/mkcompile_h
@@ -66,9 +66,13 @@ UTS_TRUNCATE="sed -e s/\(.\{1,$UTS_LEN\}\).*/\1/"
   echo \#define LINUX_COMPILE_HOST \"`hostname | $UTS_TRUNCATE`\"
 
   if [ -x /bin/dnsdomainname ]; then
-    echo \#define LINUX_COMPILE_DOMAIN \"`dnsdomainname | $UTS_TRUNCATE`\"
+    domain=`dnsdomainname 2> /dev/null`
   elif [ -x /bin/domainname ]; then
-    echo \#define LINUX_COMPILE_DOMAIN \"`domainname | $UTS_TRUNCATE`\"
+    domain=`domainname 2> /dev/null`
+  fi
+
+  if [ -n "$domain" ]; then
+    echo \#define LINUX_COMPILE_DOMAIN \"`echo $domain | $UTS_TRUNCATE`\"
   else
     echo \#define LINUX_COMPILE_DOMAIN
   fi
-- 
1.6.5.rc1

