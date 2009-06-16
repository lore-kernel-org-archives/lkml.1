Return-Path: <linux-kernel-owner+w=401wt.eu-S1761496AbZFPWjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761496AbZFPWjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 18:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbZFPWjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 18:39:06 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:39635 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbZFPWjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 18:39:05 -0400
Date: Tue, 16 Jun 2009 15:34:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Peter Feuerer <peter@piie.net>
Cc: Andreas Mohr <andi@lisas.de>, Ed Tomlinson <edt@aei.ca>,
       Borislav Petkov <petkovbb@googlemail.com>, akpm@linux-foundation.org,
       Len Brown <len.brown@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Request driver inclusion - acer aspire one fan control
Message-Id: <20090616153453.05651d9d.randy.dunlap@oracle.com>
In-Reply-To: <20090617001435.e2d86780.peter@piie.net>
References: <20090604211103.4214303f.peter@piie.net>
	<cone.1245086149.988051.6046.1000@deskpiie>
	<20090616060107.GA4752@liondog.tnic>
	<200906160747.04094.edt@aei.ca>
	<20090616205747.GA6356@rhlx01.hs-esslingen.de>
	<20090617001435.e2d86780.peter@piie.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt008.oracle.com [141.146.116.17]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.4A381ED5.0059:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009 00:14:35 +0200 Peter Feuerer wrote:

> Hi,
> 
> Andreas, I applied and reviewd your patch and additionally changed following things:
> o added "acerhdf_enable_kernelmode" which is the opposite of your "acerhdf_revert_to_bios_mode".
> o suspend stops and resume starts the kernelmode in a clean way
> o some small bugfixes (e.g. Version of the terminator bios table entry has to be "" and not 0)...
> 
> I tested the patch with current linus git. Unfortunately does the current state of the kernel freeze my a1 after suspend/resume randomly (also without acerhdf). Anyways I was able to do 11 suspend / resume cycles with acerhdf loaded and kernelmode=on.
> 
> -- 
> Peter Feuerer <peter@piie.net>
> 
> 
> Acerhdf is a driver for Acer Aspire One netbooks. It allows to access
> the temperature sensor and to control the fan.
> 
> Signed-off-by: Peter Feuerer <peter@piie.net>
> Signed-off-by: Andreas Mohr <andi@lisas.de>
> Reviewed-by: Borislav Petkov <petkovbb@gmail.com>
> Tested-by: Borislav Petkov <petkovbb@gmail.com>
> 
> 
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index c682ac5..c768475 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -34,6 +34,23 @@ config ACER_WMI
>  	  If you have an ACPI-WMI compatible Acer/ Wistron laptop, say Y or M
>  	  here.
>  
> +config ACERHDF
> +	tristate "Acer Aspire One temperature and fan driver"
> +	depends on THERMAL && THERMAL_HWMON

	depends on ACPI

due to calling ec_read()

> +	---help---
> +	  This is a driver for Acer Aspire One netbooks. It allows to access
> +	  the temperature sensor and to control the fan.
> +
> +	  After loading this driver the BIOS is still in control of the fan.
> +	  To let the kernel handle the fan, do:
> +	  echo -n enabled > /sys/class/thermal/thermal_zone0/mode
> +
> +	  For more information about this driver see
> +	  <http://piie.net/files/acerhdf_README.txt>
> +
> +	  If you have an Acer Aspire One netbook, say Y or M
> +	  here.
> +
>  config ASUS_LAPTOP
>  	tristate "Asus Laptop Extras (EXPERIMENTAL)"
>  	depends on ACPI


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
