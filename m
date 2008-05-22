Return-Path: <linux-kernel-owner+w=401wt.eu-S935970AbYEVNaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935970AbYEVNaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 09:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760382AbYEVNaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 09:30:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758780AbYEVN37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 09:29:59 -0400
Date: Thu, 22 May 2008 09:07:22 -0400
From: Dave Jones <davej@redhat.com>
To: Steve French <sfrench@us.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [CIFS] Fix reversed memset arguments.
Message-ID: <20080522130722.GA21163@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steve French <sfrench@us.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

size is the 3rd argument.

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6/fs/cifs/inode.c~	2008-05-22 09:05:31.000000000 -0400
+++ linux-2.6/fs/cifs/inode.c	2008-05-22 09:05:58.000000000 -0400
@@ -172,7 +172,7 @@ static void fill_fake_finddataunix(FILE_
 {
 	struct inode *pinode = NULL;
 
-	memset(pfnd_dat, sizeof(FILE_UNIX_BASIC_INFO), 0);
+	memset(pfnd_dat, 0, sizeof(FILE_UNIX_BASIC_INFO));
 
 /*	__le64 pfnd_dat->EndOfFile = cpu_to_le64(0);
 	__le64 pfnd_dat->NumOfBytes = cpu_to_le64(0);
@@ -384,7 +384,7 @@ static int get_sfu_mode(struct inode *in
 static void fill_fake_finddata(FILE_ALL_INFO *pfnd_dat,
 			       struct super_block *sb)
 {
-	memset(pfnd_dat, sizeof(FILE_ALL_INFO), 0);
+	memset(pfnd_dat, 0, sizeof(FILE_ALL_INFO));
 
 /*	__le64 pfnd_dat->AllocationSize = cpu_to_le64(0);
 	__le64 pfnd_dat->EndOfFile = cpu_to_le64(0);
-- 
http://www.codemonkey.org.uk
