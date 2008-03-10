Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbYCJXHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbYCJXHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 19:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYCJXHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 19:07:24 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:14862 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbYCJXHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:07:23 -0400
Date: Mon, 10 Mar 2008 16:06:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>, linux-acpi@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: acer-wmi uses input:i8042_command() => build error
Message-Id: <20080310160649.5d225ac7.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0803102227540.18589@twin.jikos.cz>
References: <20080310124754.4ec3f24d.randy.dunlap@oracle.com>
	<200803101959.06441.carlos@strangeworlds.co.uk>
	<Pine.LNX.4.64.0803102227540.18589@twin.jikos.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 22:29:37 +0100 (CET) Jiri Kosina wrote:

> On Mon, 10 Mar 2008, Randy Dunlap wrote:
> 
> > drivers/built-in.o: In function `set_u32':
> > acer-wmi.c:(.text+0xb9bf6): undefined reference to `i8042_command'
> > make[1]: *** [vmlinux] Error 1
> > make: *** [sub-make] Error 2
> 
> Does the patch below fix your build?

Yes, thanks.
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> From: Jiri Kosina <jkosina@suse.cz>
> 
> Acer-wmi dependends on i8042 code.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> --- 
>  drivers/misc/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 982e27b..962817e 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -108,6 +108,7 @@ config ACER_WMI
>  	depends on ACPI
>  	depends on LEDS_CLASS
>  	depends on BACKLIGHT_CLASS_DEVICE
> +	depends on SERIO_I8042
>  	select ACPI_WMI
>  	---help---
>  	  This is a driver for newer Acer (and Wistron) laptops. It adds
> --

---
~Randy
