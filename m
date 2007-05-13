Return-Path: <linux-kernel-owner+w=401wt.eu-S934796AbXEMQgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934796AbXEMQgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758130AbXEMQgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:36:07 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:33833 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756374AbXEMQgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:36:03 -0400
Date: Sun, 13 May 2007 18:35:45 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: undeprecate raw driver.
In-Reply-To: <20070513163220.GA31902@redhat.com>
Message-ID: <Pine.LNX.4.61.0705131835110.9570@yvahk01.tjqt.qr>
References: <20070513163220.GA31902@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 13 2007 12:32, Dave Jones wrote:

>Despite repeated attempts over the last two and half years, this driver
>seems somewhat persistant.  Remove its deprecated status as it has
>existing users who may not be in a position to migrate their apps
>to O_DIRECT.
>
>Signed-off-by: Dave Jones <davej@redhat.com>
>
>diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
>index 498ff31..5108619 100644
>--- a/Documentation/feature-removal-schedule.txt
>+++ b/Documentation/feature-removal-schedule.txt
>@@ -41,14 +41,6 @@ Who:	Pavel Machek <pavel@suse.cz>
> 
> ---------------------------
> 
>-What:	RAW driver (CONFIG_RAW_DRIVER)
>-When:	December 2005
>-Why:	declared obsolete since kernel 2.6.3
>-	O_DIRECT can be used instead
>-Who:	Adrian Bunk <bunk@stusta.de>
>-
>----------------------------
>-
> What:	raw1394: requests of type RAW1394_REQ_ISO_SEND, RAW1394_REQ_ISO_LISTEN
> When:	June 2007
> Why:	Deprecated in favour of the more efficient and robust rawiso interface.
>diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
>index abcafac..1e4d688 100644
>--- a/drivers/char/Kconfig
>+++ b/drivers/char/Kconfig
>@@ -993,15 +993,14 @@ config GPIO_VR41XX
> 	depends on CPU_VR41XX
> 
> config RAW_DRIVER
>-	tristate "RAW driver (/dev/raw/rawN) (OBSOLETE)"
>+	tristate "RAW driver (/dev/raw/rawN)"
> 	depends on BLOCK
> 	help
>-	  The raw driver permits block devices to be bound to /dev/raw/rawN. 
>-	  Once bound, I/O against /dev/raw/rawN uses efficient zero-copy I/O. 
>+	  The raw driver permits block devices to be bound to /dev/raw/rawN.
>+	  Once bound, I/O against /dev/raw/rawN uses efficient zero-copy I/O.
> 	  See the raw(8) manpage for more details.
> 
>-          The raw driver is deprecated and will be removed soon.
>-          Applications should simply open the device (eg /dev/hda1)
>+          Applications should preferably open the device (eg /dev/hda1)
>           with the O_DIRECT flag.
> 
> config MAX_RAW_DEVS

At least keep the "it's obsolete" Kconfig description. We
don't want new users/projects to jump on /dev/raw.



	Jan
-- 
