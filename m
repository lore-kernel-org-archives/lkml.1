Return-Path: <linux-kernel-owner+w=401wt.eu-S932162AbXJZXko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbXJZXko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 19:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764255AbXJZXiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 19:38:55 -0400
Received: from smtp-out.google.com ([216.239.33.17]:3379 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764049AbXJZXix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 19:38:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:date:from:to:cc:subject:content-disposition;
	b=MfuaLNISwI6PbsCYf0x5Ggzl9/7VfiX2QWTWC14UZ0ULsfGFXQAEb67orJL0THK0I
	3hoyp2BByvUikvfruH8fw==
Message-Id: <20071026233847.864038076@crlf.corp.google.com>
References: <20071026233732.568575496@crlf.corp.google.com>
Date: Fri, 26 Oct 2007 16:37:33 -0700
From: Mike Waychison <mikew@google.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mike Waychison <mikew@google.com>
Subject: [patch 1/6][RFC] Keep FIBMAP from looking at negative block nrs
Content-Disposition: inline; filename=fix_negative_fibmap_blocks.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Return an error if the user requests a negative logical block in a file.

Signed-off-by: Mike Waychison <mikew@google.com>
 fs/ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.23/fs/ioctl.c
===================================================================
--- linux-2.6.23.orig/fs/ioctl.c	2007-10-26 15:25:48.000000000 -0700
+++ linux-2.6.23/fs/ioctl.c	2007-10-26 16:16:29.000000000 -0700
@@ -60,6 +60,8 @@ static int file_ioctl(struct file *filp,
 				return -EPERM;
 			if ((error = get_user(block, p)) != 0)
 				return error;
+			if (block < 0)
+				return -EINVAL;
 
 			lock_kernel();
 			res = mapping->a_ops->bmap(mapping, block);

--
