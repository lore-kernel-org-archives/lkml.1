Return-Path: <linux-kernel-owner+w=401wt.eu-S1759317AbYBEQZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbYBEQZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758261AbYBEQZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:25:09 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:46846 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758095AbYBEQZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:25:07 -0500
From: Jim Meyering <jim@meyering.net>
To: Jeff Dike <jdike@addtoit.com>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] uml: handle unusual results from find_tempdir.
Date: Tue, 05 Feb 2008 17:25:06 +0100
Message-ID: <87d4rb8j6l.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


An alternative: make find_tempdir set tempdir to default_tempdir
upon malloc failure.

* arch/um/os-Linux/mem.c (make_tempfile): Handle NULL tempdir.
Don't let a long tempdir (e.g., via TMPDIR) provoke heap corruption.

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
 arch/um/os-Linux/mem.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/um/os-Linux/mem.c b/arch/um/os-Linux/mem.c
index e114d09..1458385 100644
--- a/arch/um/os-Linux/mem.c
+++ b/arch/um/os-Linux/mem.c
@@ -176,6 +176,9 @@ int __init make_tempfile(const char *template, char **out_tempname,
 	  return -1;

 	find_tempdir();
+	if (tempdir == NULL || strlen(tempdir) >= MAXPATHLEN)
+	  return -1;
+
 	if (template[0] != '/')
 		strcpy(tempname, tempdir);
 	else
--
1.5.4.19.gd3dfd
