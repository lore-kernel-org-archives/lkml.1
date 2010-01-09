Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775Ab0AIR1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab0AIR1F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 12:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738Ab0AIR1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 12:27:04 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:47993 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab0AIR1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 12:27:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=x0e3tlI4MbQa1K/S7LS7E+DwrF4Scr4fgpprKidJL5G4JPR+H6it5YRLGYuu3a1Uff
         Lr53K5nvFP9aIHK6GaCDbgb1wRbuAKbdw2n4iG2yJopvuOgGzkIjta5fmTR813nOvJQA
         7cDUIP7wtyjdYzCKUtTV1q9KSCtOkeodZmxA0=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: jdike@addtoit.com
Cc: linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] uml: fix memory leak in arch/um/os-Linux/mem.c
Date: Sat,  9 Jan 2010 20:26:24 +0300
Message-Id: <1263057984-12487-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free tempname before exit.
Found by cppcheck.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 arch/um/os-Linux/mem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/os-Linux/mem.c b/arch/um/os-Linux/mem.c
index 93a11d7..f079ea0 100644
--- a/arch/um/os-Linux/mem.c
+++ b/arch/um/os-Linux/mem.c
@@ -175,7 +175,7 @@ static int __init make_tempfile(const char *template, char **out_tempname,
 
 	find_tempdir();
 	if ((tempdir == NULL) || (strlen(tempdir) >= MAXPATHLEN))
-		return -1;
+		goto out;
 
 	if (template[0] != '/')
 		strcpy(tempname, tempdir);
-- 
1.6.6

