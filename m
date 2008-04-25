Return-Path: <linux-kernel-owner+w=401wt.eu-S1765072AbYDYR6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765072AbYDYR6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 13:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764789AbYDYR5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:57:06 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53125 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764345AbYDYR5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:57:01 -0400
Date: Fri, 25 Apr 2008 13:56:10 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Cc: Johann Felix Soden <johfel@users.sourceforge.net>
Subject: [PATCH 10/19] UML - Fix errno return
Message-ID: <20080425175610.GA11190@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johann Felix Soden <johfel@users.sourceforge.net>

Error returns are negative.

Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/hostaudio_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22/arch/um/drivers/hostaudio_kern.c
===================================================================
--- linux-2.6.22.orig/arch/um/drivers/hostaudio_kern.c	2007-11-14 10:33:29.000000000 -0500
+++ linux-2.6.22/arch/um/drivers/hostaudio_kern.c	2008-02-13 12:36:26.000000000 -0500
@@ -154,7 +154,7 @@ static int hostaudio_ioctl(struct inode 
 	case SNDCTL_DSP_SUBDIVIDE:
 	case SNDCTL_DSP_SETFRAGMENT:
 		if (get_user(data, (int __user *) arg))
-			return EFAULT;
+			return -EFAULT;
 		break;
 	default:
 		break;
