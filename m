Return-Path: <linux-kernel-owner+w=401wt.eu-S1758378AbYCASnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbYCASnT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 13:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbYCASnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 13:43:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:29553 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbYCASnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 13:43:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Ur5atOm0u2uKz7hJBM+p72eRcL+LLgr8fcMFBlUBQBYdh9MO4O9KlKnujMzu69+wfDxVGX/atu87hrv8bdFvfoErder0xDpV3sv1asGMjQCE7bNYaILkRTOMUUAKC+6/VcXkecBnV0bADN0sxeS3GDZ8GISVNkmXUx22B7a0CYQ=
Message-ID: <47C9A3B3.4080401@gmail.com>
Date: Sat, 01 Mar 2008 21:42:59 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: lenb@kernel.org, astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] acpi/battery.c: make 2 functions static
References: <20080301161902.GN25835@cs181133002.pp.htv.fi> <47C99FE1.8080206@gmail.com> <20080301183550.GC25835@cs181133002.pp.htv.fi>
In-Reply-To: <20080301183550.GC25835@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sat, Mar 01, 2008 at 09:26:41PM +0300, Alexey Starikovskiy wrote:
>   
>> May I keep them inline?
>>     
>
> The problem with such manual inlines is that we force gcc to always 
> inline them - and history has shown that functions grow without the 
> "inline" being removed.
>
>   
> And for static functions gcc should (at least in theory) know best when 
> to inline them.
>
>   
Right. Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>

As I understand, you have some automation tools for finding out these
non-static functions, etc; are they available somewhere?

Regards,
Alex.
>> Thanks,
>> Alex.
>> Adrian Bunk wrote:
>>     
>>> This patch makes the following functions static instead of global inline:
>>> - acpi_battery_present()
>>> - acpi_battery_units()
>>>
>>> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>>>
>>> ---
>>>
>>>  drivers/acpi/battery.c |    4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> 9cfc2b0a3162d8e2f23537faefb6937c97513f38 foobar
>>> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
>>> index f6215e8..d941c5a 100644
>>> --- a/drivers/acpi/battery.c
>>> +++ b/drivers/acpi/battery.c
>>> @@ -116,7 +116,7 @@ struct acpi_battery {
>>>   #define to_acpi_battery(x) container_of(x, struct acpi_battery, bat);
>>>  -inline int acpi_battery_present(struct acpi_battery *battery)
>>> +static int acpi_battery_present(struct acpi_battery *battery)
>>>  {
>>>  	return battery->device->status.battery_present;
>>>  }
>>> @@ -235,7 +235,7 @@ static enum power_supply_property energy_battery_props[] = {
>>>  #endif
>>>   #ifdef CONFIG_ACPI_PROCFS_POWER
>>> -inline char *acpi_battery_units(struct acpi_battery *battery)
>>> +static char *acpi_battery_units(struct acpi_battery *battery)
>>>  {
>>>  	return (battery->power_unit)?"mA":"mW";
>>>  }
>>>       
>
> cu
> Adrian
>
>   

