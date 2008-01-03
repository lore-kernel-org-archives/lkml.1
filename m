Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbYACWHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbYACWHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 17:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYACWHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 17:07:30 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:34884 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbYACWH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 17:07:29 -0500
Date: Thu, 3 Jan 2008 16:05:30 -0600
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: sam@ravnborg.org
Cc: paulus@samba.org, linux-kernel@vger.kernel.org, wd@denx.de
Subject: [PATCH 3/3] Remove mkuboot.sh script
Message-ID: <20080103160530.5eb87f0c@zod.rchland.ibm.com>
In-Reply-To: <20080103160104.171f9aaa@zod.rchland.ibm.com>
References: <20080103160104.171f9aaa@zod.rchland.ibm.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the mkubootimg tool is merged into the kernel, we can remove the unused
mkuboot.sh script.

Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

---
 scripts/mkuboot.sh |   19 -------------------
 1 file changed, 19 deletions(-)

--- linux-2.6.orig/scripts/mkuboot.sh
+++ /dev/null
@@ -1,19 +0,0 @@
-#!/bin/bash
-
-#
-# Build U-Boot image when `mkimage' tool is available.
-#
-
-MKIMAGE=$(type -path "${CROSS_COMPILE}mkimage")
-
-if [ -z "${MKIMAGE}" ]; then
-	MKIMAGE=$(type -path mkimage)
-	if [ -z "${MKIMAGE}" ]; then
-		# Doesn't exist
-		echo '"mkimage" command not found - U-Boot images will not be built' >&2
-		exit 0;
-	fi
-fi
-
-# Call "mkimage" to create U-Boot image
-${MKIMAGE} "$@"
