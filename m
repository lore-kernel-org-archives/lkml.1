Return-Path: <linux-kernel-owner+w=401wt.eu-S1762709AbZCTX36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762709AbZCTX36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762941AbZCTXY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:29 -0400
Received: from kroah.org ([198.145.64.141]:48564 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762929AbZCTXY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:28 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:24 2009
Message-Id: <20090320222924.649248510@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [patch 11/43] nfsd: nfsd should drop CAP_MKNOD for non-root
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=nfsd-nfsd-should-drop-cap_mknod-for-non-root.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: J. Bruce Fields <bfields@citi.umich.edu>

commit 76a67ec6fb79ff3570dcb5342142c16098299911 upstream.

Since creating a device node is normally an operation requiring special
privilege, Igor Zhbanov points out that it is surprising (to say the
least) that a client can, for example, create a device node on a
filesystem exported with root_squash.

So, make sure CAP_MKNOD is among the capabilities dropped when an nfsd
thread handles a request from a non-root user.

Reported-by: Igor Zhbanov <izh1979@gmail.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/capability.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -382,8 +382,10 @@ typedef struct kernel_cap_struct {
 # define CAP_FULL_SET     ((kernel_cap_t){{ ~0, ~0 }})
 # define CAP_INIT_EFF_SET ((kernel_cap_t){{ ~CAP_TO_MASK(CAP_SETPCAP), ~0 }})
 # define CAP_FS_SET       ((kernel_cap_t){{ CAP_FS_MASK_B0, CAP_FS_MASK_B1 } })
-# define CAP_NFSD_SET     ((kernel_cap_t){{ CAP_FS_MASK_B0|CAP_TO_MASK(CAP_SYS_RESOURCE), \
-					CAP_FS_MASK_B1 } })
+# define CAP_NFSD_SET     ((kernel_cap_t){{ CAP_FS_MASK_B0 \
+					    | CAP_TO_MASK(CAP_SYS_RESOURCE) \
+					    | CAP_TO_MASK(CAP_MKNOD), \
+					    CAP_FS_MASK_B1 } })
 
 #endif /* _KERNEL_CAPABILITY_U32S != 2 */
 


