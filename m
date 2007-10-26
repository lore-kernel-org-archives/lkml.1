Return-Path: <linux-kernel-owner+w=401wt.eu-S932267AbXJZXlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbXJZXlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 19:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbXJZXi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 19:38:59 -0400
Received: from smtp-out.google.com ([216.239.45.13]:12222 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764224AbXJZXiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 19:38:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:date:from:to:cc:subject:content-disposition;
	b=BZyVO9mqulHYnXRtk2Up2oml5GQ2QvFbRBEIo+aICIOPei1VVpLcLUnAR0i3PxhY6
	XAxLCz9GSukm5BsmuPGNw==
Message-Id: <20071026233849.185498288@crlf.corp.google.com>
References: <20071026233732.568575496@crlf.corp.google.com>
Date: Fri, 26 Oct 2007 16:37:38 -0700
From: Mike Waychison <mikew@google.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mike Waychison <mikew@google.com>
Subject: [patch 6/6][RFC] Drop CAP_SYS_RAWIO requirement on FIBMAP
Content-Disposition: inline; filename=drop_cap_sys_rawio_for_fibmap.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the need for having CAP_SYS_RAWIO when doing a FIBMAP call on an open file descriptor.

It would be nice to allow users to have permission to see where their data is landing on disk, and there really isn't a good reason to keep them from getting at this information.

Signed-off-by: Mike Waychison <mikew@google.com>
 fs/ioctl.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6.23/fs/ioctl.c
===================================================================
--- linux-2.6.23.orig/fs/ioctl.c	2007-10-26 15:30:05.000000000 -0700
+++ linux-2.6.23/fs/ioctl.c	2007-10-26 15:31:43.000000000 -0700
@@ -46,9 +46,6 @@ static int do_fibmap(struct address_spac
 	struct inode *inode = mapping->host;
 	sector_t (*bmap)(struct address_space *, sector_t);
 
-	if (!capable(CAP_SYS_RAWIO))
-		return -EPERM;
-
 	if (mapping->a_ops->bmap64) {
 		/* Filesystem has bmap path audited for 64bit. */
 		bmap = mapping->a_ops->bmap64;

--
