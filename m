Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbYAFSI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbYAFSI4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 13:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbYAFSIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 13:08:47 -0500
Received: from mail.gmx.net ([213.165.64.20]:48570 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753748AbYAFSIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 13:08:47 -0500
X-Authenticated: #19095397
X-Provags-ID: V01U2FsdGVkX1/BuhVXsADBzhxj8tAmX/W44WXx9ONnv/2fWZA2Pj
	Bm/iWH999dELot
From: Bernd Schubert <bernd-schubert@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: sleep before boot panic
Date: Sun, 6 Jan 2008 19:08:42 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801061908.43010.bernd-schubert@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just switched to libata (pata) on my laptop and the immediate panic made it 
impossible to figure out why my boot partition wasn't available.
After applying this little patch I could check boot printk output and then saw 
everything was properly recognized and only scsi-disk support was missing.


Signed-off-by: Bernd Schubert <bernd-schubert@gmx.de>

Index: zd1211rw.git.beno/init/do_mounts.c
===================================================================
--- zd1211rw.git.beno.orig/init/do_mounts.c	2008-01-06 18:44:23.000000000 
+0100
+++ zd1211rw.git.beno/init/do_mounts.c	2008-01-06 18:45:44.000000000 +0100
@@ -330,6 +330,7 @@
 		printk("Please append a correct \"root=\" boot option; here are the 
available partitions:\n");
 
 		printk_all_partitions();
+		msleep(60 * 1000);
 		panic("VFS: Unable to mount root fs on %s", b);
 	}
 


Cheers,
Bernd
