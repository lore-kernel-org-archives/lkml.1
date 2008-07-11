Return-Path: <linux-kernel-owner+w=401wt.eu-S1762581AbYGKN6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762581AbYGKN6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759951AbYGKNuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:50:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759554AbYGKNun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:50:43 -0400
Date: Fri, 11 Jul 2008 09:50:31 -0400
From: Alan Cox <alan@redhat.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "alan@redhat.com" <alan@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix ia64 simserial.c for Ldisc revamp
Message-ID: <20080711135031.GB23319@devserv.devel.redhat.com>
References: <57C9024A16AD2D4C97DC78E552063EA3064DE226@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3064DE226@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 01:46:49PM -0700, Luck, Tony wrote:
> This driver is "hidden" in arch/ia64 ... so it didn't get updated
> by the Ldisc revamp.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> 
> @@ -354,8 +354,8 @@ static void rs_flush_buffer(struct tty_struct *tty)
>         wake_up_interruptible(&tty->write_wait);
> 
>         if ((tty->flags & (1 << TTY_DO_WRITE_WAKEUP)) &&
> -           tty->ldisc.write_wakeup)
> -               (tty->ldisc.write_wakeup)(tty);
> +           tty->ldisc.ops->write_wakeup)
> +               (tty->ldisc.ops->write_wakeup)(tty);

We have a tty_wakeup method, drivers shouldn't be poking around in
tty flags any more

> -       if (tty->ldisc.flush_buffer) tty->ldisc.flush_buffer(tty);
> +       if (tty->ldisc.ops->flush_buffer) tty->ldisc.ops->flush_buffer(tty);

And we have a method for that too 8)
