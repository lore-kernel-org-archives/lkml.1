Return-Path: <linux-kernel-owner+w=401wt.eu-S1761600AbZDGVkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761600AbZDGVkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbZDGVkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:40:42 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:44555 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbZDGVkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:40:41 -0400
Date: Tue, 7 Apr 2009 23:40:39 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Teigland <teigland@redhat.com>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] dlm: Make name input parameter of {,dlm_}new_lockspace()
 const
Message-ID: <Pine.LNX.4.64.0904072340220.27188@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| fs/gfs2/lock_dlm.c:207: warning: passing argument 1 of 'dlm_new_lockspace' discards qualifiers from pointer target type

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/dlm/lockspace.c  |    4 ++--
 include/linux/dlm.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index cd8e2df..82528d9 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -384,7 +384,7 @@ static void threads_stop(void)
 	dlm_astd_stop();
 }
 
-static int new_lockspace(char *name, int namelen, void **lockspace,
+static int new_lockspace(const char *name, int namelen, void **lockspace,
 			 uint32_t flags, int lvblen)
 {
 	struct dlm_ls *ls;
@@ -614,7 +614,7 @@ static int new_lockspace(char *name, int namelen, void **lockspace,
 	return error;
 }
 
-int dlm_new_lockspace(char *name, int namelen, void **lockspace,
+int dlm_new_lockspace(const char *name, int namelen, void **lockspace,
 		      uint32_t flags, int lvblen)
 {
 	int error = 0;
diff --git a/include/linux/dlm.h b/include/linux/dlm.h
index b9cd386..0b3518c 100644
--- a/include/linux/dlm.h
+++ b/include/linux/dlm.h
@@ -81,8 +81,8 @@ struct dlm_lksb {
  * the cluster, the calling node joins it.
  */
 
-int dlm_new_lockspace(char *name, int namelen, dlm_lockspace_t **lockspace,
-		      uint32_t flags, int lvblen);
+int dlm_new_lockspace(const char *name, int namelen,
+		      dlm_lockspace_t **lockspace, uint32_t flags, int lvblen);
 
 /*
  * dlm_release_lockspace
-- 
1.6.2.1


Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
