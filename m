Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbZHSPLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbZHSPLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 11:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZHSPLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 11:11:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57482 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751596AbZHSPLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 11:11:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] AFS: Documentation updates
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org,
       Anton Blanchard <anton@samba.org>, David Howells <dhowells@redhat.com>
Date: Wed, 19 Aug 2009 16:10:16 +0100
Message-ID: <20090819151016.8833.73577.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

Fix some issues with the AFS documentation, found when testing AFS on ppc64:

- Update AFS features: reading/writing, local caching
- Typo in kafs sysfs debug file
- Use modprobe instead of insmod in example
- Update IPs for grand.central.org

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/filesystems/afs.txt |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)


diff --git a/Documentation/filesystems/afs.txt b/Documentation/filesystems/afs.txt
index 12ad6c7..ffef91c 100644
--- a/Documentation/filesystems/afs.txt
+++ b/Documentation/filesystems/afs.txt
@@ -23,15 +23,13 @@ it does support include:
 
  (*) Security (currently only AFS kaserver and KerberosIV tickets).
 
- (*) File reading.
+ (*) File reading and writing.
 
  (*) Automounting.
 
-It does not yet support the following AFS features:
-
- (*) Write support.
+ (*) Local caching (via fscache).
 
- (*) Local caching.
+It does not yet support the following AFS features:
 
  (*) pioctl() system call.
 
@@ -56,7 +54,7 @@ They permit the debugging messages to be turned on dynamically by manipulating
 the masks in the following files:
 
 	/sys/module/af_rxrpc/parameters/debug
-	/sys/module/afs/parameters/debug
+	/sys/module/kafs/parameters/debug
 
 
 =====
@@ -66,9 +64,9 @@ USAGE
 When inserting the driver modules the root cell must be specified along with a
 list of volume location server IP addresses:
 
-	insmod af_rxrpc.o
-	insmod rxkad.o
-	insmod kafs.o rootcell=cambridge.redhat.com:172.16.18.73:172.16.18.91
+	modprobe af_rxrpc
+	modprobe rxkad
+	modprobe kafs rootcell=cambridge.redhat.com:172.16.18.73:172.16.18.91
 
 The first module is the AF_RXRPC network protocol driver.  This provides the
 RxRPC remote operation protocol and may also be accessed from userspace.  See:
@@ -81,7 +79,7 @@ is the actual filesystem driver for the AFS filesystem.
 Once the module has been loaded, more modules can be added by the following
 procedure:
 
-	echo add grand.central.org 18.7.14.88:128.2.191.224 >/proc/fs/afs/cells
+	echo add grand.central.org 18.9.48.14:128.2.203.61:130.237.48.87 >/proc/fs/afs/cells
 
 Where the parameters to the "add" command are the name of a cell and a list of
 volume location servers within that cell, with the latter separated by colons.
@@ -101,7 +99,7 @@ The name of the volume can be suffixes with ".backup" or ".readonly" to
 specify connection to only volumes of those types.
 
 The name of the cell is optional, and if not given during a mount, then the
-named volume will be looked up in the cell specified during insmod.
+named volume will be looked up in the cell specified during modprobe.
 
 Additional cells can be added through /proc (see later section).
 
@@ -163,14 +161,14 @@ THE CELL DATABASE
 
 The filesystem maintains an internal database of all the cells it knows and the
 IP addresses of the volume location servers for those cells.  The cell to which
-the system belongs is added to the database when insmod is performed by the
+the system belongs is added to the database when modprobe is performed by the
 "rootcell=" argument or, if compiled in, using a "kafs.rootcell=" argument on
 the kernel command line.
 
 Further cells can be added by commands similar to the following:
 
 	echo add CELLNAME VLADDR[:VLADDR][:VLADDR]... >/proc/fs/afs/cells
-	echo add grand.central.org 18.7.14.88:128.2.191.224 >/proc/fs/afs/cells
+	echo add grand.central.org 18.9.48.14:128.2.203.61:130.237.48.87 >/proc/fs/afs/cells
 
 No other cell database operations are available at this time.
 
@@ -233,7 +231,7 @@ insmod /tmp/kafs.o rootcell=cambridge.redhat.com:172.16.18.91
 mount -t afs \%root.afs. /afs
 mount -t afs \%cambridge.redhat.com:root.cell. /afs/cambridge.redhat.com/
 
-echo add grand.central.org 18.7.14.88:128.2.191.224 > /proc/fs/afs/cells
+echo add grand.central.org 18.9.48.14:128.2.203.61:130.237.48.87 > /proc/fs/afs/cells
 mount -t afs "#grand.central.org:root.cell." /afs/grand.central.org/
 mount -t afs "#grand.central.org:root.archive." /afs/grand.central.org/archive
 mount -t afs "#grand.central.org:root.contrib." /afs/grand.central.org/contrib

