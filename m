Return-Path: <linux-kernel-owner+w=401wt.eu-S938054AbXG0Vd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938054AbXG0Vd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 17:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935789AbXG0VdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 17:33:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54795 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933586AbXG0VdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 17:33:21 -0400
Date: Fri, 27 Jul 2007 17:33:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: linux-serial@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Lockdep violation in the serial driver
Message-ID: <Pine.LNX.4.44L0.0707271726080.2810-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I want to make some changes to the Power Management core, and one of
the side effects will be to make it illegal for a driver to acquire a
mutex within its suspend() or resume() method if that mutex was locked
while the device was registered.

Unfortunately the serial core does exactly that.  In 
drivers/serial/serial_core.c the uart_add_one_port() routine holds 
state->mutex while calling tty_register_device(), and the same mutex is 
acquired by uart_suspend_port() and uart_resume_port().

Can anybody suggest a way around this?  Does the mutex really need to 
be locked at all these times?  Can it be released before calling 
tty_register_device()?  Or could two separate mutexes be used?

Thanks,

Alan Stern

