Return-Path: <linux-kernel-owner+w=401wt.eu-S1764611AbZLQMRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764611AbZLQMRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:17:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764605AbZLQMRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:17:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43736 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764575AbZLQMRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:17:00 -0500
Date: Thu, 17 Dec 2009 13:16:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Lorne Applebaum <lorne.applebaum@gmail.com>,
       Matthew Garrett <mjg@redhat.com>
Subject: Re: -tip: origin tree build failure
Message-ID: <20091217121617.GA14088@elte.hu>
References: <20091217061725.GA26613@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217061725.GA26613@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Add a Kconfig dependency on SOUND to remedy this.

ok, that should have been CONFIG_SND. Updated patch below.

	Ingo

------------------->
>From f9bf1de0fcb6dddf0145d472b13a21ab8e7723cd Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 17 Dec 2009 07:08:12 +0100
Subject: [PATCH] acpi: Build CONFIG_SOUND=m build failure in CONFIG_THINKPAD_ACPI

-tip testing found that commit 0d204c34e85d1d63e5fdd3e3192747daf0ee7ec1
("thinkpad-acpi: basic ALSA mixer support (v2)") from today's upstream
kernel causes the following build failure on x86, for
CONFIG_THINKPAD_ACPI=y && CONFIG_SOUND=m:

  drivers/built-in.o: In function `volume_alsa_notify_change':
  thinkpad_acpi.c:(.text+0x2d5c2d): undefined reference to `snd_ctl_notify'
  thinkpad_acpi.c:(.text+0x2d5c47): undefined reference to `snd_ctl_notify'

This build fails because thinkpad_acpi.c uses sound facilities
unconditionally, without expressing its dependency on the sound
subsystem.

Add a Kconfig dependency on SOUND to remedy this.

Cc: Len Brown <len.brown@intel.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Lorne Applebaum <lorne.applebaum@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/platform/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index f8bec62..dbd4ef1 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -216,6 +216,7 @@ config THINKPAD_ACPI
 	depends on ACPI
 	depends on INPUT
 	depends on RFKILL || RFKILL = n
+	depends on SND
 	select BACKLIGHT_LCD_SUPPORT
 	select BACKLIGHT_CLASS_DEVICE
 	select HWMON
