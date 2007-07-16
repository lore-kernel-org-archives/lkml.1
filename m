Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbXGPSDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbXGPSDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 14:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760619AbXGPSDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 14:03:00 -0400
Received: from smtp-out.google.com ([216.239.45.13]:56855 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759876AbXGPSC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 14:02:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:user-agent;
	b=m2vsyrg6KBM72UauY+DtmZmqvEgwD9U+CLGrpmEa9GMqWYntbvHo9z6PhSggfFWea
	zDgKN1V8Lq7Mq7WhcHmpg==
Date: Mon, 16 Jul 2007 11:02:21 -0700
From: Aaron Durbin <adurbin@google.com>
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de, akpm@osdl.org
Subject: [PATCH] x86_64: Make ACPI the default reset option
Message-ID: <20070716180221.GA5370@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Make ACPI be the default reset method for x86_64. If the reset mechanism fails
using ACPI, it will default to using the keyboard controller.

Signed-off-by: Aaron Durbin <adurbin@google.com>
---

This patch relies on the ACPI reboot mechanism patch.

diff --git a/Documentation/x86_64/boot-options.txt b/Documentation/x86_64/boot-options.txt
index a9253bc..1a9419c 100644
--- a/Documentation/x86_64/boot-options.txt
+++ b/Documentation/x86_64/boot-options.txt
@@ -113,10 +113,10 @@ Rebooting
    warm   Don't set the cold reboot flag
    cold   Set the cold reboot flag
    triple Force a triple fault (init)
-   kbd    Use the keyboard controller. cold reset (default)
+   kbd    Use the keyboard controller. cold reset
    acpi   Use the ACPI RESET_REG in the FADT. If ACPI is not configured or the
           ACPI reset does not work, the reboot path attempts the reset using
-          the keyboard controller.
+          the keyboard controller. (default)
 
    Using warm reset will be much faster especially on big memory
    systems because the BIOS will not go through the memory check.
diff --git a/arch/x86_64/kernel/reboot.c b/arch/x86_64/kernel/reboot.c
index 239b576..6fc1b72 100644
--- a/arch/x86_64/kernel/reboot.c
+++ b/arch/x86_64/kernel/reboot.c
@@ -29,7 +29,7 @@ static enum { 
 	BOOT_TRIPLE = 't',
 	BOOT_KBD = 'k',
 	BOOT_ACPI = 'a'
-} reboot_type = BOOT_KBD;
+} reboot_type = BOOT_ACPI;
 static int reboot_mode = 0;
 int reboot_force;
 
