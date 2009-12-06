Return-Path: <linux-kernel-owner+w=401wt.eu-S933904AbZLFRBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933904AbZLFRBo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 12:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933886AbZLFRBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 12:01:42 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:34182 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933883AbZLFRBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 12:01:41 -0500
Message-ID: <4B1BF119.2020600@oracle.com>
Date: Sun, 06 Dec 2009 09:59:53 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Patrick Ringl <patrick_@freenet.de>
CC: linux-kernel@vger.kernel.org, alan@redhat.com
Subject: Re: [PATCH]: drivers/platform/x86/Kconfig - fix inconsistency
References: <4B1B1336.5020309@freenet.de>
In-Reply-To: <4B1B1336.5020309@freenet.de>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B1BE374.0163:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick Ringl wrote:
> Hi,
> 
> I just discovered an inconsistency in a Kconfig file. DELL_WMI as well
> as HP_WMI should not depend on ACPI_WMI but select it, as all the other
> WMI-related,  platform-specific device drivers like TC1100_WMI or
> ACER_WMI do.
> 
> This -as of right now- prevents the selection of the two initially
> mentioned drivers unless one, by chance, enables ACPI_WMI and then goes
> back.

Then you'll also need to add
	depends on ACPI
to both of those drivers.  Without this addition,
these drivers could enable ACPI_WMI even when ACPI
is not enabled.


> Signed-off-by: Patrick Ringl <patrick_@freenet.de>
> 
> --- linux-2.6.32-o/drivers/platform/x86/Kconfig    2009-12-03
> 04:51:21.000000000 +0100
> +++ linux-2.6.32/drivers/platform/x86/Kconfig    2009-12-06
> 02:32:47.000000000 +0100
> @@ -86,8 +86,8 @@
> 
> config DELL_WMI
>     tristate "Dell WMI extras"
> -    depends on ACPI_WMI
>     depends on INPUT
> +    select ACPI_WMI
>     ---help---
>       Say Y here if you want to support WMI-based hotkeys on Dell laptops.
> 
> @@ -133,9 +133,9 @@
> 
> config HP_WMI
>     tristate "HP WMI extras"
> -    depends on ACPI_WMI
>     depends on INPUT
>     depends on RFKILL || RFKILL = n
> +    select ACPI_WMI
>     help
>      Say Y here if you want to support WMI-based hotkeys on HP laptops and
>      to read data from WMI such as docking or ambient light sensor state.
> ---



-- 
~Randy
