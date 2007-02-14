Return-Path: <linux-kernel-owner+w=401wt.eu-S932251AbXBNCae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbXBNCae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 21:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932260AbXBNCae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 21:30:34 -0500
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:32132 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932251AbXBNCad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 21:30:33 -0500
Date: Wed, 14 Feb 2007 11:30:25 +0900 (JST)
Message-Id: <20070214.113025.126141881.nemoto@toshiba-tops.co.jp>
To: mingo@elte.hu
Cc: romieu@fr.zoreil.com, jeff@garzik.org, torvalds@osdl.org, akpm@osdl.org,
       davem@davemloft.net, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [patch] net, 8139too.c: fix netpoll deadlock
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20061213011231.GA6361@elte.hu>
References: <457EAE62.8090404@garzik.org>
	<20061212214939.GA470@electric-eye.fr.zoreil.com>
	<20061213011231.GA6361@elte.hu>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Let me resume two months old topic...

On Wed, 13 Dec 2006 02:12:31 +0100, Ingo Molnar <mingo@elte.hu> wrote:
> > I have lived with the "NAPI ->poll() handler runs in BH irq enabled 
> > context" rule for years. Is it definitely false/dead ?
> > 
> > If so at least 8139cp needs the same fix.
> 
> hm, this isnt really about NAPI polling, but about the 
> netconsole/netpoll/netdump poll_controller() handler.
> 
> with netconsole, printk can be called from IRQ context (and is 
> frequently from IRQ context during bootup or module initialization), so 
> a BH rule isnt enough for them.

I see NAPI poll routine might be called with interrupt disabled.

Many (all?) NAPI drivers call netif_receive_skb() from its poll
routine (as described in NAPI-HOWTO.txt), but I thought
netif_receive_skb() cannot be called from irq context or irq disabled.
So it seems the problem is not solved completely.  Or am I missing
something?

---
Atsushi Nemoto
