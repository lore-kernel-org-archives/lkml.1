Return-Path: <linux-kernel-owner+w=401wt.eu-S933360AbXAaX5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360AbXAaX5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 18:57:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933361AbXAaX5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 18:57:13 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59630 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933360AbXAaX5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 18:57:12 -0500
Date: Wed, 31 Jan 2007 15:56:51 -0800
From: Andrew Morton <akpm@osdl.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Roman Zippel <zippel@linux-m68k.org>,
       Bastian Blank <bastian@waldi.eu.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch] kbuild: correctly skip tilded backups in localversion
 files
Message-Id: <20070131155651.529e933c.akpm@osdl.org>
In-Reply-To: <20070131071103.GA3295@flower.upol.cz>
References: <20070131071103.GA3295@flower.upol.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007 07:11:04 +0000
Oleg Verych <olecom@flower.upol.cz> wrote:

> kbuild: correctly skip tilded backups in localversion files

Does this patch replace Bastian's patch, below?


From: Bastian Blank <bastian@waldi.eu.org>

Fix the problem that localversion files were ignored if the tree lives in
a path which contains a ~.  It changes the test to apply to the filename
only.

Debian allows versions which contains ~ in it.  The upstream part of the
version is in the directory name of the build tree and we got weird results
because the localversion files was just got ignored in this case.

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Makefile |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN Makefile~kbuild-dont-ignore-localversion-files-if-the-path-includes-a Makefile
--- a/Makefile~kbuild-dont-ignore-localversion-files-if-the-path-includes-a
+++ a/Makefile
@@ -793,7 +793,7 @@ space      := $(nullstring) # end of lin
 ___localver = $(objtree)/localversion* $(srctree)/localversion*
 __localver  = $(sort $(wildcard $(___localver)))
 # skip backup files (containing '~')
-_localver = $(foreach f, $(__localver), $(if $(findstring ~, $(f)),,$(f)))
+_localver = $(foreach f, $(__localver), $(if $(findstring ~, $(notdir $(f))),,$(f)))
 
 localver = $(subst $(space),, \
 	   $(shell cat /dev/null $(_localver)) \
_

