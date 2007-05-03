Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbXECHGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbXECHGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 03:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755053AbXECHGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 03:06:04 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755218AbXECHGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 03:06:01 -0400
Date: Thu, 3 May 2007 00:05:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Fulghum <paulkf@microgate.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] synclink_gt use dynamic tty device registration
Message-Id: <20070503000528.7d841ecc.akpm@linux-foundation.org>
In-Reply-To: <1178122653.4485.2.camel@amdx2.microgate.com>
References: <1178122653.4485.2.camel@amdx2.microgate.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 May 2007 11:17:33 -0500 Paul Fulghum <paulkf@microgate.com> wrote:

> Change synclink_gt driver to use dynamic tty device registration.
> 
> ...
>
> +	for (i=0; i < port_count; ++i)
> +		tty_register_device(serial_driver, port_array[i]->line, &(port_array[i]->pdev->dev));
> ...
> +		for (info=slgt_device_list ; info != NULL ; info=info->next_device)
> +			tty_unregister_device(serial_driver, info->line);
> ...
> +	if ((rc = pci_register_driver(&pci_driver)) < 0) {

hm, not a big fan of kernel coding style, I see.

What's going to happen here if tty_register_device() fails?
