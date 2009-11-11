Return-Path: <linux-kernel-owner+w=401wt.eu-S1751402AbZKKM2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbZKKM2D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 07:28:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbZKKM2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 07:28:02 -0500
Received: from mail.free-electrons.com ([88.191.76.200]:48950 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbZKKM2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 07:28:01 -0500
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: akpm@linux-foundation.org
Cc: hpa@zytor.com, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: [PATCH v3 0/4] Add support for LZO-compressed kernel images
Date: Wed, 11 Nov 2009 13:27:54 +0100
Message-Id: <1257942478-18719-1-git-send-email-albin.tonnerre@free-electrons.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds generic support for creating and extracting
LZO-compressed kernel images, as well as support for using such images on the
x86 and ARM architectures, and support for creating and using LZO-compressed
initrd and initramfs images.

Changes in v2:
	- On ARM, compiling with -Os failed due to missing __aeabi_uidivmod.
	  Link using arch/arm/lib/lib1funcs.o which provides this symbol, and
	  define a dummy __div0 function in arch/arm/boot/compressed/misc.c, as
	  this symbol is required by lib1funcs.
	- lib/decompress_unlzo.c: include linux/decompress/unlzo.h only when
	  we're not compiling the pre-boot environment to prevent compile
	  issues
	- Formatting fixes

Changes in v3:
	- Add a couple missing semicolons to fix compile issues
	- Fix typos in {init,usr}/Kconfig

Andrew: since it used to be in -mm, can you pick this up again?

Russell: since I believe your initial concerns regarding the ARM part of the
patch got fixed, do I have your approval?
