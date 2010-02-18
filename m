Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab0BRRr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 12:47:57 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:47619 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529Ab0BRRry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 12:47:54 -0500
Message-ID: <4B7D7CD0.7080202@oracle.com>
Date: Thu, 18 Feb 2010 09:45:52 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Denis Turischev <denis@compulab.co.il>
CC: LKML <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jean Delvare <khali@linux-fr.org>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2 1/3] MFD: introduce lpc_sch for Intel SCH LPC bridge
References: <4B73DAEE.5080400@compulab.co.il> <4B73DB4B.40501@compulab.co.il> <4B7D7C13.20703@compulab.co.il>
In-Reply-To: <4B7D7C13.20703@compulab.co.il>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B7D7D28.0240:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/10 09:42, Denis Turischev wrote:
> Intel Poulsbo (SCH) chipset LPC bridge controller contains several
> functions. Creating and MFD driver for the LPC bridge controller allows
> simultaneous use of SMBus and GPIO interfaces on the SCH.
> 
> v2 version contains "select MFD_CORE" line.
> 
> Signed-off-by: Denis Turischev <denis@compulab.co.il>
> 
> diff -Nru linux-2.6.33-rc7.orig/drivers/mfd/Kconfig
> linux-2.6.33-rc7/drivers/mfd/Kconfig
> --- linux-2.6.33-rc7.orig/drivers/mfd/Kconfig    2010-02-07
> 00:17:12.000000000 +0200
> +++ linux-2.6.33-rc7/drivers/mfd/Kconfig    2010-02-18
> 19:32:01.000000000 +0200
> @@ -348,6 +348,15 @@
>        read/write functions for the devices to get access to this chip.
>        This chip embeds various other multimedia funtionalities as well.
> 
> +config LPC_SCH
> +    tristate "Intel SCH LPC"
> +    default m

Please don't default random modules to be enabled/built.
That could be done via defconfig .. if at all.

> +    depends on PCI
> +    select MFD_CORE
> +    help
> +      LPC bridge function of the Intel SCH provides support for
> +      System Management Bus and General Purpose I/O.
> +
>  endmenu
> 
>  menu "Multimedia Capabilities Port drivers"


-- 
~Randy
