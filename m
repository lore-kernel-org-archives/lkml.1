Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbXL0SD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbXL0SD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 13:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbXL0SCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 13:02:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43438 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbXL0SBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 13:01:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [RFC][PATCH 7/7] ACPI: Print message before calling _PTS
Date: Thu, 27 Dec 2007 19:20:01 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Arjan van de Ven <arjan@infradead.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "Moore, Robert" <robert.moore@intel.com>
References: <200712271903.53961.rjw@sisk.pl>
In-Reply-To: <200712271903.53961.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712271920.02207.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make acpi_sleep_prepare() static and cause it to print a message
specifying the ACPI system sleep state to be entered (helpful for
debugging the suspend/hibernation code).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/sleep/main.c  |    4 +++-
 drivers/acpi/sleep/sleep.h |    2 --
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep/main.c
+++ linux-2.6/drivers/acpi/sleep/main.c
@@ -29,7 +29,7 @@ static u32 acpi_target_sleep_state = ACP
 static bool acpi_sleep_finish_wake_up;
 #endif
 
-int acpi_sleep_prepare(u32 acpi_state)
+static int acpi_sleep_prepare(u32 acpi_state)
 {
 #ifdef CONFIG_ACPI_SLEEP
 	/* do we have a wakeup address for S2 and S3? */
@@ -45,6 +45,8 @@ int acpi_sleep_prepare(u32 acpi_state)
 	ACPI_FLUSH_CPU_CACHE();
 	acpi_enable_wakeup_device_prep(acpi_state);
 #endif
+	printk(KERN_INFO PREFIX "Preparing to enter system sleep state S%d\n",
+		acpi_state);
 	acpi_enter_sleep_state_prep(acpi_state);
 	return 0;
 }
Index: linux-2.6/drivers/acpi/sleep/sleep.h
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep/sleep.h
+++ linux-2.6/drivers/acpi/sleep/sleep.h
@@ -5,5 +5,3 @@ extern int acpi_suspend (u32 state);
 extern void acpi_enable_wakeup_device_prep(u8 sleep_state);
 extern void acpi_enable_wakeup_device(u8 sleep_state);
 extern void acpi_disable_wakeup_device(u8 sleep_state);
-
-extern int acpi_sleep_prepare(u32 acpi_state);
