Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbZDPByT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbZDPByT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 21:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbZDPByG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 21:54:06 -0400
Received: from exprod6og106.obsmtp.com ([64.18.1.191]:40205 "HELO
	exprod6og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751362AbZDPByF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 21:54:05 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] block/genhd.c: fix sparse warning
Date: Wed, 15 Apr 2009 21:53:54 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909015F8DFA@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] block/genhd.c: fix sparse warning
Thread-Index: Acm+NjJ1YN9GnToJSN2pigJH40T+OA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Apr 2009 01:54:02.0112 (UTC) FILETIME=[373E7000:01C9BE36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warning in block/genhd.c.

	warning: symbol '__mptr' shadows an earlier one

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/block/genhd.c b/block/genhd.c
index a9ec910..ca3eedb 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -576,8 +576,10 @@ struct gendisk *get_gendisk(dev_t devt, int
*partno)
 		struct kobject *kobj;
 
 		kobj = kobj_lookup(bdev_map, devt, partno);
-		if (kobj)
-			disk = dev_to_disk(kobj_to_dev(kobj));
+		if (kobj) {
+			struct device *dev = kobj_to_dev(kobj);
+			disk = dev_to_disk(dev);
+		}
 	} else {
 		struct hd_struct *part;
 
@@ -1010,7 +1012,7 @@ static int diskstats_show(struct seq_file *seqf,
void *v)
 				"wsect wuse running use aveq"
 				"\n\n");
 	*/
- 
+
 	disk_part_iter_init(&piter, gp, DISK_PITER_INCL_PART0);
 	while ((hd = disk_part_iter_next(&piter))) {
 		cpu = part_stat_lock();
@@ -1034,7 +1036,7 @@ static int diskstats_show(struct seq_file *seqf,
void *v)
 			);
 	}
 	disk_part_iter_exit(&piter);
- 
+
 	return 0;
 }
  
