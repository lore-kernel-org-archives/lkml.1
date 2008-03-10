Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbYCJVaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbYCJVaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbYCJVaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:30:08 -0400
Received: from twin.jikos.cz ([213.151.79.26]:35657 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbYCJVaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:30:06 -0400
Date: Mon, 10 Mar 2008 22:29:37 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>
cc: linux-acpi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: acer-wmi uses input:i8042_command() => build error
In-Reply-To: <200803101959.06441.carlos@strangeworlds.co.uk>
Message-ID: <Pine.LNX.4.64.0803102227540.18589@twin.jikos.cz>
References: <20080310124754.4ec3f24d.randy.dunlap@oracle.com>
 <200803101959.06441.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008, Randy Dunlap wrote:

> drivers/built-in.o: In function `set_u32':
> acer-wmi.c:(.text+0xb9bf6): undefined reference to `i8042_command'
> make[1]: *** [vmlinux] Error 1
> make: *** [sub-make] Error 2

Does the patch below fix your build?


From: Jiri Kosina <jkosina@suse.cz>

Acer-wmi dependends on i8042 code.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

--- 
 drivers/misc/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 982e27b..962817e 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -108,6 +108,7 @@ config ACER_WMI
 	depends on ACPI
 	depends on LEDS_CLASS
 	depends on BACKLIGHT_CLASS_DEVICE
+	depends on SERIO_I8042
 	select ACPI_WMI
 	---help---
 	  This is a driver for newer Acer (and Wistron) laptops. It adds
