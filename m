Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbYJOOif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbYJOOif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYJOOi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:38:28 -0400
Received: from mx45.mail.ru ([194.67.23.236]:46952 "EHLO mx45.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbYJOOi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:38:27 -0400
X-Greylist: delayed 1674 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Oct 2008 10:38:27 EDT
From: =?koi8-r?Q?=E5=D7=C7=C5=CE=C9=CA_=ED=C1=CE=C1=DE=CB=C9=CE?= 
	<sfstudio@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: patch to 2.6.27 fix build rpm
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: 127.0.0.1 via proxy [207.226.47.244]
Date: Wed, 15 Oct 2008 20:04:02 +0600
Reply-To: =?koi8-r?Q?=E5=D7=C7=C5=CE=C9=CA_=ED=C1=CE=C1=DE=CB=C9=CE?= 
	  <sfstudio@mail.ru>
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: 8bit
Message-Id: <E1Kq6yo-000PeN-00.sfstudio-mail-ru@f143.mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest working kernel version:2.6.26.6
Distribution: any
Hardware Environment: any
Software Environment: any
Problem Description: Build error from make rpm. Many unpacked files (*.fw).

Steps to reproduce: 

Add in .config:
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""

and say make rpm to build.

This patch for file linux-2.6.27/scripts/package/mkspec is fix this problem:


--- mkspec.old  2008-10-11 00:00:38.000000000 +0700
+++ mkspec      2008-10-11 00:39:43.000000000 +0700
@@ -64,8 +64,10 @@
 echo "%install"
 echo "%ifarch ia64"
 echo 'mkdir -p $RPM_BUILD_ROOT/boot/efi $RPM_BUILD_ROOT/lib/modules'
+echo 'mkdir -p $RPM_BUILD_ROOT/boot/efi $RPM_BUILD_ROOT/lib/firmware'
 echo "%else"
 echo 'mkdir -p $RPM_BUILD_ROOT/boot $RPM_BUILD_ROOT/lib/modules'
+echo 'mkdir -p $RPM_BUILD_ROOT/boot $RPM_BUILD_ROOT/lib/firmware'
 echo "%endif"

 echo 'INSTALL_MOD_PATH=$RPM_BUILD_ROOT make %{_smp_mflags} modules_install'
@@ -92,5 +94,6 @@
 echo '%defattr (-, root, root)'
 echo "%dir /lib/modules"
 echo "/lib/modules/$KERNELRELEASE"
+echo "/lib/firmware"
 echo "/boot/*"
 echo ""

С уважением, Маначкин Е.Р.
________________________________________
|Комплексные решения на базе Linux.
|Opensource wireless routers firmware
|www: http://wive-ng.sf.net
|mail-to: sfstudio@mail.ru
|ICQ: 485758428
|JID: sfstudio-omsk@jabber.ru


