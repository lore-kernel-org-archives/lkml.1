Return-Path: <linux-kernel-owner+w=401wt.eu-S1946456AbXEAEHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946456AbXEAEHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946599AbXEAEAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:00:47 -0400
Received: from mx1.suse.de ([195.135.220.2]:60951 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933454AbXEAD6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:20 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [21/30] x86_64: Print type and size correctly for unknown compat ioctls
Message-Id: <20070501035819.80FFC13CAF@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/compat.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux/fs/compat.c
===================================================================
--- linux.orig/fs/compat.c
+++ linux/fs/compat.c
@@ -371,13 +371,14 @@ static void compat_ioctl_error(struct fi
 			fn = "?";
 	}
 
-	sprintf(buf,"'%c'", (cmd>>24) & 0x3f);
+	sprintf(buf,"'%c'", (cmd>>_IOC_TYPESHIFT) & _IOC_TYPEMASK);
 	if (!isprint(buf[1]))
 		sprintf(buf, "%02x", buf[1]);
 	compat_printk("ioctl32(%s:%d): Unknown cmd fd(%d) "
-			"cmd(%08x){%s} arg(%08x) on %s\n",
+			"cmd(%08x){t:%s;sz:%u} arg(%08x) on %s\n",
 			current->comm, current->pid,
 			(int)fd, (unsigned int)cmd, buf,
+			(cmd >> _IOC_SIZESHIFT) & _IOC_SIZEMASK,
 			(unsigned int)arg, fn);
 
 	if (path)
