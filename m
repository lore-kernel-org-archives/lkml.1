Return-Path: <linux-kernel-owner+w=401wt.eu-S964987AbXLTQZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964987AbXLTQZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 11:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935509AbXLTQZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 11:25:11 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:48426 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933838AbXLTQZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 11:25:09 -0500
Date: Thu, 20 Dec 2007 10:19:24 -0600
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: paulus@samba.org
Subject: [RFC] [PATCH 3/3] Remove mkuboot.sh script
Message-ID: <20071220101924.224248ba@zod.rchland.ibm.com>
In-Reply-To: <20071220101643.48b427ef@zod.rchland.ibm.com>
References: <20071220101643.48b427ef@zod.rchland.ibm.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the mkimage tool is merged into the kernel, we can remove the
unused mkuboot.sh script.

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
-		echo '"mkimage" command not found - U-Boot images will
not be built' >&2
-		exit 0;
-	fi
-fi
-
-# Call "mkimage" to create U-Boot image
-${MKIMAGE} "$@"
