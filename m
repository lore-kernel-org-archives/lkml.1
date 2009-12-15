Return-Path: <linux-kernel-owner+w=401wt.eu-S1761773AbZLOXNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761773AbZLOXNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934203AbZLOXNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:13:25 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:18858 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934184AbZLOXNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:13:20 -0500
Date: Tue, 15 Dec 2009 15:12:13 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Keith Mannthey <kmannth@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode drive -v2
Message-Id: <20091215151213.8b357858.randy.dunlap@oracle.com>
In-Reply-To: <1260907788.6521.10.camel@keith-laptop>
References: <1260907788.6521.10.camel@keith-laptop>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B2817FF.0193:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 12:09:48 -0800 Keith Mannthey wrote:

> diff -urN linux-2.6.32/drivers/misc/ibmrtl/rtl.h linux-2.6.32-rtl/drivers/misc/ibmrtl/rtl.h
> --- linux-2.6.32/drivers/misc/ibmrtl/rtl.h	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.32-rtl/drivers/misc/ibmrtl/rtl.h	2009-12-11 10:24:23.000000000 -0800
> @@ -0,0 +1,27 @@
> +#include <linux/io.h>
> +
> +/* The RTL table looks something like

Is this documented somewhere?  (besides here ;)

> +	u8 signature[5];
> +	u8 version;
> +	u8 RT_Status;
> +	u8 Command;
> +	u8 CommandStatus;
> +	u8 CMDAddressType;
> +	u8 CmdGranularity;
> +	u8 CmdOffset;
> +	u16 Reserve1;
> +	u8 CmdPortAddress[4];
> +	u8 CmdPortValue[4];
> +*/
> +#define RTL_TABLE_SIZE 0x16
> +#define RTL_MAGIC_IDENT (('L'<<24)|('T'<<16)|('R'<<8)|'_')
> +#define RTL_VERSION 0x5
> +#define RTL_STATE 0x6
> +#define RTL_CMD 0x7
> +#define RTL_CMD_STATUS 0x8
> +#define RTL_CMD_PORT_ADDR 0xE
> +#define RTL_CMD_PORT_VALUE 0x12
> +
> +#define EDBA_ADDR 0x40E
> +#define RTL_ENABLE 1
> +#define RTL_DISABLE 2
> diff -urN linux-2.6.32/drivers/misc/Kconfig linux-2.6.32-rtl/drivers/misc/Kconfig
> --- linux-2.6.32/drivers/misc/Kconfig	2009-12-02 19:51:21.000000000 -0800
> +++ linux-2.6.32-rtl/drivers/misc/Kconfig	2009-12-11 10:24:23.000000000 -0800
> @@ -76,6 +76,22 @@
>  	  information on the specific driver level and support statement
>  	  for your IBM server.
>  
> +config IBM_RTL
> +        tristate "Device driver to enable IBM PRTL support"
> +        depends on X86_MPPARSE && PCI && EXPERIMENTAL
> +        ---help---
> +	  Enable support for IBM Premium Real Time Mode (PRTM).
> +	  This module will allow you the enter and exit PRTM in the BIOS via
> +	  sysfs on platforms that support this feature.  System in PRTM will
> +	  not receive cpu generated SMIs for recoverable errors.  Use of this

	              CPU-generated

> +	  feature without proper support may void your hardware warranty.
> +
> +	  If the proper bios support is found the driver will load and create

	                BIOS

> +	  /sys/devices/system/ibm_rtl/.  The "state" variable will indicate
> +	  weather or not the BIOS is in PRTM.
> +	  state = 0 (BIOS SMI's on)
> +	  state = 1 (BIOS SMI's off)
> +
>  config PHANTOM
>  	tristate "Sensable PHANToM (PCI)"
>  	depends on PCI


---
~Randy
