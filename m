Return-Path: <linux-kernel-owner+w=401wt.eu-S932305AbZHMUAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbZHMUAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932288AbZHMUAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:00:05 -0400
Received: from kroah.org ([198.145.64.141]:41910 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246AbZHMUAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:00:01 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:33 2009
Message-Id: <20090813195133.025035073@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Sandeen <sandeen@redhat.com>, <linux-ext4@vger.kernel.org>,
       Mark Lord <lkml@rtr.ca>, Arnd Bergmann <arnd@arndb.de>,
       Josef Bacik <josef@redhat.com>, Jan Kara <jack@suse.cz>
Subject: [patch 57/74] compat_ioctl: hook up compat handler for FIEMAP ioctl
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=compat_ioctl-hook-up-compat-handler-for-fiemap-ioctl.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit 69130c7cf96ea853dc5be599dd6a4b98907d39cc upstream.

The FIEMAP_IOC_FIEMAP mapping ioctl was missing a 32-bit compat handler,
which means that 32-bit suerspace on 64-bit kernels cannot use this ioctl
command.

The structure is nicely aligned, padded, and sized, so it is just this
simple.

Tested w/ 32-bit ioctl tester (from Josef) on a 64-bit kernel on ext4.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Cc: Mark Lord <lkml@rtr.ca>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Josef Bacik <josef@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/compat_ioctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1915,6 +1915,7 @@ COMPATIBLE_IOCTL(FIONCLEX)
 COMPATIBLE_IOCTL(FIOASYNC)
 COMPATIBLE_IOCTL(FIONBIO)
 COMPATIBLE_IOCTL(FIONREAD)  /* This is also TIOCINQ */
+COMPATIBLE_IOCTL(FS_IOC_FIEMAP)
 /* 0x00 */
 COMPATIBLE_IOCTL(FIBMAP)
 COMPATIBLE_IOCTL(FIGETBSZ)


