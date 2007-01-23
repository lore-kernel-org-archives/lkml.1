Return-Path: <linux-kernel-owner+w=401wt.eu-S932904AbXAWSUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904AbXAWSUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 13:20:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933101AbXAWSUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 13:20:07 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:24541 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932904AbXAWSUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 13:20:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Kd8Sqj6kZ96QpsxaKDdncDaU3Qq1gBH9lvCdWzOBbuf+GKgL67thijjpqX3Rezmt7xqLdZtbFVyhIDib2009ynNOvWPAJVaOrHTf8c/+teIxtvrcrV+MBL28pFJxYN9/LiVNAbm6Nw+eZrFHBtqcqpDSCw8nOm7t9L6K5zebOug=
Message-ID: <52dd17640701231020s2ce96f09kc134cdb4432b154f@mail.gmail.com>
Date: Tue, 23 Jan 2007 12:20:04 -0600
From: "Guy Streeter" <guy.streeter@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] correct sys_shmget allocation check
Cc: torvalds@osdl.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As written, sys_shmget will return ENOSPC when one page is still
available for allocation. This patch corrects the test.

Signed-off-by: Guy Streeter <guy.streeter+lkml@gmail.com>

--

Index: linux-2.6/ipc/shm.c
===================================================================
--- linux-2.6.orig/ipc/shm.c
+++ linux-2.6/ipc/shm.c
@@ -279,7 +279,7 @@ static int newseg (struct ipc_namespace
       if (size < SHMMIN || size > ns->shm_ctlmax)
               return -EINVAL;

-       if (ns->shm_tot + numpages >= ns->shm_ctlall)
+       if (ns->shm_tot + numpages > ns->shm_ctlall)
               return -ENOSPC;

       shp = ipc_rcu_alloc(sizeof(*shp));
