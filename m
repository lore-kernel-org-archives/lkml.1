Return-Path: <linux-kernel-owner+w=401wt.eu-S1759138AbZFYUGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138AbZFYUGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 16:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbZFYUGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 16:06:12 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45720 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbZFYUGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 16:06:11 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC] vfat: change the default from shortname=lower to shortname=mixed
Date: Fri, 26 Jun 2009 05:06:11 +0900
Message-ID: <87ws70ulho.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was asked like the following sometimes,

  Why is shortname=lower the default mount option for vfat filesystems?
  Because, with "shortname=lower", copying one FAT filesystem tree to
  another FAT filesystem tree using Liux results in semantically
  different filesystems. (E.g.: Filenames which were once "all
  uppercase" are now "all lowercase").

And from recently email 

  http://bugs.debian.org/476903
  http://bugs.debian.org/497121
  http://bugzilla.gnome.org/554031
  https://bugs.launchpad.net/ubuntu/+bug/290362


My usual answer for it is, personally I agree that "winnt" or "mixed"
is proper. However, it is long-standing default behavior. Um...

But, now, situation would not be same with long past (didn't have
shortname= option).

Well, so, what do you think about changing the default of vfat from
"shortname=lower" to "shortname=mixed"?  If default was changed, the
shortname (8.3) will not changed to lower case to show. And if possible,
it will try to preserve created shortname.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


This causes Linux and Windows to display filenames the same.

Signed-off-by: Paul Wise <pabs3@bonedaddy.net>

 Documentation/filesystems/vfat.txt |    2 +-
 fs/fat/inode.c                     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/vfat.txt b/Documentation/filesystems/vfat.txt
index b58b84b..eed520f 100644
--- a/Documentation/filesystems/vfat.txt
+++ b/Documentation/filesystems/vfat.txt
@@ -102,7 +102,7 @@ shortname=lower|win95|winnt|mixed
 		 winnt: emulate the Windows NT rule for display/create.
 		 mixed: emulate the Windows NT rule for display,
 			emulate the Windows 95 rule for create.
-		 Default setting is `lower'.
+		 Default setting is `mixed'.
 
 tz=UTC        -- Interpret timestamps as UTC rather than local time.
                  This option disables the conversion of timestamps
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 8970d8c..f9af501 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -971,7 +971,7 @@ static int parse_options(char *options, int is_vfat, int silent, int *debug,
 	opts->codepage = fat_default_codepage;
 	opts->iocharset = fat_default_iocharset;
 	if (is_vfat) {
-		opts->shortname = VFAT_SFN_DISPLAY_LOWER|VFAT_SFN_CREATE_WIN95;
+		opts->shortname = VFAT_SFN_DISPLAY_WINNT|VFAT_SFN_CREATE_WIN95;
 		opts->rodir = 0;
 	} else {
 		opts->shortname = 0;
-- 
1.6.3.1
