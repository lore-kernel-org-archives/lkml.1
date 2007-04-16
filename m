Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbXDPUYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbXDPUYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 16:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbXDPUY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 16:24:29 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3099 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbXDPUY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 16:24:29 -0400
Date: Mon, 16 Apr 2007 21:24:21 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Anton Vorontsov <cbou@mail.ru>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: Re: [PATCH 7/7] [RFC] APM emulation driver for class batteries
Message-ID: <20070416202421.GC19713@flint.arm.linux.org.uk>
Mail-Followup-To: Anton Vorontsov <cbou@mail.ru>,
	linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
References: <20070411232644.GG20095@zarina> <20070413135005.GE20618@zarina>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413135005.GE20618@zarina>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 05:50:43PM +0400, Anton Vorontsov wrote:
> +static void (*old_apm_get_power_status)(struct apm_power_info*);
> +
> +static int __init apm_battery_init(void)
> +{
> +	printk(KERN_INFO "APM Battery Driver\n");
> +
> +	old_apm_get_power_status = apm_get_power_status;
> +	apm_get_power_status = apm_battery_apm_get_power_status;
> +	return 0;
> +}
> +
> +static void __exit apm_battery_exit(void)
> +{
> +	apm_get_power_status = old_apm_get_power_status;
> +	return;
> +}

Utterly unsafe.  What happens if some other module gets loaded which
does this, and then this module is unloaded followed by the other
module.  Result: Oops.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
