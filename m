Return-Path: <linux-kernel-owner+w=401wt.eu-S937045AbXFGVjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937045AbXFGVjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935341AbXFGVjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:39:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46339 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764124AbXFGVjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:39:21 -0400
Date: Thu, 7 Jun 2007 14:38:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Doug Thompson <norsk5@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 9/36] drivers edac new intel 5000X mc driver
Message-Id: <20070607143840.d259a4c1.akpm@linux-foundation.org>
In-Reply-To: <404349.85191.qm@web50103.mail.re2.yahoo.com>
References: <404349.85191.qm@web50103.mail.re2.yahoo.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2007 07:40:26 -0700 (PDT)
Doug Thompson <norsk5@yahoo.com> wrote:

> From:	Eric Wollesen <ericw@xmtp.net>
> 
> Eric Wollesen ported the Bluesmoke Memory Controller driver (written by
> Doug Thompson) for the Intel 5000X/V/P (Blackford/Greencreek) 
> chipset to the in kernel EDAC model.
> 
> This patch incorporates the module for the 5000X/V/P chipset family
> 
> ...
>
> +static void i5000_get_error_info(struct mem_ctl_info *mci,
> +				 struct i5000_error_info * info)
> +{
> +	struct i5000_pvt *pvt;
> +	u32 value;
> +
> +	pvt = (struct i5000_pvt *)mci->pvt_info;

pvt_info is (correctly) void *, so this cast is unneeded

> +static void i5000_process_fatal_error_info(struct mem_ctl_info *mci,
> +					   struct i5000_error_info * info,

s/* /*/

> + * i5000_process_fatal_error_info(struct mem_ctl_info *mci,
> + * 				  struct i5000_error_info *info,
> + * 				  int handle_errors);
> + *
> + *	handle the Intel NON-FATAL errors, if any
> + */
> +static void i5000_process_nonfatal_error_info(struct mem_ctl_info
> *mci,
> +					      struct i5000_error_info * info,

ditto (please check whole patch)

(I thought checkpatch.pl would catch this, but it doesn't?)

> +
> +/******************************************************************************

The zillion-asterisks can be removed from all these comments.

> + *	i5000_put_devices	'put' all the devices that we have
> + *				reserved via 'get'
> + */
> +static void i5000_put_devices(struct mem_ctl_info *mci)
> +{
> +	struct i5000_pvt *pvt;
> +
> +	pvt = (struct i5000_pvt *)mci->pvt_info;

Unneeded cast.

> +	pci_dev_put(pvt->branchmap_werrors);	/* FUNC 1 */
> +	pci_dev_put(pvt->fsb_error_regs);	/* FUNC 2 */
> +	pci_dev_put(pvt->branch_0);	/* DEV 21 */
> +
> +	/* Only if more than 2 channels do we release the second branch */
> +	if (pvt->maxch >= CHANNELS_PER_BRANCH) {
> +		pci_dev_put(pvt->branch_1);	/* DEV 22 */
> +	}

Unneeded braces.

