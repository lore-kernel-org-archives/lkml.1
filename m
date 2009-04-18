Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbZDRL02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbZDRL02 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 07:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZDRL0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 07:26:19 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:58336 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbZDRL0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 07:26:19 -0400
Date: Sat, 18 Apr 2009 11:30:56 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: [PATCH] <linux/seccomp.h> needs to include <linux/errno.h>.
Message-ID: <20090418093056.GA17056@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<linux/seccomp.h> uses EINVAL so should include <linux/errno.h>.  This
fixes a build error on 64-bit MIPS if CONFIG_SECCOMP is disabled.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 include/linux/seccomp.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 262a8dc..167c333 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -21,6 +21,8 @@ extern long prctl_set_seccomp(unsigned long);
 
 #else /* CONFIG_SECCOMP */
 
+#include <linux/errno.h>
+
 typedef struct { } seccomp_t;
 
 #define secure_computing(x) do { } while (0)
