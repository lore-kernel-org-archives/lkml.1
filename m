Return-Path: <linux-kernel-owner+w=401wt.eu-S1422829AbXBALtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422829AbXBALtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422826AbXBALtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:49:45 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46886 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422825AbXBALto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:49:44 -0500
Date: Thu, 1 Feb 2007 12:02:08 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: "Aubrey Li" <aubreylee@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [BUG]: 2.6.19.2: Weird serial core issue
Message-ID: <20070201120208.36ccb530@localhost.localdomain>
In-Reply-To: <6d6a94c50701311833m5952c6fdn8e1f0db28d674e79@mail.gmail.com>
References: <6d6a94c50701310249o2b2c8024i4d3f28ec1601246a@mail.gmail.com>
	<20070131162123.67e22e23@localhost.localdomain>
	<6d6a94c50701311833m5952c6fdn8e1f0db28d674e79@mail.gmail.com>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I implemented the serial driver by myself, :). See the attachment.
> I didn't save/restore terminal setting in the my_set_termios().

Driver looks fine. 

> I trace this back till tty_tioctl(..., unsigned long arg), everytime I
> type "ENTER" key,
> the argument "arg" passed into tty_ioctl() is the address of a termios
> structure, which include wrong c_cflag. It seems once the flag is
> assigned by uart_set_options the first time, it's never changed. So
> even userspace application changed the flag, it will be set back soon.
> I'll dig into it. But I still think it's a bug.

Which application (see from current->pid) seems to be calling the
tty_ioctl with the "wrong flag" ?
