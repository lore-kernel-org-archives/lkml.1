Return-Path: <linux-kernel-owner+w=401wt.eu-S1759362AbYGVFnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362AbYGVFnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYGVF0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:26:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43390 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757581AbYGVF0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:26:06 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 66/79] always enable FW_LOADER unless EMBEDDED=y
Date: Mon, 21 Jul 2008 22:19:30 -0700
Message-Id: <1216703983-21448-66-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

James Bottomley recently discovered that we have
{request,release}_firmware() dummies for the case of the actual
functions not being available and has a fix for the bug that was
actually causing build errors for built-in users with
CONFIG_FW_LOADER=m.

But now missing selects on FW_LOADER are no longer visible at
compile-time at all and can become runtime problems.

FW_LOADER is infrastructure with relatively small codesize we can safely
enable for everyone, and only for people who really need small kernels
(and can be expected to know what they are doing) it matters being able
to disable it.

This patch therefore always sets FW_LOADER=y and allows users only to
disable it with EMBEDDED=y.

As a bonus, we can then get rid of all "select FW_LOADER" plus the due
to it required "depends on HOTPLUG" which removes some complexity from
our Kconfig files.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index d47482f..6318f6b 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -27,8 +27,9 @@ config PREVENT_FIRMWARE_BUILD
 	  If unsure say Y here.
 
 config FW_LOADER
-	tristate "Userspace firmware loading support"
+	tristate "Userspace firmware loading support" if EMBEDDED
 	depends on HOTPLUG
+	default y
 	---help---
 	  This option is provided for the case where no in-kernel-tree modules
 	  require userspace firmware loading support, but a module built outside
-- 
1.5.6.3

