Return-Path: <linux-kernel-owner+w=401wt.eu-S1758965AbYEWX3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758965AbYEWX3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 19:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760274AbYEWX2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 19:28:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:23357 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbYEWX2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 19:28:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=t5sfqiy87i7de9VuZP7Nkk5BrUSeieojTDG8xjN49i08z4oG1DH3SwIo6+sySWyjcZmRs6qzpEv9qJrQfqxcgTGM3AaTIwFmEZ8zKO/H5sq8yG/EJ4fKtvmjSiRf0jvdOmdPEuvFrq8tjLdyGBVMr/Ms0z5GFFWLEx7RXmZUGdA=
Date: Fri, 23 May 2008 20:32:08 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: airlied@linux.ie, akpm@linux-foundation.org
Subject: [PATCH] drm: Remove #define's for non-linux systems
Message-ID: <20080523233208.GA9538@Pilar.ictp.trieste.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is no point to consider FreeBSD et al. in the
linux kernel source code.

Signed-off-by: Carlos R. Mafra <crmafra@gmail.com>
---
 drivers/char/drm/drm.h |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/char/drm/drm.h b/drivers/char/drm/drm.h
index 3a05c6d..140f461 100644
--- a/drivers/char/drm/drm.h
+++ b/drivers/char/drm/drm.h
@@ -36,7 +36,6 @@
 #ifndef _DRM_H_
 #define _DRM_H_
 
-#if defined(__linux__)
 #if defined(__KERNEL__)
 #endif
 #include <asm/ioctl.h>		/* For _IO* macros */
@@ -46,22 +45,6 @@
 #define DRM_IOC_WRITE		_IOC_WRITE
 #define DRM_IOC_READWRITE	_IOC_READ|_IOC_WRITE
 #define DRM_IOC(dir, group, nr, size) _IOC(dir, group, nr, size)
-#elif defined(__FreeBSD__) || defined(__NetBSD__) || defined(__OpenBSD__)
-#if defined(__FreeBSD__) && defined(IN_MODULE)
-/* Prevent name collision when including sys/ioccom.h */
-#undef ioctl
-#include <sys/ioccom.h>
-#define ioctl(a,b,c)		xf86ioctl(a,b,c)
-#else
-#include <sys/ioccom.h>
-#endif				/* __FreeBSD__ && xf86ioctl */
-#define DRM_IOCTL_NR(n)		((n) & 0xff)
-#define DRM_IOC_VOID		IOC_VOID
-#define DRM_IOC_READ		IOC_OUT
-#define DRM_IOC_WRITE		IOC_IN
-#define DRM_IOC_READWRITE	IOC_INOUT
-#define DRM_IOC(dir, group, nr, size) _IOC(dir, group, nr, size)
-#endif
 
 #define DRM_MAJOR       226
 #define DRM_MAX_MINOR   15
-- 
1.5.5.GIT

