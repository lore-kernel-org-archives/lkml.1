Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbYDGQlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbYDGQlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 12:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYDGQlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 12:41:03 -0400
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:40608 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751956AbYDGQlC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 12:41:02 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Apr 2008 12:41:02 EDT
X-YMail-OSG: raq4WbAVM1lhibdTgKaihKJ0rhVyehGUQ_HAP4qf4x6rrAUWwbh8hD.kEFKpK09Ow0EfsB9.IQ--
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 7 Apr 2008 11:18:11 -0500
From: Peter Samuelson <peter@p12n.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Trivial: change %{_smp_flags} to {?_smp_mflags} in RPM
	spec file
Message-ID: <20080407161811.GA19755@p12n.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial: change %{_smp_flags} to {?_smp_mflags} in RPM spec file

Seems to work, though I don't know the spec format well enough to
explain the syntax change.

Signed-off-by: Peter Samuelson <peter@p12n.org>

diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index ffd61fe..3dfbf92 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -57,7 +57,7 @@ fi
 echo "%build"
 
 if ! $PREBUILT; then
-echo "make clean && make %{_smp_mflags}"
+echo "make clean && make %{?_smp_mflags}"
 echo ""
 fi
 
@@ -68,7 +68,7 @@ echo "%else"
 echo 'mkdir -p $RPM_BUILD_ROOT/boot $RPM_BUILD_ROOT/lib/modules'
 echo "%endif"
 
-echo 'INSTALL_MOD_PATH=$RPM_BUILD_ROOT make %{_smp_mflags} modules_install'
+echo 'INSTALL_MOD_PATH=$RPM_BUILD_ROOT make %{?_smp_mflags} modules_install'
 echo "%ifarch ia64"
 echo 'cp $KBUILD_IMAGE $RPM_BUILD_ROOT'"/boot/efi/vmlinuz-$KERNELRELEASE"
 echo 'ln -s '"efi/vmlinuz-$KERNELRELEASE" '$RPM_BUILD_ROOT'"/boot/"
