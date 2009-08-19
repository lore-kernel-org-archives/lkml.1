Return-Path: <linux-kernel-owner+w=401wt.eu-S1752486AbZHSOoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbZHSOoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 10:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZHSOoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 10:44:16 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:45040 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbZHSOoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 10:44:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cmn4CPmgpSZTs8SgrngRBVmdUlSS1O39b9o7RAdyOCz3yHsv3ft1AjZvXqAJ04u8cM
         E7aAFSDukyrxPmNsYnrM8SanBGaNFPURUsizJ+fTo5UYpBfBCsf81getYH3yTXZhnFDc
         CeeRLtziB8k0O6mwiaVASY5f1OqY6SiOsA8PU=
Message-ID: <4A8C0FBA.50502@tuffmail.co.uk>
Date: Wed, 19 Aug 2009 15:44:10 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: marcel@holtmann.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 6/5] dell-laptop: remove duplicate Kconfig entry under drivers/misc
References: <4A8C0623.8030808@tuffmail.co.uk> <1250690811-21203-5-git-send-email-alan-jenkins@tuffmail.co.uk> <20090819141322.GA15937@srcf.ucam.org>
In-Reply-To: <20090819141322.GA15937@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Wed, Aug 19, 2009 at 03:06:51PM +0100, Alan Jenkins wrote:
>   
>> This is controlled by a hardware switch, so we should poll it in order
>> to pick up changes.  (There does not appear to be an interrupt or any
>> other notification mechanism).
>>     
>
> With the exception of this one they all look fine - I'm moving house 
> next week and won't have access to any Dell hardware for over a month, 
> so if anyone else could confirm that these work that would be excellent.
>
>   

Ok, thanks!

Here's something else I just noticed.  I was able to test this one myself.

----------------------------------------------------------------------
>From 7efa12d3ea8bb70897358b4a87f8dedce9b78cca Mon Sep 17 00:00:00 2001
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date: Wed, 19 Aug 2009 15:32:17 +0100
Subject: [PATCH] dell-laptop: remove duplicate Kconfig entry under drivers/misc

This showed up as an unselectable option when using xconfig and
searching for "dell".  It must been overlooked when dell-laptop
was moved to drivers/platform/x86.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 drivers/misc/Kconfig |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 68ab39d..22414c5 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -210,19 +210,6 @@ config SGI_GRU_DEBUG
 	This option enables addition debugging code for the SGI GRU driver. If
 	you are unsure, say N.
 
-config DELL_LAPTOP
-	tristate "Dell Laptop Extras (EXPERIMENTAL)"
-	depends on X86
-	depends on DCDBAS
-	depends on EXPERIMENTAL
-	depends on BACKLIGHT_CLASS_DEVICE
-	depends on RFKILL
-	depends on POWER_SUPPLY
-	default n
-	---help---
-	This driver adds support for rfkill and backlight control to Dell
-	laptops.
-
 config ISL29003
 	tristate "Intersil ISL29003 ambient light sensor"
 	depends on I2C && SYSFS
-- 
1.6.3.2



