Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251AbZGaAym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbZGaAym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 20:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbZGaAym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 20:54:42 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:49259 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbZGaAyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 20:54:41 -0400
Date: Thu, 30 Jul 2009 17:53:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Cc: Peng Tao <bergwolf@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>,
       Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>
Subject: [PATCH 2/2] doc/filesystems: more mount cleanups
Message-Id: <20090730175314.d15a5eac.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4A724088.0006:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peng Tao <bergwolf@gmail.com>

Documentation/filesystems/sharedsubtree.txt needs updating because the mount
command in util-linux package is well aware of shared subtree features now.
The patch also fixes two typos in sharedsubtree.txt.

Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christoph Hellwig <hch@infradead.org>
---
 Documentation/filesystems/sharedsubtree.txt |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- linux-2.6.31-rc4-git5.orig/Documentation/filesystems/sharedsubtree.txt
+++ linux-2.6.31-rc4-git5/Documentation/filesystems/sharedsubtree.txt
@@ -4,7 +4,7 @@ Shared Subtrees
 Contents:
 	1) Overview
 	2) Features
-	3) smount command
+	3) Setting mount states
 	4) Use-case
 	5) Detailed semantics
 	6) Quiz
@@ -135,10 +135,15 @@ replicas continue to be exactly same.
 	Binding a unbindable mount is a invalid operation.
 
 
-3) smount command
+3) Setting mount states
 
-	Modern mount(8) command is aware of shared subtree features,
-	so use it instead of the 'smount' command. [source code removed]
+	The mount command (util-linux package) can be used to set mount
+	states:
+
+	mount --make-shared mountpoint
+	mount --make-slave mountpoint
+	mount --make-private mountpoint
+	mount --make-unbindable mountpoint
 
 
 4) Use cases
@@ -209,7 +214,7 @@ replicas continue to be exactly same.
 		mount --rbind / /view/v3
 		mount --rbind / /view/v4
 
-		and if /usr has a versioning filesystem mounted, than that
+		and if /usr has a versioning filesystem mounted, then that
 		mount appears at /view/v1/usr, /view/v2/usr, /view/v3/usr and
 		/view/v4/usr too
 
@@ -249,7 +254,7 @@ replicas continue to be exactly same.
 
 		For example:
 			mount --make-shared /mnt
-			mount --bin /mnt /tmp
+			mount --bind /mnt /tmp
 
 		The mount at /mnt and that at /tmp are both shared and belong
 		to the same peer group. Anything mounted or unmounted under



---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
