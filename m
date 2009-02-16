Return-Path: <linux-kernel-owner+w=401wt.eu-S1751586AbZBPPSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbZBPPSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 10:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbZBPPSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 10:18:14 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:42546 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbZBPPSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 10:18:13 -0500
Date: Mon, 16 Feb 2009 15:18:09 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alexandre Rostovtsev <tetromino@gmail.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lenovo-sl-laptop : driver for review
Message-ID: <20090216151809.GA4724@srcf.ucam.org>
References: <20090216025918.66d7a466@leftboat.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216025918.66d7a466@leftboat.lan>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 02:59:18AM -0500, Alexandre Rostovtsev wrote:

> +Fn F9 (eject):			KEY_EJECTCD (161)

No - this is a dock eject key, not a CD eject key.

> +Fn F12 (hibernate):		KEY_SUSPEND (205)

> +/sys/devices/platform/lenovo-sl-laptop/rfkill/rfkill*/
> + The bluetooth rfkill. state is the switch state (0 for bluetooth off,
> + 1 for bluetooth on).
> + Note that in case future versions of the driver add other rfkill switches,
> + userspace programs should check that the rfkill name is lensl_bluetooth_sw

Surely they should just be checking the rfkill type?

> +control_backlight:
> + If this parameter is set to 1, this driver will intercept brightness keys
> + (Fn+Home and Fn+End) and control the backlight brightness. This feature is
> + useful because the default ACPI video driver currently has poor support
> + for the Lenovo SL series. If you enable this feature, you should add
> + acpi_backlight=vendor

Please don't do that - the kernel shouldn't be consuming the brightness 
events itself, that should be left up to userspace. The ACPI video 
driver is broken in this respect.

> +static struct device_attribute dev_attr_bluetooth_enable =
> +	__ATTR(bluetooth_enable, S_IWUSR | S_IRUGO,
> +		bluetooth_enable_show, bluetooth_enable_store);

You support rfkill, so I'm not sure there's a benefit in exposing the 
same functionality via a custom sysfs node.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
