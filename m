Return-Path: <linux-kernel-owner+w=401wt.eu-S1751509AbYGXISG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbYGXISG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 04:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbYGXIRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 04:17:51 -0400
Received: from ozlabs.org ([203.10.76.45]:46190 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbYGXIRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 04:17:51 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [RFC,PATCH] scripts/package: add powerpc images to tarball
Message-Id: <1216887460.306306.238738123378.1.gpush@pingu>
To: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
From: Jeremy Kerr <jk@ozlabs.org>
Date: Thu, 24 Jul 2008 18:17:40 +1000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, tarball builds for powerpc kernels don't have any boot
images (other than vmlinux) present.

Add support for powerpc builds in the buildtar script, to include
a few default images.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>

---
RFC: any requests for more/less boot images?

---
 scripts/package/buildtar |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/scripts/package/buildtar b/scripts/package/buildtar
index 28574ae..85e5563 100644
--- a/scripts/package/buildtar
+++ b/scripts/package/buildtar
@@ -72,6 +72,16 @@ case "${ARCH}" in
 	x86|i386|x86_64)
 		[ -f "${objtree}/arch/x86/boot/bzImage" ] && cp -v -- "${objtree}/arch/x86/boot/bzImage" "${tmpdir}/boot/vmlinuz-${KERNELRELEASE}"
 		;;
+	powerpc)
+		for img in zImage zImage.pseries zImage.iseries \
+				dtbImage dtbImage.ps3
+		do
+			imgpath=arch/powerpc/boot/${img}
+			[ -f "${objtree}/${imgpath}" ] || continue
+			cp -v -- "${objtree}/${imgpath}" \
+				"${tmpdir}/boot/${img}-${KERNELRELEASE}"
+		done
+		;;
 	alpha)
 		[ -f "${objtree}/arch/alpha/boot/vmlinux.gz" ] && cp -v -- "${objtree}/arch/alpha/boot/vmlinux.gz" "${tmpdir}/boot/vmlinuz-${KERNELRELEASE}"
 		;;
