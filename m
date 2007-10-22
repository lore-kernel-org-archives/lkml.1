Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbXJVNIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbXJVNIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 09:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbXJVNIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 09:08:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:4174 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbXJVNIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 09:08:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=lRClV5IIFLOyoHNWfhbA5FRMY9cJZkmagbrcxrEJeIrtDyYvpX/vXtW6Wj0KyoH8nm8usc4L8Ny/2nGuse4nYvhTOxjdq242II4otQSsm+xijUz1x6Ti5RXDQqRXiYweyDo6qH8/TXfnPX/UI4rOsrnzQQLb+w7lmKFaRC9HJLc=
Message-ID: <471CA0AA.4000904@gmail.com>
Date: Mon, 22 Oct 2007 17:07:54 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Jeff Chua <jeff.chua.linux@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: latest 2.6.23 git missing ACPI POWER_SUPPLY
References: <b6a2187b0710220045q2920c0dat9ebe4850b02d1bbf@mail.gmail.com> <E1IjvB3-0005oG-N9@faramir.fjphome.nl>
In-Reply-To: <E1IjvB3-0005oG-N9@faramir.fjphome.nl>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------030700020302040404050004"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030700020302040404050004
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Frans Pop wrote:
> Jeff Chua wrote:
>> Just pulled latest linux-2.6, and couldn't get ACPI to detect
>> ACPI_BATTERY and ACPI_AC.
>>
>> It seems ACPI POWER_SUPPLY is still missing.
> 
> I had the same problem. It turns out you need to enable
>    drivers -> Power supply class support
> (either built in or as module) to get ACPI AC/Battery support.
> 
> I must say that having these relatively top-level ACPI settings depending on something that is relatively buried away is not very intuitive!
> Especially not since at first glance you don't really seem to need that option except for some weird hardware.
> 
> CC'ing ACPI mailing list for other opinions.
I was thinking that 'select' might be more appropriate here...
Please take a look on attached patch.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--------------030700020302040404050004
Content-Type: text/x-diff;
 name="use_select_for_power_class.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="use_select_for_power_class.patch"

ACPI: use select POWER_SUPPLY for AC, BATTERY and SBS

From: Alexey Starikovskiy <astarikovskiy@suse.de>

POWER_SUPPLY is needed for AC, battery, and SBS sysfs support.
Use 'select' instead of 'depends on', as it is will not be selected
by anything else, leading to confusion.

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 drivers/acpi/Kconfig |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 5d0e26a..ecd87d7 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -88,7 +88,8 @@ config ACPI_PROC_EVENT
 
 config ACPI_AC
 	tristate "AC Adapter"
-	depends on X86 && POWER_SUPPLY
+	depends on X86
+	select POWER_SUPPLY
 	default y
 	help
 	  This driver adds support for the AC Adapter object, which indicates
@@ -97,7 +98,8 @@ config ACPI_AC
 
 config ACPI_BATTERY
 	tristate "Battery"
-	depends on X86 && POWER_SUPPLY
+	depends on X86
+	select POWER_SUPPLY
 	default y
 	help
 	  This driver adds support for battery information through
@@ -352,7 +354,7 @@ config ACPI_HOTPLUG_MEMORY
 config ACPI_SBS
 	tristate "Smart Battery System"
 	depends on X86
-	depends on POWER_SUPPLY
+	select POWER_SUPPLY
 	help
 	  This driver adds support for the Smart Battery System, another
 	  type of access to battery information, found on some laptops.

--------------030700020302040404050004--
