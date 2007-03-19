Return-Path: <linux-kernel-owner+w=401wt.eu-S1751276AbXCSKR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbXCSKR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 06:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbXCSKR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 06:17:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbXCSKR0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 06:17:26 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] drivers/usb/misc/iowarrior.c: NULL dereference
Date: Mon, 19 Mar 2007 11:17:09 +0100
User-Agent: KMail/1.9.1
Cc: Adrian Bunk <bunk@stusta.de>, Christian Lucht <lucht@codemercs.com>,
       Robert Marquardt <marquardt@codemercs.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <20070319092533.GN752@stusta.de>
In-Reply-To: <20070319092533.GN752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703191117.12011.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 19. März 2007 10:25 schrieb Adrian Bunk:

> static ssize_t iowarrior_write(struct file *file,
>                                const char __user *user_buffer,
>                                size_t count, loff_t *ppos)
> {
> ...
>                 if (!int_out_urb) {
>                         retval = -ENOMEM;
>                         dbg("%s Unable to allocate urb ", __func__);
>                         goto error;
> ...
> error:
>         usb_buffer_free(dev->udev, dev->report_size, buf,
>                         int_out_urb->transfer_dma);
> ...                     ^^^^^^^^^^^^^^^^^^^^^^^^^

Yes, that's a bug. The fix is compiling.

	Regards
		Oliver
