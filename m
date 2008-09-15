Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbYIOQAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbYIOQAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 12:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbYIOQAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 12:00:42 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:64886 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbYIOQAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 12:00:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=AHOAr3VEmLJFO2tKstcFiDHBO8AdJSjbTYmgLGMTfvMCBecXMVH56JqujeAKe9dzh1
         vld2j0ONzWDX0nDAcqRBk1gF93Up4cQe8mFQg6bI+9ZnCbUyt6HQdb/Onz8sS1y17wbg
         jlBgBTX+w/jbeyZlhjBGQTbRN8NWuRajHHOOc=
Date: Mon, 15 Sep 2008 20:02:39 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: sam@ravnborg.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tags: skip ./ in filenames
Message-ID: <20080915160239.GA6143@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This drives size of tags file from 68.9 MB down to 67.7 MB.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -1450,7 +1450,7 @@ define find-sources
 	       -name $1 -print; \
 	  find $(__srctree) $(RCS_FIND_IGNORE) \
 	       \( -name include -o -name arch -o -name '.tmp_*' \) -prune -o \
-	       -name $1 -print; \
+	       -name $1 -print | sed -e 's#^./##'; \
 	  )
 endef
 
