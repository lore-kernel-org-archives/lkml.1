Return-Path: <linux-kernel-owner+w=401wt.eu-S1757707AbZBFOXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707AbZBFOXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 09:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbZBFOX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:23:27 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:45757 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268AbZBFOXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:23:25 -0500
Message-ID: <498C47D4.1010305@in.ibm.com>
Date: Fri, 06 Feb 2009 19:53:16 +0530
From: "Sachin P. Sant" <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-s390@vger.kernel.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       Mel Gorman <mel@csn.ul.ie>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [Patch] Remove remaining ref to proc_dir_entry::owner
References: <498C03E1.1040204@in.ibm.com> <20090207000636.ee67c759.sfr@canb.auug.org.au>
In-Reply-To: <20090207000636.ee67c759.sfr@canb.auug.org.au>
Content-Type: multipart/mixed;
 boundary="------------000109000202070209030003"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000109000202070209030003
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Thanks Stephen.

Here is a patch to fix this issue.

* Remove remaining references to struct proc_dir_entry::owner

Signed-off-by : Sachin Sant <sachinp@in.ibm.com>
Cc : Alexey Dobriyan <adobriyan@gmail.com>
---

Thanks
-Sachin



--------------000109000202070209030003
Content-Type: text/x-patch;
 name="remove-remaining-proc-dir-entry-owner-refs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="remove-remaining-proc-dir-entry-owner-refs.patch"

* Remove remaining references to struct proc_dir_entry::owner

Signed-off-by : Sachin Sant <sachinp@in.ibm.com>
Cc : Alexey Dobriyan <adobriyan@gmail.com>
---

diff -Naurp a/drivers/s390/block/dasd_proc.c b/drivers/s390/block/dasd_proc.c
--- a/drivers/s390/block/dasd_proc.c	2009-02-06 21:58:57.000000000 +0530
+++ b/drivers/s390/block/dasd_proc.c	2009-02-06 22:01:48.000000000 +0530
@@ -318,7 +318,6 @@ dasd_proc_init(void)
 	dasd_proc_root_entry = proc_mkdir("dasd", NULL);
 	if (!dasd_proc_root_entry)
 		goto out_nodasd;
-	dasd_proc_root_entry->owner = THIS_MODULE;
 	dasd_devices_entry = proc_create("devices",
 					 S_IFREG | S_IRUGO | S_IWUSR,
 					 dasd_proc_root_entry,
@@ -332,7 +331,6 @@ dasd_proc_init(void)
 		goto out_nostatistics;
 	dasd_statistics_entry->read_proc = dasd_statistics_read;
 	dasd_statistics_entry->write_proc = dasd_statistics_write;
-	dasd_statistics_entry->owner = THIS_MODULE;
 	return 0;
 
  out_nostatistics:

--------------000109000202070209030003--
