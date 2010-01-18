Return-Path: <linux-kernel-owner+w=401wt.eu-S1754289Ab0ARWV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab0ARWV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 17:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078Ab0ARWV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 17:21:28 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56876 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752064Ab0ARWV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 17:21:27 -0500
Date: Mon, 18 Jan 2010 22:24:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, alan@linux.intel.com,
       charles.f.johnson@intel.com, Mark Allyn <mark.a.allyn@intel.com>
Subject: Re: [PATCH] Add Linux Driver for Intel Langwell Watchdog
Message-ID: <20100118222400.2b8fa0c2@lxorguk.ukuu.org.uk>
In-Reply-To: <1263849859-23265-1-git-send-email-mark.a.allyn@intel.com>
References: <1263849859-23265-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	/* send the threshold and soft_threshold via IPC to the Lincroft */
> +	reg_data.payload1 = watchdog_device.soft_threshold;
> +	reg_data.payload2 = watchdog_device.threshold;
> +	ipc_set_watchdog(&reg_data);

That still doesn't seem to be merged upstream - someone needs poking to
at least get an IPC driver into staging.


> + * /dev/watchdog handling
> + */
> +static int langwell_open(struct inode *inode, struct file *file)
> +{
> +	/* Miscdevice structure pointer already saved in private_data */
> +
> +	struct watchdog_reg_data reg_data;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;

File permissions will deal with that bit

> +
> +	if (test_and_set_bit(0, &watchdog_device.driver_open))
> +		return -ENOTTY;

EBUSY

