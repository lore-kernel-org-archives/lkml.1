Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbZI2P4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbZI2P4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 11:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbZI2P4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 11:56:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbZI2P43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 11:56:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.01.0909280743310.3349@localhost.localdomain>
References: <alpine.LFD.2.01.0909280743310.3349@localhost.localdomain> <20090928135332.4300.56046.stgit@warthog.procyon.org.uk> <20090928151628.62955233@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove pty_ops_bsd and pty_bsd_ioctl() as they're not used
Date: Tue, 29 Sep 2009 16:55:45 +0100
Message-ID: <395.1254239745@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

>  
>  	pty_slave_driver->owner = THIS_MODULE;
>  	pty_slave_driver->driver_name = "pty_slave";
> @@ -399,7 +387,7 @@ static void __init legacy_pty_init(void)
>  	pty_slave_driver->flags = TTY_DRIVER_RESET_TERMIOS |
>  					TTY_DRIVER_REAL_RAW;
>  	pty_slave_driver->other = pty_driver;
> -	tty_set_operations(pty_slave_driver, &pty_ops);
> +	tty_set_operations(pty_slave_driver, &pty_ops_bsd);
>  
>  	if (tty_register_driver(pty_driver))
>  		panic("Couldn't register pty driver");
> 

Is it right to use pty_ops_bsd in _both_ places?  Looking at the code in
linux-2.6.0, the BSD ioctl only applies to the master and doesn't apply to the
slave.

David
