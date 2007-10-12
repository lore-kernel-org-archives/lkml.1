Return-Path: <linux-kernel-owner+w=401wt.eu-S1761076AbXJLRTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761076AbXJLRTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762699AbXJLRTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:19:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762621AbXJLRTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:19:03 -0400
Date: Fri, 12 Oct 2007 18:18:58 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jesper Juhl <jesper.juhl@gmail.com>
Subject: [2.6.24 PATCH 13/25] dm io:ctl remove vmalloc void cast
Message-ID: <20071012171858.GY24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Jesper Juhl <jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jesper.juhl@gmail.com>

In drivers/md/dm-ioctl.c::copy_params() there's a call to vmalloc()
where we currently cast the return value, but that's pretty pointless
given that vmalloc() returns "void *".

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-ioctl.c	2007-10-12 13:15:29.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-ioctl.c	2007-10-12 13:18:07.000000000 +0100
@@ -1358,7 +1358,7 @@ static int copy_params(struct dm_ioctl _
 	if (tmp.data_size < sizeof(tmp))
 		return -EINVAL;
 
-	dmi = (struct dm_ioctl *) vmalloc(tmp.data_size);
+	dmi = vmalloc(tmp.data_size);
 	if (!dmi)
 		return -ENOMEM;
 
