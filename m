Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbXLJTDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbXLJTDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 14:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbXLJTDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 14:03:25 -0500
Received: from mx1.riseup.net ([204.13.164.18]:52196 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbXLJTDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 14:03:24 -0500
Date: Mon, 10 Dec 2007 20:03:23 +0100
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fs/sysfs/file.c: use DEFINE_SPINLOCK for
	sysfs_open_dirent_lock definition
Message-ID: <20071210190323.GB20186@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/sysfs/file.c: use DEFINE_SPINLOCK for definition of
sysfs_open_dirent_lock instead of assigning SPIN_LOCK_UNLOCKED

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 4045bdc..09a0611 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -66,7 +66,7 @@ static struct sysfs_ops subsys_sysfs_ops = {
  * sysfs_dirent->s_attr.open points to sysfs_open_dirent.  s_attr.open
  * is protected by sysfs_open_dirent_lock.
  */
-static spinlock_t sysfs_open_dirent_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(sysfs_open_dirent_lock);
 
 struct sysfs_open_dirent {
 	atomic_t		refcnt;
 
-- 
Matthias Kaehlcke
Linux System Developer
Barcelona

     La libertad es como la mañana. Hay quienes esperan dormidos a que
   llegue, pero hay quienes desvelan y caminan la noche para alcanzarla
                        (Subcomandante Marcos)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
