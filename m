Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab0CBN4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 08:56:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46748 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075Ab0CBN4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 08:56:42 -0500
Date: Tue, 2 Mar 2010 14:56:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] compal-laptop: Make it depend on CONFIG_RFKILL
Message-ID: <20100302135626.GA18373@elte.hu>
References: <1267197527-18062-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267197527-18062-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

* Matthew Garrett <mjg@redhat.com> wrote:

>       compal-laptop: Add support for known Compal made Dell laptops
>       compal-laptop: Replace sysfs support with rfkill support

FYI, -tip testing found a (relatively rare) build failure introduced by these 
commits, which occurs with certain .config's - see the fix below. Please 
apply.

Thanks,

	Ingo

--------------------------->
>From a6e5fbf2d4b6e9f78abcc5784f23403aa7972369 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 2 Mar 2010 14:51:16 +0100
Subject: [PATCH] compal-laptop: Make it depend on CONFIG_RFKILL

-tip testing found this build failure (x86 randconfig):

 drivers/built-in.o: In function `setup_rfkill':
 compal-laptop.c:(.text+0x36abe8): undefined reference to `rfkill_alloc'
 compal-laptop.c:(.text+0x36abfc): undefined reference to `rfkill_register'
 compal-laptop.c:(.text+0x36ac30): undefined reference to `rfkill_alloc'
 compal-laptop.c:(.text+0x36ac44): undefined reference to `rfkill_register'

Which can happen with CONFIG_COMPAL_LAPTOP=y but COMPAL_LAPTOP=m.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/platform/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 89da3e2..56076ee 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -178,6 +178,7 @@ config COMPAL_LAPTOP
 	tristate "Compal Laptop Extras"
 	depends on ACPI
 	depends on BACKLIGHT_CLASS_DEVICE
+	depends on RFKILL
 	---help---
 	  This is a driver for laptops built by Compal:
 
