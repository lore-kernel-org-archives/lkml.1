Return-Path: <linux-kernel-owner+w=401wt.eu-S1761934AbXFFO6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761934AbXFFO6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 10:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbXFFO6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 10:58:12 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42145 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751098AbXFFO6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 10:58:11 -0400
Date: Wed, 6 Jun 2007 16:03:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: [SERIAL] Don't optimise away baud rate changes when BOTHER is
 used
Message-ID: <20070606160310.27d6d3b8@the-village.bc.nu>
In-Reply-To: <1181133010.4096.26.camel@pmac.infradead.org>
References: <20070523172739.1d3a918c@the-village.bc.nu>
	<1180012135.8303.89.camel@shinybook.infradead.org>
	<20070524144109.7bd0f4d0@the-village.bc.nu>
	<1180014338.8303.95.camel@shinybook.infradead.org>
	<20070524160559.54c2c639@the-village.bc.nu>
	<1181133010.4096.26.camel@pmac.infradead.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007 13:30:10 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> The uart_set_termios() function will bail out early without bothering to
> touch the hardware, if it decides that nothing "relevant" has changed.
> Unfortunately, its idea of "relevant" doesn't include c_[io]speed. So if
> the baud rate bits are BOTHER and you just change the speed, the change
> gets optimised away.
> 
> This patch makes it ignore the old Bfoo bits in c_cflag and just check
> whether c_ispeed and c_ospeed have changed. Those integers are always
> set appropriately for us by set_termios().

Yep - and there are some other changes needed as well once everyone gets
their ports properly lined up (notably handing back the actual speed).

Acked-by: Alan Cox <alan@redhat.com>
