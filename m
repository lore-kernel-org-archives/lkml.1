Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1755866AbYJORhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbYJORhn (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 15 Oct 2008 13:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbYJORha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 13:37:30 -0400
Received: from f121.mail.ru ([194.67.57.127]:60376 "EHLO f121.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbYJORh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 13:37:29 -0400
From: =?koi8-r?Q?=E5=D7=C7=C5=CE=C9=CA_=ED=C1=CE=C1=DE=CB=C9=CE?= 
	<sfstudio@mail.ru>
To: gorcunov@gmail.com, linux-kernel@vger.kernel.org
Subject: =?koi8-r?Q?Re=3A_Re=3A_Re=3A_patch_to_2.6.27_fix_build_rpm?=
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: 127.0.0.1 via proxy [207.226.47.244]
Date: Wed, 15 Oct 2008 23:37:26 +0600
References: <20081015172412.GB20222@localhost>
In-Reply-To: <20081015172412.GB20222@localhost>
Reply-To: =?koi8-r?Q?=E5=D7=C7=C5=CE=C9=CA_=ED=C1=CE=C1=DE=CB=C9=CE?= 
	  <sfstudio@mail.ru>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1KqAJK-000KWz-00.sfstudio-mail-ru@f121.mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeniy Manachkin <sfstudio@mail.ru>
Subject: [PATCH] mkspec - fix build rpm

This is patch to fix incorrect mkspec script to make rpm correctly at 2.6.27 vanilla kernel. This is regression in 2.6.27. 2.6.26 make rpm work good.
In 2.6.27 'make rpm' say error from rpmbuild "Many unpacked files (*.fw)." 
This is patch fix it this error.

Sorry my English.

Signed-off-by: Evgeniy Manachkin <sfstudio@mail.ru>

 --- linux-2.6.27/scripts/package/mkspec.orig    2008-10-11 00:00:38.000000000 +0700
 +++ linux-2.6.27/scripts/package/mkspec 2008-10-11 00:39:43.000000000 +0700
 @@ -64,8 +64,10 @@ fi
  echo "%install"
  echo "%ifarch ia64"
  echo 'mkdir -p $RPM_BUILD_ROOT/boot/efi $RPM_BUILD_ROOT/lib/modules'
 +echo 'mkdir -p $RPM_BUILD_ROOT/boot/efi $RPM_BUILD_ROOT/lib/firmware'
  echo "%else"
  echo 'mkdir -p $RPM_BUILD_ROOT/boot $RPM_BUILD_ROOT/lib/modules'
 +echo 'mkdir -p $RPM_BUILD_ROOT/boot $RPM_BUILD_ROOT/lib/firmware'
  echo "%endif"
 
  echo 'INSTALL_MOD_PATH=$RPM_BUILD_ROOT make %{_smp_mflags} modules_install'
 @@ -92,5 +94,6 @@ echo "%files"
  echo '%defattr (-, root, root)'
  echo "%dir /lib/modules"
  echo "/lib/modules/$KERNELRELEASE"
 +echo "/lib/firmware"
  echo "/boot/*"
  echo ""
