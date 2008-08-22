Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbYHVVLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbYHVVLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 17:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758669AbYHVVLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 17:11:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758668AbYHVVLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 17:11:34 -0400
Date: Fri, 22 Aug 2008 14:10:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Philip Langdale <philipl@overt.org>
Cc: linux-kernel@vger.kernel.org, hmh@hmh.eng.br, mjg59@srcf.ucam.org,
       toshiba_acpi@memebeam.org, ivdoorn@gmail.com,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
 through rfkill (v6)
Message-Id: <20080822141045.488f9334.akpm@linux-foundation.org>
In-Reply-To: <48AB8902.3010406@overt.org>
References: <48AB8902.3010406@overt.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> User-Agent: Thunderbird 2.0.0.16 (X11/20080707)

uh-oh.

On Tue, 19 Aug 2008 20:01:22 -0700
Philip Langdale <philipl@overt.org> wrote:

> There's been a patch floating around for toshiba_acpi that exports an ad-hoc
> /proc interface to toggle the bluetooth adapter in a large number of Toshiba
> laptops. I'm not sure if it's still relevant for the latest models, but it is
> still required for older models such as my Tecra M3.
> 
> This change pulls in the low level Toshiba-specific code from the old patch and
> sets up an rfkill device and a polled input device to track the state of the
> hardware kill-switch.
> 
> Signed-off-by: Philip Langdale <philipl@overt.org>
> ---
>   Kconfig        |    1
>   toshiba_acpi.c |  263 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
> 
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 735f5ea..047829c 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -260,6 +260,7 @@ config ACPI_ASUS
>   config ACPI_TOSHIBA
>   	tristate "Toshiba Laptop Extras"
>   	depends on X86
> +	select INPUT_POLLDEV
>   	select BACKLIGHT_CLASS_DEVICE
>   	---help---
>   	  This driver adds support for access to certain system settings
> diff --git a/drivers/acpi/toshiba_acpi.c b/drivers/acpi/toshiba_acpi.c
> index 0a43c8e..5723019 100644
> --- a/drivers/acpi/toshiba_acpi.c
> +++ b/drivers/acpi/toshiba_acpi.c
> @@ -3,6 +3,7 @@
>    *
>    *
>    *  Copyright (C) 2002-2004 John Belmonte
> + *  Copyright (C) 2008 Philip Langdale

your email client is performing space-stuffing.  Please see
Documentation/email-clients.txt.

Please pass the patch through scripts/checkpatch.pl.  It finds a large
number of errors.

Please consistently put a single blank line between end-of-locals and
start-of-code.  Avoid randomness like:

> +static void bt_poll_rfkill(struct input_polled_dev *poll_dev)
> +{
> +	bool state_changed;
> +	bool new_rfk_state;
> +	bool value;
> +	u32 hci_result;
> +
> +	struct toshiba_acpi_dev *dev = poll_dev->private;
> +
> +	hci_result = hci_get_radio_state(&value);
>

The code uses new-style `bool' but it also adds at least one usage of
the old-style `FALSE'.

