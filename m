Return-Path: <linux-kernel-owner+w=401wt.eu-S1422809AbXCOBVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422809AbXCOBVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 21:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422812AbXCOBVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 21:21:04 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:61674 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422809AbXCOBVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 21:21:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=nJkaMbCT/Ss/k4SEzJwb7XkK6BFC2oh6n2mKu0CfqqYOTqc49Pt+li77hx/Jc4j/GhvrpjhwP+GzqL7zDZLy5o8po0KosQSOR9iR3OIbgrXhzTA9973qVNmpsIIBGCk5egGQr0AMrybSZHGOgksjGgWYgdFJTmC3dSJay57hGvk=
Message-ID: <f2b55d220703141820o6725215ei20048737e1a81dcc@mail.gmail.com>
Date: Wed, 14 Mar 2007 18:20:57 -0700
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: do_acct_process bypasses vfs_write?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

do_acct_process (in kernel/acct.c) bypasses vfs_write and calls
file->f_op->write directly.  It therefore bypasses various sanity
checks, some of which appear applicable (notably inode->i_flock &&
MANDATORY_LOCK(inode)) and others of which do not (oversize request,
access_ok, etc.).  It also neglects to call
fsnotify_modify(file->f_path.dentry) after a successful write, which
may or may not matter.

Perhaps someone more knowledgeable than I could go through vfs_read
and vfs_write, distinguishing between those checks which are only
applicable to requests initiated from userspace and those which should
also be performed for in-kernel uses of f_op->read/write?

Cheers,
- Michael
