Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbZI0Rc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbZI0Rc2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 13:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbZI0Rc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 13:32:27 -0400
Received: from netrider.rowland.org ([192.131.102.5]:38028 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751299AbZI0Rc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 13:32:27 -0400
Date: Sun, 27 Sep 2009 13:32:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [linux-pm] [PATCH, fix] Re: [Regression] 2.6.31-git: tty change
 broke resume from hibernation on MSI Wind U100
In-Reply-To: <200909271800.43066.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0909271329400.5871-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Sep 2009, Rafael J. Wysocki wrote:

> Tested, works.
> 
> Greg, could you please consider taking the patch below?  It fixes a recent
> hibernation regression for me, so if not this one, another fix is necessary.

This patch has a mistake.

> Index: linux-2.6/drivers/usb/serial/usb-serial.c
> ===================================================================
> --- linux-2.6.orig/drivers/usb/serial/usb-serial.c
> +++ linux-2.6/drivers/usb/serial/usb-serial.c
> @@ -1210,7 +1210,7 @@ static const struct tty_operations seria
>  	.chars_in_buffer =	serial_chars_in_buffer,
>  	.tiocmget =		serial_tiocmget,
>  	.tiocmset =		serial_tiocmset,
> -	.shutdown = 		serial_release,
> +	.cleanup = 		serial_release,
>  	.install = 		serial_install,
>  	.proc_fops =		&serial_proc_fops,
>  };

It isn't enough to change the method pointer.  The code in 
serial_release() has to be changed too; it must not call tty_shutdown() 
any more.

Alan Stern

