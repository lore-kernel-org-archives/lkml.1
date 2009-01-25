Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbZAYNJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbZAYNJt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 08:09:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbZAYNJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 08:09:41 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:5186 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbZAYNJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 08:09:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JRo2pBKWIOQdaL2MRF55Ql9trjbq1ur+zHKZR3VDIY3wD7jyu5RRUtBaeetbuU3WbQ
         fxaxX9OS0zQLCjGwy+wB5gShuIS6aQ91TcpcHau1tQU3PqFLCK3vVs0dXJupSVgSErHC
         IQ4S7idsCryRy8acl00QQjXnaSKFBlfnVctZw=
Date: Sun, 25 Jan 2009 18:39:12 +0530
From: Rabin Vincent <rabin@rab.in>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] kbuild: add sys_* entries for syscalls in tags
Message-ID: <20090125130912.GA21034@debian>
References: <20090125100553.GA18239@debian> <20090125111856.GA3268@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090125111856.GA3268@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, it is no longer possible to use the tags file to jump to
system call function definitions with sys_foo, because the definitions
are obscured by use of the SYSCALL_DEFINE* macros.

This patch adds the appropriate option to ctags to make it see through
the macro.  Also, it adds the ENTRY() work already done for Exuberant
to Emacs too.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
This version of the patch makes the modifications for emacs too.

 scripts/tags.sh |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index fdbe78b..fe7c99d 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -99,7 +99,8 @@ exuberant()
 	-I ____cacheline_internodealigned_in_smp                \
 	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL                      \
 	--extra=+f --c-kinds=+px                                \
-	--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'
+	--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'                  \
+	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--langdef=kconfig --language-force=kconfig              \
@@ -117,7 +118,9 @@ exuberant()
 
 emacs()
 {
-	all_sources | xargs $1 -a
+	all_sources | xargs $1 -a                               \
+	--regex='/^ENTRY(\([^)]*\)).*/\1/'                      \
+	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'
-- 
1.5.6.5

