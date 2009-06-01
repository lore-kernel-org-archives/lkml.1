Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbZFAWJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbZFAWJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 18:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbZFAWJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 18:09:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211AbZFAWJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 18:09:03 -0400
Date: Mon, 1 Jun 2009 15:08:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       joerg.roedel@amd.com
Subject: Re: [PATCH 3/4] dma-debug: add dma_debug_driver kernel command line
Message-Id: <20090601150813.84c932f4.akpm@linux-foundation.org>
In-Reply-To: <1243523971-12681-4-git-send-email-joerg.roedel@amd.com>
References: <1243523971-12681-1-git-send-email-joerg.roedel@amd.com>
	<1243523971-12681-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 17:19:30 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> This patch add the dma_debug_driver= boot parameter to enable the driver
> filter for early boot.
> 

Please always update Documentation/kernel-parameters.txt when adding
new boot options.

> +static int __init parse_dma_debug_driver(char *str)
> +{
> +	int i;
> +
> +	for (i = 0; i < NAME_MAX_LEN - 1; ++i, ++str) {
> +		current_driver_name[i] = *str;
> +		if (*str == ' ' || *str == '\t' || isspace(*str) || *str == 0)

The comparisons with ' ' and '\t' are unneeded, surely?

> +			break;
> +	}
> +	current_driver_name[i] = 0;
> +
> +	if (current_driver_name[0])
> +		printk(KERN_INFO "DMA-API: enable driver filter for "
> +				 "driver [%s]\n", current_driver_name);
> +
> +
> +	return 1;
> +}
> +__setup("dma_debug_driver=", parse_dma_debug_driver);

The whole thing seems a bit overdone - take a look at some other __setup
functions, see what they're doing.  None of them bother looking for
spaces in the input - higher level code took care of that.

It's conventional for the name of a __setup function to end in "_setup".
