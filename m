Return-Path: <linux-kernel-owner+w=401wt.eu-S1759989AbXEJMhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989AbXEJMhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbXEJMhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:37:42 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:63436 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751349AbXEJMhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:37:41 -0400
Date: Thu, 10 May 2007 14:37:37 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: Flush mmc workqueue late in the boot sequence
Message-ID: <20070510143737.54969394@dhcp-252-105.norway.atmel.com>
In-Reply-To: <46430A49.9090803@drzeus.cx>
References: <117879333788-git-send-email-hskinnemoen@atmel.com>
	<46430A49.9090803@drzeus.cx>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 14:04:25 +0200
Pierre Ossman <drzeus@drzeus.cx> wrote:

> Haavard Skinnemoen wrote:
> > At some point before 2.6.20, the mmc subsystem moved the card
> > detection code to its own workqueue. One consequence of this change
> > is that when using an mmc card as a root device, the card may get
> > detected after the init task attempts to mount the root filesystem,
> > causing a kernel panic because the root device could not be opened.
> > 
> > This patch adds a call to mmc_flush_scheduled_work() late in the boot
> > sequence so that we can be sure the mmc card detection scans are
> > complete before attempting to use an mmc device as a root device.
> > 
> > Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> 
> NAK. This is still hackish and not a reliable, controlled way of handling the
> issue of rootfs on removable media.

What exactly makes this unreliable? This is done almost exactly the
same way for SCSI. See drivers/scsi/scsi_wait_scan.c.

> For reference, how is this handled in USB (which is conceptually identical)? The
> normal case for removable media is usually an initrd that can wait for hotplug
> events.

I don't know about USB, but root=/dev/mmcblk0p1 used to work before
2.6.20 and it doesn't work anymore. Doesn't that make this a regression?

Haavard
