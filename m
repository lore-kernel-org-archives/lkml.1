Return-Path: <linux-kernel-owner+w=401wt.eu-S1762644AbYBEWU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762644AbYBEWU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760028AbYBEWUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:20:19 -0500
Received: from cantor.suse.de ([195.135.220.2]:56152 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbYBEWUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:20:18 -0500
Date: Tue, 5 Feb 2008 14:18:05 -0800
From: Greg KH <gregkh@suse.de>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for review] ACPI: Create /sys/firmware/acpi/interrupts/
	counters
Message-ID: <20080205221805.GC6950@suse.de>
References: <200802050230.10873.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802050230.10873.lenb@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 02:30:10AM -0500, Len Brown wrote:
> # cat /sys/firmware/acpi/interrupts/summary
> pm_timer     0
> glbl_lock    0
> power_btn    0
> sleep_btn    0
> rtc          0
> gpe00    0
> gpe01    0
> gpe02    0
> gpe03    0
> gpe04    0
> gpe05    0
> gpe06    0
> gpe07    0
> gpe08    0
> gpe09    2
> gpe0A    0
> gpe0B    0
> gpe0C    0
> gpe0D    0
> gpe0E    0
> gpe0F    0
> gpe10    0
> gpe11   60
> gpe12    0
> gpe13    0
> gpe14    0
> gpe15    0
> gpe16    0
> gpe17    0
> gpe18    0
> gpe19    1
> gpe1A    0
> gpe1B    0
> gpe1C    0
> gpe1D    0
> gpe1E    0
> gpe1F    0
> gpe_hi    0
> gpe_total   63
> acpi_irq    63

Eeek!  Why?  What's wrong with individual files here?  What's to ensure
that you aren't going to overflow your buffer?  There's a reason we
don't have the seq file interface for sysfs, to prevent this very kind
of thing...


> +	/*
> +	 * General Purpose Events
> +	 */
> +	for (i = 0; i < number_of_gpes; i++) {
> +		count += sprintf(buf + count, "gpe%02X %4d\n",
> +			i, acpi_gpe_counters[i]);
> +	}

Nope, no error checking, fun chance of blowing the memory buffer :(

Please change the interface to not do this.

Oh, and for every new sysfs file, you need a Documentation/ABI/
addition, please also add that.

thanks,

greg k-h
