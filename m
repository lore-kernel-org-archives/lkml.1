Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbYFHSRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbYFHSRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 14:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbYFHSRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 14:17:12 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:51211 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753545AbYFHSRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 14:17:11 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: linux-kernel@vger.kernel.org
Subject: [PATCH] include/linux/msdos_fs.h: Cleanup include/linux/msdos_fs.h for userspace.
Date: Sun, 8 Jun 2008 21:16:48 +0300
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frank Seidel <fseidel@suse.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Onur =?utf-8?q?K=C3=BC=C3=A7=C3=BCk?= <onur@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200806082116.50355.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/msdos_fs.h header should use __u## rather than u## types else any userspace code (like syslinux) includes that header fails to compile like following;

[...]
gcc -Wp,-MT,bootsect_bin.o,-MMD,.bootsect_bin.o.d -W -Wall -D_FILE_OFFSET_BITS=64 -g -Os -I. -I.. -I../libinstaller -c -o bootsect_bin.o ../bootsect_bin.c
gcc -Wp,-MT,ldlinux_bin.o,-MMD,.ldlinux_bin.o.d -W -Wall -D_FILE_OFFSET_BITS=64 -g -Os -I. -I.. -I../libinstaller -c -o ldlinux_bin.o ../ldlinux_bin.c
In file included from syslinux.c:52:
/usr/include/linux/msdos_fs.h:61: error: expected ')' before 'media'
[...]

Noticed by Onur Küçük <onur@pardus.org.tr>

Cc: Frank Seidel <fseidel@suse.de>
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Onur Küçük <onur@pardus.org.tr>

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

 include/linux/msdos_fs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/msdos_fs.h b/include/linux/msdos_fs.h
index b03b274..3825b1c 100644
--- a/include/linux/msdos_fs.h
+++ b/include/linux/msdos_fs.h
@@ -58,7 +58,7 @@
 #define MSDOS_DOTDOT	"..         "	/* "..", padded to MSDOS_NAME chars */
 
 /* media of boot sector */
-static inline int fat_valid_media(u8 media)
+static inline int fat_valid_media(__u8 media)
 {
 	return 0xf8 <= media || media == 0xf0;
 }

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
