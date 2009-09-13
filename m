Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbZIMTjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbZIMTjQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 15:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbZIMTjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 15:39:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:36490 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbZIMTjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 15:39:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PJstImP8ssm8cidEhUoFjVUpTHtm4JKuffHBWR1lbKANgXRj6pljNjJqx/hyevzrLX
         AFFaCwJLcr2/Qxfdalf+MmnlBCY1xpZgaiYaZwBOjkaBJPA31Mm/BesBZMGjkzjfP/lc
         bB17lYzIoeQmJ4ZXLS/ZkxIF9Cq+uU7ZGzOt0=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 2/5] kbuild: fix warning when domainname is not available
Date: Sun, 13 Sep 2009 22:38:24 +0300
Message-Id: <1252870707-4824-3-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1252870707-4824-2-git-send-email-felipe.contreras@gmail.com>
References: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com>
 <1252870707-4824-2-git-send-email-felipe.contreras@gmail.com>
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
index 6a12dd9..2e09f4a 100755
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
+  if $domain; then
+    echo \#define LINUX_COMPILE_DOMAIN \"`echo $domain | $UTS_TRUNCATE`\"
   else
     echo \#define LINUX_COMPILE_DOMAIN
   fi
-- 
1.6.5.rc1

