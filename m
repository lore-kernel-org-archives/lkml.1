Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbZAYKGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbZAYKGa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 05:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbZAYKGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 05:06:22 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:28440 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbZAYKGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 05:06:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=UukwAbooWh1DfML4SJuU4FAjb77fNzTDFXerKoJz0sHeE+spUJtVTr9o1tqI6WlFtX
         KH1ADUMpKuOmZHvpJ8OfjEo2Va+SPqdyGVDOY0Nq6NBpS5P6vJouBA6jHcFjTaizNpiP
         +khCuf224uzx2Mufp3CdmBLVyZnRN7gVlYroE=
Date: Sun, 25 Jan 2009 15:35:54 +0530
From: Rabin Vincent <rabin@rab.in>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] kbuild: add sys_* entries for syscalls in tags
Message-ID: <20090125100553.GA18239@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, it is no longer possible to use the tags file to jump to
system call function definitions with sys_foo because the definitions
are obscured by the use of the SYSCALL_DEFINE* macros.

This patch adds the appropriate option to ctags to make it see through
the macro.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 scripts/tags.sh |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index fdbe78b..0d58f48 100755
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
-- 
1.5.6.5

