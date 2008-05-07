Return-Path: <linux-kernel-owner+w=401wt.eu-S1763698AbYEGHEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763698AbYEGHEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763516AbYEGHEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:04:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756718AbYEGHEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:04:35 -0400
Date: Wed, 07 May 2008 16:04:31 +0900 (JST)
Message-Id: <20080507.160431.251452611.yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: escape meta characters in regular expression in
 make TAGS
From: Masatake YAMATO <yamato@redhat.com>
Organization: Red Hat Japan, Inc.
X-Mailer: Mew version 5.2.52 on Emacs 22.0.51 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Alexey Dobriyan <adobriyan@gmail.com> introduced a code adds
menuconfig SOMETHING in Kconfig to tags output when you did "make tags".

See http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=80ff26241623875636674a31c0540a78c0fb5433

"make tags" may work fine with his code. However make TAGS doesn't work well
because etags command requires backslashes to escape meta characters like 
`(', `)' and `|'.

Here is a patch.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>

	
diff --git a/Makefile b/Makefile
index 4492984..d4aa437 100644
--- a/Makefile
+++ b/Makefile
@@ -1431,7 +1431,7 @@ define xtags
 	elif $1 --version 2>&1 | grep -iq emacs; then \
 	    $(all-sources) | xargs $1 -a; \
 	    $(all-kconfigs) | xargs $1 -a \
-		--regex='/^[ \t]*(menu|)config[ \t]+\([a-zA-Z0-9_]+\)/\2/'; \
+		--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'; \
 	    $(all-defconfigs) | xargs -r $1 -a \
 		--regex='/^#?[ \t]?\(CONFIG_[a-zA-Z0-9_]+\)/\1/'; \
 	else \
