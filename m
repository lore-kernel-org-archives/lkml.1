Return-Path: <linux-kernel-owner+w=401wt.eu-S1758436AbXK0A3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436AbXK0A3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 19:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757138AbXK0A24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 19:28:56 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:48118 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757086AbXK0A2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:28:55 -0500
Date: Tue, 27 Nov 2007 01:29:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] Hibernation: Move low level resume to disk.c
Message-ID: <20071127002929.GF9759@elf.ucw.cz>
References: <200711270025.08128.rjw@sisk.pl> <200711270029.11185.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711270029.11185.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Move the low level restore code to kernel/power/disk.c , since the
> corresponding low level hibernation code is already there.
> 
> Make restore fail if device_power_down(PMSG_PRETHAW) returns an
> error.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Move looks ok to me.


>  /**
> + *	resume_target_kernel - prepare devices that need to be suspended with
> + *	interrupts off, restore the contents of highmem that have not been
> + *	restored yet from the image and run the low level code that will restore
> + *	the remaining contents of memory and switch to the just restored target
> + *	kernel.
> + */
> +
> +static int resume_target_kernel(void)
> +{
> +	int error;
> +
> +	local_irq_disable();
> +	error = device_power_down(PMSG_PRETHAW);
> +	if (error) {
> +		printk(KERN_ERR "Some devices failed to power down, "
> +			KERN_ERR "aborting resume\n");
> +		goto Enable_irqs;

Too many KERN_ERR's ;-). Plus... are you sure this does the right
thing? ... .. ... yes, it does. If one device fails,
device_power_down() powers up the rest using dpm_power_up(). Good.

ACK... modulo double KERN_ERR.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
