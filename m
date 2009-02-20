Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbZBTBHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbZBTBHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 20:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758245AbZBTBHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 20:07:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758194AbZBTBHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 20:07:23 -0500
Date: Thu, 19 Feb 2009 17:07:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mike.miller@hp.com
Subject: Re: [GIT PULL] block bits for 2.6.29-rc5
Message-Id: <20090219170715.47781cc2.akpm@linux-foundation.org>
In-Reply-To: <20090218144105.GZ30821@kernel.dk>
References: <20090218144105.GZ30821@kernel.dk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Feb 2009 15:41:06 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

> @@ -3404,6 +3601,24 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
>  	int dac, return_code;
>  	InquiryData_struct *inq_buff = NULL;
>  
> +	if (reset_devices) {
> +		/* Reset the controller with a PCI power-cycle */
> +		if (cciss_hard_reset_controller(pdev) || cciss_reset_msi(pdev))
> +			return -ENODEV;
> +
> +		/* Some devices (notably the HP Smart Array 5i Controller)
> +		   need a little pause here */
> +		schedule_timeout_uninterruptible(30*HZ);

little!

Perhaps we should do a printk("no, your machine is not dead") here.
