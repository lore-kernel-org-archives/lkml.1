Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbXEYAHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbXEYAHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 20:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbXEYAHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 20:07:04 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805AbXEYAHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 20:07:03 -0400
Date: Thu, 24 May 2007 17:06:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make prepare_namespace() wait for devices
Message-Id: <20070524170654.5d674474.akpm@linux-foundation.org>
In-Reply-To: <4655834F.3050301@drzeus.cx>
References: <4655834F.3050301@drzeus.cx>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 14:21:35 +0200
Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> +	/* wait for any asynchronous scanning to complete */
> +	if ((ROOT_DEV == 0) && root_wait) {
> +		printk(KERN_INFO "Waiting for root device %s...\n",
> +			saved_root_name);
> +		do {
> +			while (driver_probe_done() != 0)
> +				msleep(100);
> +			ROOT_DEV = name_to_dev_t(saved_root_name);
> +			if (ROOT_DEV == 0)
> +				msleep(100);
> +		} while (ROOT_DEV == 0);
> +	}

This seems overly complex.  Can't we simply do


	while (driver_probe_done() || ROOT_DEV == 0)
		msleep(100);

?
