Return-Path: <linux-kernel-owner+w=401wt.eu-S1760101AbXJLSEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101AbXJLSEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 14:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759255AbXJLSDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 14:03:44 -0400
Received: from 193.4.221.87.dynamic.jazztel.es ([87.221.4.193]:51887 "EHLO
	traven.no-ip.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761456AbXJLSDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 14:03:43 -0400
Date: Fri, 12 Oct 2007 19:52:10 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/2] fs/sysfs/dir.c: use DEFINE_SPINLOCK for spinlock
	definition
Message-ID: <20071012175210.GD3564@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fs/sysfs/dir.c: Define spinlock using DEFINE_SPINLOCK instead of
assignment to SPIN_LOCK_UNLOCKED

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 83e76b3..94fd78f 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -15,9 +15,9 @@
 #include "sysfs.h"
 
 DEFINE_MUTEX(sysfs_mutex);
-spinlock_t sysfs_assoc_lock = SPIN_LOCK_UNLOCKED;
+DEFINE_SPINLOCK(sysfs_assoc_lock);
 
-static spinlock_t sysfs_ino_lock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(sysfs_ino_lock);
 static DEFINE_IDA(sysfs_ino_ida);
 
 /**

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

             If liberty means anything at all, it means the
           right to tell people what they do not want to hear
                            (George Orwell)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
