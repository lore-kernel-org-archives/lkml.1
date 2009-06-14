Return-Path: <linux-kernel-owner+w=401wt.eu-S1762429AbZFNRUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762429AbZFNRUc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 13:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbZFNRUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 13:20:21 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:56219 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbZFNRUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 13:20:20 -0400
Date: Sun, 14 Jun 2009 19:20:22 +0200
From: Andreas Mohr <andim2@users.sourceforge.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: andi@lisas.de, akpm@linux-foundation.org,
       e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make e100 suspend handler support PCI cards lacking PM
	capability
Message-ID: <20090614172022.GA22586@rhlx01.hs-esslingen.de>
Reply-To: andi@lisas.de
References: <20081229102515.GA17171@rhlx01.hs-esslingen.de> <200906141606.29754.rjw@sisk.pl> <20090614164604.GA19746@rhlx01.hs-esslingen.de> <200906141909.46354.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906141909.46354.rjw@sisk.pl>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jun 14, 2009 at 07:09:45PM +0200, Rafael J. Wysocki wrote:
> On Sunday 14 June 2009, Andreas Mohr wrote:
> > Couple questions still:
> > - why do we call pci_wake_from_d3(...false) only!?
> >   Wouldn't this break WoL after one iteration back and forth,
> >   due to missing 'true' case?
> 
> The 'true' case is the 'wake = true' one.

OK, so it wasn't an explicit pci_wake_from_d3(...true), but the
operations done there are the equivalent of it probably.

> > - why do we call netif_device_detach() _after_ doing hardware shutdown
> >   of the network controller? I'd guess this can cause huge issues?
> >   Someone told me he had rtnl lock issues upon S2D with e100
> >   (very similar to my rtnl issues during aborted .suspend),
> >   and that might possibly be the reason?
> 
> I think you're right, but I'm not a network driver expert.
> 
> Perhaps you can change the ordering and see if that fixes the rtnl issue
> (since you're able to reproduce it without my patch, that should be easy to
> verify).

I'll test this - later.

Thanks a lot,

Andreas Mohr
