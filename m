Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbYFFL5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbYFFL5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 07:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbYFFL5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 07:57:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51994 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753453AbYFFL5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 07:57:32 -0400
Date: Fri, 6 Jun 2008 12:41:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hinko =?UTF-8?B?S2/EjWV2YXI=?= <hinko.kocevar@cetrtapot.si>
Cc: linux-kernel@vger.kernel.org, dev-etrax@axis.com
Subject: Re: [PATCH 2.6.26-rc5 1/2] cris: compile fixes for 2.6.26-rc5
Message-ID: <20080606124149.2d87f980@core>
In-Reply-To: <4849218D.7080306@cetrtapot.si>
References: <4849213A.4080001@cetrtapot.si>
	<4849218D.7080306@cetrtapot.si>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static struct tty_operations dummy_ops = {
> +	.open = &dummy_open,
> +	.close = &dummy_close,
> +	.write = &dummy_write,
> +	.write_room = &dummy_write_room,
> +};

Looks ok. From 2.6.26 onward you should be able to omit write/write_room
if you want writes to error, but you will need the dummies if you want
them to vanish.

> @@ -448,10 +455,7 @@ init_dummy_console(void)
>  		B115200 | CS8 | CREAD | HUPCL | CLOCAL; /* is normally B9600 default... */

It should also be setting c_ispeed/c_ospeed

>  	dummy_driver.flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;

Alan
