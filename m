Return-Path: <linux-kernel-owner+w=401wt.eu-S1762786AbYBVKUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762786AbYBVKUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 05:20:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbYBVKTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 05:19:51 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48848 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751008AbYBVKTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 05:19:50 -0500
Date: Fri, 22 Feb 2008 10:10:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ray Lee" <ray-lk@madrabbit.org>
Cc: "Greg KH" <gregkh@suse.de>, "Adrian Bunk" <bunk@kernel.org>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: usb/serial/io_ti.c: inconsequent NULL checking
Message-ID: <20080222101016.37128803@core>
In-Reply-To: <2c0942db0802191538k79f93ca5p93a1883a449f3bb0@mail.gmail.com>
References: <20080219224915.GN31955@cs181133002.pp.htv.fi>
	<20080219232556.GB1963@suse.de>
	<2c0942db0802191538k79f93ca5p93a1883a449f3bb0@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Either the test of port->tty here is unneeded:
> 
>  if (port->tty)
>                port->tty->low_latency = low_latency;
> 
> ...or the lack of test of port->tty here is a mistake:
> 
> 	 edge_set_termios (port, port->tty->termios);

Interesting - so coverity doesn't understand the BKL. It's producing the
right answer, for the right reason but the assumption it makes isn't 100%
safe.

The check can go.

Alan

