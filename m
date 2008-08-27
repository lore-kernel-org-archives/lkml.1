Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYH0UpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYH0UpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 16:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYH0Uoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 16:44:55 -0400
Received: from ryu.zarb.org ([212.85.153.228]:44651 "EHLO ryu.zarb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbYH0Uoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 16:44:54 -0400
Subject: Re: r8169 regression in 2.6.26.3 vs 2.6.26.2
From: Pascal Terjan <pterjan@mandriva.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Marcus Sundberg <marcus@ingate.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
In-Reply-To: <20080827201111.GA29569@electric-eye.fr.zoreil.com>
References: <1219828800.30098.7.camel@plop> <48B52E8C.40605@ingate.com>
	 <1219833655.30098.9.camel@plop>
	 <20080827201111.GA29569@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Mandriva
Date: Wed, 27 Aug 2008 22:44:48 +0200
Message-Id: <1219869889.30098.43.camel@plop>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.90-1mdv2009.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 août 2008 à 22:11 +0200, Francois Romieu a écrit :
> Pascal Terjan <pterjan@mandriva.com> :
> > Le mercredi 27 ao?t 2008 ? 12:38 +0200, Marcus Sundberg a ?crit :
> > > Pascal Terjan wrote:
> > > > Since updating to 2.6.26.3, networking no longer works on Acer Aspire
> > > > One.
> > > > 
> > > > PCI config is now always filled with ones.
> > > > 
> > > > Reverting "r8169: avoid thrashing PCI conf space above
> > > > RTL_GIGA_MAC_VER_06" makes it work again.
> > > > 
> > > > The device is 10ec:8136
> [...]
> > > How does the kernel identify your chipset upon driver load?
> > > (grep for XID)
> > 
> > eth0: RTL8169 at 0xe04ee000, 00:1e:68:a0:07:b5, XID 24a00000 IRQ 17
> 
> As far as I can read rtl8169_get_mac_version, this XID should not match
> any known device with 2.6.26.3 and thus fallback to RTL_GIGA_MAC_VER_01
> (assuming that rtl8169_init_phy runs after rtl8169_get_mac_version, what
> it appears to do so far).
> 
> Yes / no / -ECOFFEE ?
> 

Yes I took some time to look at it and now does not understand what's
wrong.

Indeed I get "unknown MAC (27a00600)" so I get RTL_GIGA_MAC_VER_01 which
is <= RTL_GIGA_MAC_VER_06, so it should work fine with or without this
patch. And indeed it seems to work when I rebuild the module, even when
I do not revert the patch.

And by the way, unrelated to this problem, it is written twice for
RTL_GIGA_MAC_VER_02:

=====
        if (tp->mac_version <= RTL_GIGA_MAC_VER_06) {
                dprintk("Set MAC Reg C+CR Offset 0x82h = 0x01h\n");
                RTL_W8(0x82, 0x01);
        }
[...]
        if (tp->mac_version == RTL_GIGA_MAC_VER_02) {
                dprintk("Set MAC Reg C+CR Offset 0x82h = 0x01h\n");
                RTL_W8(0x82, 0x01);
=====

To come back to the problem, this patch may not be faulty but I fail to
understand the issue...

- 2.6.26.2 always works
- 2.6.26.3 from my distro always fails
- 2.6.26.3 from my distro with r8169 rebuilt out of the kernel tree but
from the same source and with the same config, gcc, etc, works...

So either it is random I am very unlucky that it always works with one
and always fails with the other or there is some difference that I could
not think about

> On a different topic, I would suggest to try patches #0001 ... #0006
> at http://userweb.kernel.org/~romieu/r8169/2.6.27-rc3/20080818/ with
> your chipset.

OK I will


