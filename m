Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbYH0ULi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbYH0ULi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 16:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbYH0UL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 16:11:29 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:52367 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751118AbYH0UL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 16:11:29 -0400
Date: Wed, 27 Aug 2008 22:11:11 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Pascal Terjan <pterjan@mandriva.com>
Cc: Marcus Sundberg <marcus@ingate.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: r8169 regression in 2.6.26.3 vs 2.6.26.2
Message-ID: <20080827201111.GA29569@electric-eye.fr.zoreil.com>
References: <1219828800.30098.7.camel@plop> <48B52E8C.40605@ingate.com> <1219833655.30098.9.camel@plop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219833655.30098.9.camel@plop>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pascal Terjan <pterjan@mandriva.com> :
> Le mercredi 27 ao?t 2008 ? 12:38 +0200, Marcus Sundberg a ?crit :
> > Pascal Terjan wrote:
> > > Since updating to 2.6.26.3, networking no longer works on Acer Aspire
> > > One.
> > > 
> > > PCI config is now always filled with ones.
> > > 
> > > Reverting "r8169: avoid thrashing PCI conf space above
> > > RTL_GIGA_MAC_VER_06" makes it work again.
> > > 
> > > The device is 10ec:8136
[...]
> > How does the kernel identify your chipset upon driver load?
> > (grep for XID)
> 
> eth0: RTL8169 at 0xe04ee000, 00:1e:68:a0:07:b5, XID 24a00000 IRQ 17

As far as I can read rtl8169_get_mac_version, this XID should not match
any known device with 2.6.26.3 and thus fallback to RTL_GIGA_MAC_VER_01
(assuming that rtl8169_init_phy runs after rtl8169_get_mac_version, what
it appears to do so far).

Yes / no / -ECOFFEE ?

On a different topic, I would suggest to try patches #0001 ... #0006
at http://userweb.kernel.org/~romieu/r8169/2.6.27-rc3/20080818/ with
your chipset.

-- 
Ueimor
