Return-Path: <linux-kernel-owner+w=401wt.eu-S1752338AbYJYVrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbYJYVrP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 17:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYJYVrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 17:47:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:42563 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751246AbYJYVq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 17:46:59 -0400
X-Authenticated: #1142740
X-Provags-ID: V01U2FsdGVkX18mBFYjpCYmlOgMBj0WdbRSvyyxv0h0WBH64KSBt0
	gLb1r8mKQZXMT9
From: Hartmut Niemann <Hartmut.Niemann@gmx.de>
To: linux-kernel@vger.kernel.org, horms@verge.net.au,
       nico-kernel-nfsroot@schottelius.org
Subject: nfsroot.txt in 2.4.36.7 and 2.6.27.1, Configure.help in 2.4.36.7: missing precondition CONFIG_IP_PNP
Date: Sat, 25 Oct 2008 23:47:01 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_VP5AJRo5EFz9zl/"
Message-Id: <200810252347.01484.Hartmut.Niemann@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_VP5AJRo5EFz9zl/
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello everybody!

In kernel versions 2.4.36.7 and 2.6.27.1 (I checked only these) the file 
nfsroot.txt fail to mention, that
Kernel level autoconfiguration CONFIG_IP_PNP *must* be selected
(in 2.6.27.1 the wording is much better mentioning that nfs may not be
compiled as a module than in 2.4.36.7) 
in order to be able to even *see* the option
"Root file system on NFS" (CONFIG_ROOT_NFS)
-- except for xconfig in 2.4.36, which allowed me to see that there is 
this option (greyed), and to see it's help text. (This, by the way,
was a big help -- I could see that the option is still present in current
kernels)

I reordered the section 1 of nfsroot.txt (of 2.6.27.1), diff is attached.
(And I fixed some chapter numbering in section 3).
Is this document otherwise correct for 2.4 and can be updated there too?
The version in 2.4.36.7 is 

The help text of CONFIG_ROOT_NFS in 2.4.36.7 is quite funny:
  "It is
  likely that in this case, you also want to say Y to "Kernel level IP
  autoconfiguration" so that your box can discover its network address
  at boot time."
Does that make clear that you can not even see this option 
during make *config unless you set "Kernel level IP autoconfiguration"?
The help text of CONFIG_NFS_FS does contain the information,
but I found it there a little late. The texts in 2.6 are better.

A diff for 2.4.36.7 Configure.help is attached as well.

Is this correct?

With best regards
Hartmut Niemann

--Boundary-00=_VP5AJRo5EFz9zl/
Content-Type: text/x-diff;
  charset="us-ascii";
  name="nfsroot.txt.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="nfsroot.txt.diff"

--- nfsroot.txt.orig	2008-10-25 23:18:33.000000000 +0200
+++ nfsroot.txt	2008-10-25 23:24:48.000000000 +0200
@@ -22,15 +22,13 @@
 1.) Enabling nfsroot capabilities
     -----------------------------
 
-In order to use nfsroot, NFS client support needs to be selected as
-built-in during configuration. Once this has been selected, the nfsroot
-option will become available, which should also be selected.
-
-In the networking options, kernel level autoconfiguration can be selected,
-along with the types of autoconfiguration to support. Selecting all of
-DHCP, BOOTP and RARP is safe.
-
-
+In order to use nfsroot, in the networking options,  IP kernel level
+autoconfiguration must be selected, along with the types of autoconfiguration
+to support. Selecting all of DHCP, BOOTP and RARP is safe.
+
+Then NFS client support needs to be selected as built-in during configuration.
+Once this has been selected, the nfsroot option will become available,
+which must also be selected.
 
 
 2.) Kernel command line
@@ -207,7 +205,7 @@
      	For more information on isolinux, including how to create bootdisks
      	for prebuilt kernels, see http://syslinux.zytor.com/
 
-3.2) Using LILO
+3.3) Using LILO
 	When using LILO all the necessary command line parameters may be
 	specified using the 'append=' directive in the LILO configuration
 	file.
@@ -219,11 +217,11 @@
 
 	For information on configuring LILO, please refer to its documentation.
 
-3.3) Using GRUB
+3.4) Using GRUB
 	When using GRUB, kernel parameter are simply appended after the kernel
 	specification: kernel <kernel> <parameters>
 
-3.4) Using loadlin
+3.5) Using loadlin
 	loadlin may be used to boot Linux from a DOS command prompt without
 	requiring a local hard disk to mount as root. This has not been
 	thoroughly tested by the authors of this document, but in general
@@ -232,7 +230,7 @@
 
 	Please refer to the loadlin documentation for further information.
 
-3.5) Using a boot ROM
+3.6) Using a boot ROM
 	This is probably the most elegant way of booting a diskless client.
 	With a boot ROM the kernel is loaded using the TFTP protocol. The
 	authors of this document are not aware of any no commercial boot
@@ -241,7 +239,7 @@
 	etherboot, both of which are available on sunsite.unc.edu, and both
 	of which contain everything you need to boot a diskless Linux client.
 
-3.6) Using pxelinux
+3.7) Using pxelinux
 	Pxelinux may be used to boot linux using the PXE boot loader
 	which is present on many modern network cards.
 

--Boundary-00=_VP5AJRo5EFz9zl/
Content-Type: text/x-diff;
  charset="us-ascii";
  name="Configure.help.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="Configure.help.diff"

--- Configure.help.orig	2008-10-25 23:34:25.000000000 +0200
+++ Configure.help	2008-10-25 23:43:37.000000000 +0200
@@ -17262,10 +17262,11 @@
   If you want your Linux box to mount its whole root file system (the
   one containing the directory /) from some other computer over the
   net via NFS (presumably because your box doesn't have a hard disk),
-  say Y. Read <file:Documentation/nfsroot.txt> for details. It is
-  likely that in this case, you also want to say Y to "Kernel level IP
-  autoconfiguration" so that your box can discover its network address
-  at boot time.
+  say Y. Read <file:Documentation/nfsroot.txt> for details.
+  In this case, you also need to say Y to "Kernel level IP
+  autoconfiguration" in the networking options so that your box can
+  discover its network address at boot time, and . Otherwise, you won't be
+  able to say Y here.
 
   Most people say N here.
 

--Boundary-00=_VP5AJRo5EFz9zl/--
