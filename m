Return-Path: <linux-kernel-owner+w=401wt.eu-S1752695AbYLONZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbYLONZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 08:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYLONZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 08:25:08 -0500
Received: from smtp2.kfki.hu ([148.6.0.28]:51521 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbYLONZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 08:25:06 -0500
Date: Mon, 15 Dec 2008 14:25:04 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Patrick McHardy <kaber@trash.net>
cc: Jan Engelhardt <jengelh@medozas.de>, David Miller <davem@davemloft.net>,
       ajax@redhat.com, linux-kernel@vger.kernel.org, davej@redhat.com,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] net: Remove a noisy printk
In-Reply-To: <49464C2C.6030009@trash.net>
Message-ID: <alpine.DEB.2.00.0812151419380.4114@blackhole.kfki.hu>
References: <1229033625-30825-1-git-send-email-ajax@redhat.com> <20081211.203243.124017657.davem@davemloft.net> <alpine.LNX.1.10.0812132310080.27276@fbirervta.pbzchgretzou.qr> <alpine.DEB.2.00.0812141745550.2447@blackhole.kfki.hu>
 <alpine.LNX.1.10.0812141905490.10355@fbirervta.pbzchgretzou.qr> <alpine.DEB.2.00.0812142056520.2621@blackhole.kfki.hu> <49464C2C.6030009@trash.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2008, Patrick McHardy wrote:

> Jozsef Kadlecsik wrote:
> > On Sun, 14 Dec 2008, Jan Engelhardt wrote:
> > 
> > > > In a >normal< system one usually does not use raw sockets. So if a root
> > > > process do use raw socket, at least netfilter sends a notification and
> > > > there's a chance that someone take notice it by checking the kernel
> > > > logs.
> > > > [...]
> > > > But should we remove them due to nuisances on >test< systems?
> > > > 
> > > > Rather make it a kernel compile option but do not remove.
> > > This warning is in the conntrack calling code. Iff you play with
> > > raw sockets and do something wrong, the generic network code
> > > should barf IMHO, not nf_conntrack, and not [nf_conntrack_ipv4 only].
> > 
> > It is not about doing something wrong at using raw sockets - it's about
> > using raw sockets.
> > 
> > I'm not quite convinced the generic network code should warn about raw
> > sockets. I believe it belongs to the security-related subsystems - netfilter
> > and (or) the security frameworks. [But as netfilter is much more widely
> > used, the 'or' is just theoretical.)
> 
> I agree that it doesn't belong to the generic networking code.
> But the way its handled in netfilter is far from perfect as well.
> Currently multiple modules will spam the ringbuffer repeatedly,
> but offer no possibility to change anything in the behaviour of
> how these packets are treated. Unfortunately we can't handle this
> in the ruleset (which is exactly the reason why we're spamming
> the ringbuffer), so how about we add a module option controlling
> how to treat those packets and remove the printk?

How about this: let the printk be removed from conntrack and the mangle 
table but put (back) into the filter table with a module option, which 
controls the behaviour (drop/accept & log/nolog)?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
