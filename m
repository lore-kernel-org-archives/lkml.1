Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbYDXVSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbYDXVSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 17:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbYDXVSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 17:18:15 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53480 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753816AbYDXVSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 17:18:14 -0400
Date: Thu, 24 Apr 2008 21:50:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: graf.yang@analog.com
Subject: Re: Blackfin Serial Driver: Enable IR function when user
 application (irattach /dev/ttyBFx -s) call TIOCSETD ioctl with line
 discipline N_IRDA
Message-ID: <20080424215004.34517136@the-village.bc.nu>
In-Reply-To: <200804241929.m3OJToSE021045@hera.kernel.org>
References: <200804241929.m3OJToSE021045@hera.kernel.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O>     Blackfin Serial Driver: Enable IR function when user application (irattach /dev/ttyBFx -s) call TIOCSETD ioctl with line discipline N_IRDA

>  	if (ret == 0) {
> +		bfin_serial_reg.tty_driver->set_ldisc = bfin_set_ldisc;
>  		ret = platform_driver_register(&bfin_serial_driver);

This will not work when combined with the tty patches as they move the
tty driver operations out of the tty driver and also make them shared and
const. You need to declare two sets of tty_ops and register the correct
one for your device.

Alan
