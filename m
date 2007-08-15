Return-Path: <linux-kernel-owner+w=401wt.eu-S1764506AbXHOVi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764506AbXHOVi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 17:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbXHOViv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 17:38:51 -0400
Received: from nef2.ens.fr ([129.199.96.40]:1395 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbXHOViu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 17:38:50 -0400
Date: Wed, 15 Aug 2007 23:38:25 +0200
From: Nicolas George <nicolas.george@normalesup.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH] UML: BLKGETSIZE takes a long, not an int
Message-ID: <20070815213825.GA26490@clipper.ens.fr>
References: <20070813124247.GA7414@she-seel.salle-s.org> <20070815171247.GA7948@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070815171247.GA7948@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Wed, 15 Aug 2007 23:38:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The BLKGETSIZE ioctl expects a pointer to a long, os_file_size was providing
an int. Therefore, ubd access to host block devices caused a segmentation
fault on 64 bits systems.

Signed-off-by: Nicolas George <nicolas.george@normalesup.org>

---

Jeff Dike wrote:
> Looks sane, can I have a properly Signed-off-by: version of the patch?

Of course. I should have sent it correctly the first time. And I am terribly
sorry for the mess my mailer have done with my second mail.

Here is the hopefully correct patch, against current git.

Regards.

diff --git a/arch/um/os-Linux/file.c b/arch/um/os-Linux/file.c
index 6f92f73..c3ecc2a 100644
--- a/arch/um/os-Linux/file.c
+++ b/arch/um/os-Linux/file.c
@@ -320,7 +320,8 @@ int os_file_size(char *file, unsigned long long *size_out)
 	}
 
 	if(S_ISBLK(buf.ust_mode)){
-		int fd, blocks;
+		int fd;
+		long blocks;
 
 		fd = os_open_file(file, of_read(OPENFLAGS()), 0);
 		if(fd < 0){
