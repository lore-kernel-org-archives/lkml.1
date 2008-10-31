Return-Path: <linux-kernel-owner+w=401wt.eu-S1752711AbYJaR0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbYJaR0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 13:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYJaR0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 13:26:32 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:26018 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbYJaR0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 13:26:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=rozCywWC3X1yLT+MR/HobzD9+U6tKg0DDQyCXhpFPBYu9DtMMAp/FsRgL81I29f5Tk
         +BrwSio/3IoslINdrzBTX9RlUjpuNgCsxQDiSF1wajIEyrDDtSfkSGy5erI/QBNCPZLO
         NeeiCiXrAVZ9cxhI6Zly37BUK8vdvccExWCeE=
Date: Fri, 31 Oct 2008 20:29:38 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: sam@ravnborg.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tags: link from CONFIG_x to 'config x' as well
Message-ID: <20081031172938.GA13896@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inability to jump from CONFIG_ symbol in source to symbol definition in 
Kconfig is very, very annoying. You'll jump to useless entry in autoconf.h,
if it exists at all.

No more.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 Makefile |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Makefile
+++ b/Makefile
@@ -1482,6 +1482,10 @@ define xtags
 		--langdef=kconfig \
 		--language-force=kconfig \
 		--regex-kconfig='/^[[:blank:]]*(menu|)config[[:blank:]]+([[:alnum:]_]+)/\2/'; \
+	    $(all-kconfigs) | xargs $1 -a \
+		--langdef=kconfig \
+		--language-force=kconfig \
+		--regex-kconfig='/^[[:blank:]]*(menu|)config[[:blank:]]+([[:alnum:]_]+)/CONFIG_\2/'; \
 	    $(all-defconfigs) | xargs -r $1 -a \
 		--langdef=dotconfig \
 		--language-force=dotconfig \
@@ -1490,6 +1494,8 @@ define xtags
 	    $(all-sources) | xargs $1 -a; \
 	    $(all-kconfigs) | xargs $1 -a \
 		--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'; \
+	    $(all-kconfigs) | xargs $1 -a \
+		--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/CONFIG_\3/'; \
 	    $(all-defconfigs) | xargs -r $1 -a \
 		--regex='/^#?[ \t]?\(CONFIG_[a-zA-Z0-9_]+\)/\1/'; \
 	else \
