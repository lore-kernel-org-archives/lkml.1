Return-Path: <linux-kernel-owner+w=401wt.eu-S1762540AbXGCVqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762540AbXGCVqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758471AbXGCVqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:46:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46503 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760022AbXGCVqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:46:09 -0400
Date: Tue, 3 Jul 2007 14:45:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: bo yang <bo.yang@lsi.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, neela.kolli@lsi.com, sumant.patro@lsi.com
Subject: Re: [PATCH 2/4] scsi: megaraid_sas -- add module param fast_load
Message-Id: <20070703144522.6b65f626.akpm@linux-foundation.org>
In-Reply-To: <1183308153.4723.8.camel@dhcp-75-197.se.lsil.com>
References: <1183308153.4723.8.camel@dhcp-75-197.se.lsil.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Jul 2007 12:42:33 -0400
bo yang <bo.yang@lsi.com> wrote:

> Driver will skip physical devices scan for the first time if the
> fast_load is set.
> 

All your patches are wordwrapped and will need to be resent.

Also, there are multiple trivial errors in here, pretty much all of which
would have been detected had you run scripts/checkpatch.pl across the
diffs:

> + */
> +static unsigned int fast_load = 0;

Unneeded initialisation

> +static int megasas_slave_alloc(struct scsi_device *sdev) {

Missing newline

> +	struct megasas_instance *instance ;

unneeded space

> +	int tmp_fastload = fast_load;
> +	instance = megasas_lookup_instance(sdev->host->host_no);

Missing blank line.

> +	if (tmp_fastload && sdev->channel < MEGASAS_MAX_PD_CHANNELS) {
> +		if ((sdev->id == MEGASAS_MAX_DEV_PER_CHANNEL -1) &&
> +			(sdev->channel == MEGASAS_MAX_PD_CHANNELS - 1)) {
> +			/* If fast load option was set and scan for last device is
> +			 * over, reset the fast_load flag so that during a possible
> +			 * next scan, devices can be made available
> +			 */
> +			fast_load = 0;
> +		}
> +		return -ENXIO;
> +	}
> +
> +	return 0;
> +}
> +

