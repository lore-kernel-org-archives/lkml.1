Return-Path: <linux-kernel-owner+w=401wt.eu-S934841AbYEBNF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934841AbYEBNF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 09:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759813AbYEBNFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 09:05:19 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54220 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755794AbYEBNFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 09:05:17 -0400
Date: Fri, 2 May 2008 13:56:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 5/7] PPS: serial clients support.
Message-ID: <20080502135618.7172af4a@core>
In-Reply-To: <20080502104537.GW3002@enneenne.com>
References: <1207851751-25703-6-git-send-email-giometti@linux.it>
	<20080410210918.3be98868@core>
	<20080411075515.GH26777@enneenne.com>
	<20080411092840.3cc4de67@core>
	<20080411134724.GF2160@csclub.uwaterloo.ca>
	<20080411154652.4852b6d4@core>
	<20080430114107.GE3002@enneenne.com>
	<20080430172855.6d2e81a6@core>
	<20080502073335.GK3002@enneenne.com>
	<20080502111837.588c15ae@core>
	<20080502104537.GW3002@enneenne.com>
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

> So I should rewrite the uart_handle_dcd_change() as follow?
> 
> static inline void
> uart_handle_dcd_change(struct uart_port *port, unsigned int status)
> {
>         struct uart_info *info = port->info;
> 	struct tty_struct *tty = info->tty;
>         struct tty_ldisc *ld;
> 
>         ld = tty_ldisc_ref(tty);
>         if (ld != NULL) {
>                 if (ld->dcd_change)
>                         (ld->dcd_change)(tty, port, status);
>                 tty_ldisc_deref(ld);
>         }
> 
>         port->icount.dcd++;
> 
> #ifdef CONFIG_HARD_PPS
>         if ((port->flags & UPF_HARDPPS_CD) && status)
>                 hardpps();
> #endif

The ifdef bit can go - it will be in your dcd_change callback ..

Alan
