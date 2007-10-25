Return-Path: <linux-kernel-owner+w=401wt.eu-S1760482AbXJYXO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760482AbXJYXO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbXJYXOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:14:18 -0400
Received: from smtp-out.google.com ([216.239.33.17]:18746 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbXJYXOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:14:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:cc:subject:content-disposition;
	b=fArgLWjMFTlxZTCmXMpLGSPbE3Tu5NilOv6zcvhPlkQr9Fbn2PCAEPpEhO+UVJYch
	96bIjhf0iOGDQzAeMgDnA==
Message-Id: <20071025230758.945535769@crlf.corp.google.com>
Date: Thu, 25 Oct 2007 16:06:40 -0700
From: Mike Waychison <mikew@google.com>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [patch 1/1] Drop CAP_SYS_RAWIO requirement for FIBMAP
Content-Disposition: inline; filename=drop_cap_sys_rawio_for_fibmap.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the need for having CAP_SYS_RAWIO when doing a FIBMAP call on an open file descriptor.

It would be nice to allow users to have permission to see where their data is landing on disk, and there really isn't a good reason to keep them from getting at this information.

Signed-off-by: Mike Waychison <mikew@google.com>
 fs/ioctl.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6.23/fs/ioctl.c
===================================================================
--- linux-2.6.23.orig/fs/ioctl.c	2007-10-09 13:31:38.000000000 -0700
+++ linux-2.6.23/fs/ioctl.c	2007-10-25 15:48:24.000000000 -0700
@@ -56,8 +56,6 @@ static int file_ioctl(struct file *filp,
 			/* do we support this mess? */
 			if (!mapping->a_ops->bmap)
 				return -EINVAL;
-			if (!capable(CAP_SYS_RAWIO))
-				return -EPERM;
 			if ((error = get_user(block, p)) != 0)
 				return error;
 

--

