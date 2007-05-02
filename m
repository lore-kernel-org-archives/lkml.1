Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbXEBL6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbXEBL6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 07:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbXEBL6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 07:58:32 -0400
Received: from mog.warmcat.com ([62.193.232.24]:47703 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755115AbXEBL6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 07:58:31 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2007 07:58:31 EDT
Message-ID: <46387AB2.1090800@warmcat.com>
Date: Wed, 02 May 2007 12:49:06 +0100
From: Andy Green <andy@warmcat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] scripts/basic/fixdep segfault on pathological string-o-death
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

build scripts: fixdep blows segfault on string CONFIG_MODULE seen

The string "CONFIG_MODULE" appearing anywhere in a source file causes
fixdep to segfault.  This string appeared in the wild in the current
mISDN sources (I think they meant CONFIG_MODULES).  But it shouldn't
segfault (esp as CONFIG_MODULE appeared in a quoted string).

Signed-off-by: Andy Green <andy@warmcat.com>
---
 scripts/basic/fixdep.c |    2 ++
 1 file changed, 2 insertions(+)

Index: 2.6.21-1.3116.fc7-i686/scripts/basic/fixdep.c
===================================================================
--- 2.6.21-1.3116.fc7-i686.orig/scripts/basic/fixdep.c
+++ 2.6.21-1.3116.fc7-i686/scripts/basic/fixdep.c
@@ -249,6 +249,8 @@ void parse_config_file(char *map, size_t
 	found:
 		if (!memcmp(q - 7, "_MODULE", 7))
 			q -= 7;
+		if( (q-p-7) < 0 )
+			continue;
 		use_config(p+7, q-p-7);
 	}
 }
