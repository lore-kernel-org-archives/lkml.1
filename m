Return-Path: <linux-kernel-owner+w=401wt.eu-S1752114AbYHKJ0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbYHKJ0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 05:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbYHKJZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 05:25:53 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:65062 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYHKJZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 05:25:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=OLV6+1Q0vABTQK5GtrX6di4YYIw3CcCc0maSBRDP7eTwmeI1FGs3teEHI/twobKlrg
         WTT3aeMByHsac8TxYLTRnmuiI2wj5EA01Qcnjv3BhGNscfo73VeBqkLBCAJ4x9VU6RV3
         gjj0A+FpfrQMMD6pGvp+2sVlOIlEbgku6Vuds=
Message-ID: <b9df5fa10808110225r2772ab62w155fdec7af5759d8@mail.gmail.com>
Date: Mon, 11 Aug 2008 15:25:51 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "Paul Menage" <menage@google.com>, "Paul Jackson" <pj@sgi.com>
Subject: [PATCH] cgroup.c: remove goto statement from cgroup_init.
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone, following patch removes the use of goto statement.
Actually, we don't need it. Beacuse, if "err < 0", then it will never
be TRUE. So, we can skip the goto statement and can just return.
Thanks.

Signed-off-by: Rakib Mullick (rakib.mullick@gmail.com)

--- linux-2.6.27-rc2.orig/kernel/cgroup.c	2008-08-11 15:16:49.000000000 +0600
+++ linux-2.6.27-rc2/kernel/cgroup.c	2008-08-11 15:16:26.000000000 +0600
@@ -2562,11 +2562,10 @@ int __init cgroup_init(void)

 	err = register_filesystem(&cgroup_fs_type);
 	if (err < 0)
-		goto out;
+		return err;

 	proc_create("cgroups", 0, NULL, &proc_cgroupstats_operations);

-out:
 	if (err)
 		bdi_destroy(&cgroup_backing_dev_info);
