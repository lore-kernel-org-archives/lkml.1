Return-Path: <linux-kernel-owner+w=401wt.eu-S1161778AbXECPBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161778AbXECPBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161835AbXECPBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:01:43 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:38520
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161778AbXECPBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:01:42 -0400
Subject: Re: [PATCH] synclink_gt use dynamic tty device registration
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070503000528.7d841ecc.akpm@linux-foundation.org>
References: <1178122653.4485.2.camel@amdx2.microgate.com>
	 <20070503000528.7d841ecc.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 03 May 2007 10:00:55 -0500
Message-Id: <1178204455.3516.8.camel@amdx2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.3 (2.2.3-4.fc4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-03 at 00:05 -0700, Andrew Morton wrote:
> On Wed, 02 May 2007 11:17:33 -0500 Paul Fulghum <paulkf@microgate.com> wrote:
> 
> > Change synclink_gt driver to use dynamic tty device registration.
> > 
> > ...
> >
> > +	for (i=0; i < port_count; ++i)
> > +		tty_register_device(serial_driver, port_array[i]->line, &(port_array[i]->pdev->dev));
> > ...
> > +		for (info=slgt_device_list ; info != NULL ; info=info->next_device)
> > +			tty_unregister_device(serial_driver, info->line);
> > ...
> > +	if ((rc = pci_register_driver(&pci_driver)) < 0) {
> 
> hm, not a big fan of kernel coding style, I see.

It varies. If this idiom bothers you, I can split it into 2 lines.

> What's going to happen here if tty_register_device() fails?

Then the device will not be accessible as a tty device.
It may still be accessible as a network device.
On driver unload, tty_unregister_device() does nothing because
the device was never created.

In this case, tracking the return value does not change anything.
I could add a printk on error to better inform the user that the
kernel's plumbing went south.

-- 
Paul Fulghum
Microgate Systems, Ltd

