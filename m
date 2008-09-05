Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbYIEGLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbYIEGLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 02:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755154AbYIEGLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 02:11:08 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:7043 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbYIEGLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 02:11:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=bfAn38Gxh7ArcYbpRQy+T4TS1MVxol/elBqwtVvNL7oA87ZpIkSG5QDkOBmUBoo2k1
         VWXkUthk0fm+clO4IcYLrlE/mmNcoxn81G2+eJXDpK/VbtYwcqP9JGiLZnIf8ynMU/I5
         tRGptMbKs4eWZ4+gxZ03XqbPc3jqknJ/s6lNA=
Date: Thu, 4 Sep 2008 23:11:01 -0700
From: Khem Raj <raj.khem@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Export byteorder.h and swab.h a.out.h to userspace
Message-ID: <20080905061101.GA7892@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

Some architectures have moved the asm/ into arch/ and some have not. This patch checks for a.out.h in both places before exporting it.

When building headers for arm I noticed that userspace headers need linux/byteorder.h and inturn swab.h also to be exported to userspace as asm/byteorder.h needs it.

I test build headers_install for all possible architecutures.

Thanks

-Khem


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=diff

Signed-off-by: Khem Raj <raj.khem@gmail.com>

diff --git a/include/asm-generic/Kbuild.asm b/include/asm-generic/Kbuild.asm
index 1170dc6..04ccba5 100644
--- a/include/asm-generic/Kbuild.asm
+++ b/include/asm-generic/Kbuild.asm
@@ -1,9 +1,13 @@
 ifneq ($(wildcard $(srctree)/include/asm-$(SRCARCH)/kvm.h),)
 header-y  += kvm.h
+else ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h),)
+header-y  += kvm.h
 endif
 
 ifneq ($(wildcard $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
 unifdef-y += a.out.h
+else ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h),)
+unifdef-y += a.out.h
 endif
 unifdef-y += auxvec.h
 unifdef-y += byteorder.h
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 5939125..49e0fbd 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -41,6 +41,7 @@ header-y += baycom.h
 header-y += bfs_fs.h
 header-y += blkpg.h
 header-y += bpqether.h
+header-y += byteorder.h
 header-y += can.h
 header-y += cdk.h
 header-y += chio.h
@@ -167,7 +168,9 @@ unifdef-y += acct.h
 unifdef-y += adb.h
 unifdef-y += adfs_fs.h
 unifdef-y += agpgart.h
-ifneq ($(wildcard $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
+ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h),)
+unifdef-y += a.out.h
+else ifneq ($(wildcard $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
 unifdef-y += a.out.h
 endif
 unifdef-y += apm_bios.h
@@ -260,6 +263,8 @@ unifdef-y += kernel.h
 unifdef-y += keyboard.h
 ifneq ($(wildcard $(srctree)/include/asm-$(SRCARCH)/kvm.h),)
 unifdef-y += kvm.h
+else ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h),)
+unifdef-y += kvm.h
 endif
 unifdef-y += llc.h
 unifdef-y += loop.h
@@ -334,6 +339,7 @@ unifdef-y += soundcard.h
 unifdef-y += stat.h
 unifdef-y += stddef.h
 unifdef-y += string.h
+unifdef-y += swab.h
 unifdef-y += synclink.h
 unifdef-y += sysctl.h
 unifdef-y += tcp.h

--gBBFr7Ir9EOA20Yy--
