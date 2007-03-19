Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbXCSJ0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbXCSJ0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbXCSJ0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:26:10 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34841 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753310AbXCSJZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:25:30 -0400
Date: Mon, 19 Mar 2007 10:25:33 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Christian Lucht <lucht@codemercs.com>,
       Robert Marquardt <marquardt@codemercs.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: drivers/usb/misc/iowarrior.c: NULL dereference
Message-ID: <20070319092533.GN752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following NULL dereference:

<--  snip  -->

...
static ssize_t iowarrior_write(struct file *file,
                               const char __user *user_buffer,
                               size_t count, loff_t *ppos)
{
...
                if (!int_out_urb) {
                        retval = -ENOMEM;
                        dbg("%s Unable to allocate urb ", __func__);
                        goto error;
...
error:
        usb_buffer_free(dev->udev, dev->report_size, buf,
                        int_out_urb->transfer_dma);
...                     ^^^^^^^^^^^^^^^^^^^^^^^^^

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

