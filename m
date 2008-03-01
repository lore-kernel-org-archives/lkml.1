Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbYCAShl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbYCAShl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 13:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638AbYCAShT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 13:37:19 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:34096 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448AbYCAShQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 13:37:16 -0500
Date: Sat, 1 Mar 2008 20:35:50 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Alexey Starikovskiy <aystarik@gmail.com>
Cc: lenb@kernel.org, astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] acpi/battery.c: make 2 functions static
Message-ID: <20080301183550.GC25835@cs181133002.pp.htv.fi>
References: <20080301161902.GN25835@cs181133002.pp.htv.fi> <47C99FE1.8080206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47C99FE1.8080206@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2008 at 09:26:41PM +0300, Alexey Starikovskiy wrote:
> May I keep them inline?

The problem with such manual inlines is that we force gcc to always 
inline them - and history has shown that functions grow without the 
"inline" being removed.

And for static functions gcc should (at least in theory) know best when 
to inline them.

> Thanks,
> Alex.
> Adrian Bunk wrote:
>> This patch makes the following functions static instead of global inline:
>> - acpi_battery_present()
>> - acpi_battery_units()
>>
>> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>>
>> ---
>>
>>  drivers/acpi/battery.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> 9cfc2b0a3162d8e2f23537faefb6937c97513f38 foobar
>> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
>> index f6215e8..d941c5a 100644
>> --- a/drivers/acpi/battery.c
>> +++ b/drivers/acpi/battery.c
>> @@ -116,7 +116,7 @@ struct acpi_battery {
>>   #define to_acpi_battery(x) container_of(x, struct acpi_battery, bat);
>>  -inline int acpi_battery_present(struct acpi_battery *battery)
>> +static int acpi_battery_present(struct acpi_battery *battery)
>>  {
>>  	return battery->device->status.battery_present;
>>  }
>> @@ -235,7 +235,7 @@ static enum power_supply_property energy_battery_props[] = {
>>  #endif
>>   #ifdef CONFIG_ACPI_PROCFS_POWER
>> -inline char *acpi_battery_units(struct acpi_battery *battery)
>> +static char *acpi_battery_units(struct acpi_battery *battery)
>>  {
>>  	return (battery->power_unit)?"mA":"mW";
>>  }

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

