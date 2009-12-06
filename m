Return-Path: <linux-kernel-owner+w=401wt.eu-S934014AbZLFRfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934014AbZLFRfk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 12:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933978AbZLFRfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 12:35:39 -0500
Received: from mout2.freenet.de ([195.4.92.92]:33476 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933970AbZLFRfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 12:35:38 -0500
Message-ID: <4B1BEAC7.3080901@freenet.de>
Date: Sun, 06 Dec 2009 18:32:55 +0100
From: Patrick Ringl <patrick_@freenet.de>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH]: drivers/platform/x86/Kconfig - fix inconsistency
References: <4B1B1336.5020309@freenet.de> <4B1BF119.2020600@oracle.com>
In-Reply-To: <4B1BF119.2020600@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Randy Dunlap wrote:
> Patrick Ringl wrote:
>   
>> Hi,
>>
>> I just discovered an inconsistency in a Kconfig file. DELL_WMI as well
>> as HP_WMI should not depend on ACPI_WMI but select it, as all the other
>> WMI-related,  platform-specific device drivers like TC1100_WMI or
>> ACER_WMI do.
>>
>> This -as of right now- prevents the selection of the two initially
>> mentioned drivers unless one, by chance, enables ACPI_WMI and then goes
>> back.
>>     
>
> Then you'll also need to add
> 	depends on ACPI
> to both of those drivers.  Without this addition,
> these drivers could enable ACPI_WMI even when ACPI
> is not enabled.
>
>   
Oh yea, I've missed that.

Signed-off-by: Patrick Ringl <patrick_@freenet.de>

--- linux-2.6.32-o/drivers/platform/x86/Kconfig	2009-12-03 04:51:21.000000000 +0100
+++ linux-2.6.32/drivers/platform/x86/Kconfig	2009-12-06 18:08:09.000000000 +0100
@@ -86,8 +86,9 @@
 
 config DELL_WMI
 	tristate "Dell WMI extras"
-	depends on ACPI_WMI
 	depends on INPUT
+	depends on ACPI
+	select ACPI_WMI
 	---help---
 	  Say Y here if you want to support WMI-based hotkeys on Dell laptops.
 
@@ -133,9 +134,10 @@
 
 config HP_WMI
 	tristate "HP WMI extras"
-	depends on ACPI_WMI
+	depends on ACPI
 	depends on INPUT
 	depends on RFKILL || RFKILL = n
+	select ACPI_WMI
 	help
 	 Say Y here if you want to support WMI-based hotkeys on HP laptops and
 	 to read data from WMI such as docking or ambient light sensor state.

---
>   
>> Signed-off-by: Patrick Ringl <patrick_@freenet.de>
>>
>> --- linux-2.6.32-o/drivers/platform/x86/Kconfig    2009-12-03
>> 04:51:21.000000000 +0100
>> +++ linux-2.6.32/drivers/platform/x86/Kconfig    2009-12-06
>> 02:32:47.000000000 +0100
>> @@ -86,8 +86,8 @@
>>
>> config DELL_WMI
>>     tristate "Dell WMI extras"
>> -    depends on ACPI_WMI
>>     depends on INPUT
>> +    select ACPI_WMI
>>     ---help---
>>       Say Y here if you want to support WMI-based hotkeys on Dell laptops.
>>
>> @@ -133,9 +133,9 @@
>>
>> config HP_WMI
>>     tristate "HP WMI extras"
>> -    depends on ACPI_WMI
>>     depends on INPUT
>>     depends on RFKILL || RFKILL = n
>> +    select ACPI_WMI
>>     help
>>      Say Y here if you want to support WMI-based hotkeys on HP laptops and
>>      to read data from WMI such as docking or ambient light sensor state.
>> ---
>>     
>
>
>
>   
regards,
Patrick
