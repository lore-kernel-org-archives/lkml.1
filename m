Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbZJLNIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbZJLNIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 09:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756585AbZJLNIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 09:08:12 -0400
Received: from mail.pawisda.de ([213.157.4.156]:58272 "EHLO
	mailrelay.pawisda.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756561AbZJLNIL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 09:08:11 -0400
Message-ID: <4AD32A14.3050408@lsexperts.de>
Date: Mon, 12 Oct 2009 15:07:32 +0200
From: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [Patch] Fix leak in usermode linux
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

this was spotted by cppcheck, if find_tempdir fails,
we dont free tempname.

Signed-off-by: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>

--- linux/arch/um/os-Linux/mem.c.orig	2009-10-12 15:04:28.000000000 +0200
+++ linux/arch/um/os-Linux/mem.c	2009-10-12 15:04:37.000000000 +0200
@@ -175,7 +175,7 @@ static int __init make_tempfile(const ch

 	find_tempdir();
 	if ((tempdir == NULL) || (strlen(tempdir) >= MAXPATHLEN))
-		return -1;
+		goto out;

 	if (template[0] != '/')
 		strcpy(tempname, tempdir);

-- 
LSE Leading Security Experts GmbH, Postfach 100121, 64201 Darmstadt
Unternehmenssitz: Weiterstadt, Amtsgericht Darmstadt: HRB8649
Geschäftsführer: Oliver Michel, Sven Walther

