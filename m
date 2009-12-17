Return-Path: <linux-kernel-owner+w=401wt.eu-S1761662AbZLQGR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761662AbZLQGR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 01:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759991AbZLQGRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 01:17:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53744 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759061AbZLQGRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 01:17:54 -0500
Date: Thu, 17 Dec 2009 07:17:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Lorne Applebaum <lorne.applebaum@gmail.com>,
       Matthew Garrett <mjg@redhat.com>
Subject: -tip: origin tree build failure
Message-ID: <20091217061725.GA26613@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Today's -tip failed to build because commit 
0d204c34e85d1d63e5fdd3e3192747daf0ee7ec1 ("thinkpad-acpi: basic ALSA mixer 
support (v2)") from today's upstream kernel causes the following build failure 
on x86, for CONFIG_THINKPAD_ACPI=y && CONFIG_SOUND=m:

  drivers/built-in.o: In function `volume_alsa_notify_change':
  thinkpad_acpi.c:(.text+0x2d5c2d): undefined reference to `snd_ctl_notify'
  thinkpad_acpi.c:(.text+0x2d5c47): undefined reference to `snd_ctl_notify'

I've applied the patch below to tip:out-of-tree.

Thanks,

	Ingo

----------------->
acpi: Build CONFIG_SOUND=m build failure in CONFIG_THINKPAD_ACPI=y

Today's -tip failed to build because thinkpad_acpi.c uses sound facilities 
unconditionally, without expressing its dependency on the sound subsystem:

  drivers/built-in.o: In function `volume_alsa_notify_change':
  thinkpad_acpi.c:(.text+0x2d5c2d): undefined reference to `snd_ctl_notify'
  thinkpad_acpi.c:(.text+0x2d5c47): undefined reference to `snd_ctl_notify'

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
index f8bec62..60083e9 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -216,6 +216,7 @@ config THINKPAD_ACPI
 	depends on ACPI
 	depends on INPUT
 	depends on RFKILL || RFKILL = n
+	depends on SOUND
 	select BACKLIGHT_LCD_SUPPORT
 	select BACKLIGHT_CLASS_DEVICE
 	select HWMON
