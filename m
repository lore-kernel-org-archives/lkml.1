Return-Path: <linux-kernel-owner+w=401wt.eu-S1760331AbXKBSBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760331AbXKBSBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 14:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbXKBSBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 14:01:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46186 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbXKBSBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 14:01:16 -0400
Date: Fri, 2 Nov 2007 10:38:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Young <hidave.darkstar@gmail.com>, Greg KH <greg@kroah.com>
Subject: [patch 6/9] param_sysfs_builtin memchr argument fix
Message-ID: <20071102173805.GG6378@kroah.com>
References: <20071102173359.709442489@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="param_sysfs_builtin-memchr-argument-fix.patch"
In-Reply-To: <20071102173733.GA6378@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Dave Young <hidave.darkstar@gmail.com>

patch faf8c714f4508207a9c81cc94dafc76ed6680b44 in mainline.

If memchr argument is longer than strlen(kp->name), there will be some
weird result.

It will casuse duplicate filenames in sysfs for the "nousb".  kernel
warning messages are as bellow:

sysfs: duplicate filename 'usbcore' can not be created
WARNING: at fs/sysfs/dir.c:416 sysfs_add_one()
 [<c01c4750>] sysfs_add_one+0xa0/0xe0
 [<c01c4ab8>] create_dir+0x48/0xb0
 [<c01c4b69>] sysfs_create_dir+0x29/0x50
 [<c024e0fb>] create_dir+0x1b/0x50
 [<c024e3b6>] kobject_add+0x46/0x150
 [<c024e2da>] kobject_init+0x3a/0x80
 [<c053b880>] kernel_param_sysfs_setup+0x50/0xb0
 [<c053b9ce>] param_sysfs_builtin+0xee/0x130
 [<c053ba33>] param_sysfs_init+0x23/0x60
 [<c024d062>] __next_cpu+0x12/0x20
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052a856>] do_initcalls+0x46/0x1e0
 [<c01bdb12>] create_proc_entry+0x52/0x90
 [<c0158d4c>] register_irq_proc+0x9c/0xc0
 [<c01bda94>] proc_mkdir_mode+0x34/0x50
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052aa92>] kernel_init+0x62/0xb0
 [<c0104f83>] kernel_thread_helper+0x7/0x14
 =======================
kobject_add failed for usbcore with -EEXIST, don't try to register things with the same name in the same directory.
 [<c024e466>] kobject_add+0xf6/0x150
 [<c053b880>] kernel_param_sysfs_setup+0x50/0xb0
 [<c053b9ce>] param_sysfs_builtin+0xee/0x130
 [<c053ba33>] param_sysfs_init+0x23/0x60
 [<c024d062>] __next_cpu+0x12/0x20
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052a856>] do_initcalls+0x46/0x1e0
 [<c01bdb12>] create_proc_entry+0x52/0x90
 [<c0158d4c>] register_irq_proc+0x9c/0xc0
 [<c01bda94>] proc_mkdir_mode+0x34/0x50
 [<c052aa30>] kernel_init+0x0/0xb0
 [<c052aa92>] kernel_init+0x62/0xb0
 [<c0104f83>] kernel_thread_helper+0x7/0x14
 =======================
Module 'usbcore' failed to be added to sysfs, error number -17
The system will be unstable now.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/params.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/kernel/params.c
+++ b/kernel/params.c
@@ -591,11 +591,17 @@ static void __init param_sysfs_builtin(v
 
 	for (i=0; i < __stop___param - __start___param; i++) {
 		char *dot;
+		size_t kplen;
 
 		kp = &__start___param[i];
+		kplen = strlen(kp->name);
 
 		/* We do not handle args without periods. */
-		dot = memchr(kp->name, '.', MAX_KBUILD_MODNAME);
+		if (kplen > MAX_KBUILD_MODNAME) {
+			DEBUGP("kernel parameter name is too long: %s\n", kp->name);
+			continue;
+		}
+		dot = memchr(kp->name, '.', kplen);
 		if (!dot) {
 			DEBUGP("couldn't find period in %s\n", kp->name);
 			continue;

-- 
