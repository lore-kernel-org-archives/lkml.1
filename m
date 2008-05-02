Return-Path: <linux-kernel-owner+w=401wt.eu-S936766AbYEBVEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936766AbYEBVEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 17:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763028AbYEBVES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 17:04:18 -0400
Received: from smtp.dkm.cz ([62.24.64.34]:59544 "HELO slimak.dkm.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1762115AbYEBVER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 17:04:17 -0400
Date: Fri, 2 May 2008 22:57:35 +0200
From: Ondrej Zajicek <santiago@crfreenet.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ondrej Zajicek <santiago@crfreenet.org>, Jiri Slaby <jirislaby@gmail.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, rl@hellgate.ch
Subject: Re: [PATCH] via-rhine: suspend/resume bugfix
Message-ID: <20080502205734.GA5988@localhost.localdomain>
References: <20080427071351.GA20561@localhost.localdomain> <4814406B.8000907@gmail.com> <20080427095843.GA28784@localhost.localdomain> <20080503002655.GA3956@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503002655.GA3956@ucw.cz>
X-Operating-System: Debian GNU/Linux 4.0 (Etch)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 10:32:46PM +0200, Pavel Machek wrote:
> > Hmm, i will fix it. And i found that the patch might break
> > wakeup-on-LAN. So please discard it.
> 
> IRQ line should not be neccessary for WoL...?

IRQ line is not neccessary (i hope), but the patch puts this to
suspend path:

/* Switch to loopback mode to avoid hardware races. */
iowrite8(rp->tx_thresh | 0x02, ioaddr + TxConfig);

/* Disable interrupts by clearing the interrupt mask. */
iowrite16(0x0000, ioaddr + IntrEnable);

/* Stop the chip's Tx and Rx processes. */
iowrite16(CmdStop, ioaddr + ChipCmd);

(this was copied from shutdown path of the driver)

I suppose that the first one might break WoL. Unfortunately
on my hardware the WoL don't work even without the patch.

-- 
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."
