Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbZINTQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbZINTQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 15:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbZINTQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 15:16:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54715 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbZINTQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 15:16:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Subject: Re: Regression in suspend to ram in 2.6.31-rc kernels
Date: Mon, 14 Sep 2009 21:17:03 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Chris Ball <cjb@laptop.org>, Pavel Machek <pavel@ucw.cz>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Christoph Hellwig <hch@lst.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org, viro@zeniv.linux.org.uk
References: <20090903232317.GA6760@lst.de> <200909120036.41725.rjw@sisk.pl> <c4e36d110909140139u786f2165oc5a35dce5b2c0527@mail.gmail.com>
In-Reply-To: <c4e36d110909140139u786f2165oc5a35dce5b2c0527@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909142117.03726.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 September 2009, Zdenek Kabelac wrote:
> 2009/9/12 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Saturday 12 September 2009, Chris Ball wrote:
> >> Hi,
> >>
> >>    > Well system could check basic card ids if they match after resume
> >>
> >> No.  That (arguably) guarantees that it's the same card, but not that
> >> it wasn't modified in another machine during the suspend.
> >
> > Generally speaking, we'd also need to check superblocks for this to work.
> >
> >>    > if some users wants to crash his card by randomly swapping it
> >>    > during suspend/resume - I'd have no problem with that....
> >>
> >> You should have a problem with it.  Taking a card from a suspended
> >> machine and working on it with a different machine is not a bizarre
> >> thing to want to do.
> >
> > Agreed.
> 
> 
> Well - ok - so let me ask this question - if I'll replace local hard
> drive during suspend - what will happen - is this prohibited by hw
> (e.i. to switch SATA cables) ?

That I'm unsure of, but if you replace some other major components, such
as the CPU or memory, the hardware will detect that and the resume will fail.

> IMHO filesystem should be able to detect corruption of its data
> structures - (assuming fs is notified about suspend/resume operation)

Well, the problem is that at the moment such a notification mechanism doesn't
exist.

> Also there could be one simple quick solution/hack

No hacks, please.

> - to require to have at least all remote drives unmounted - so suspend would

Define "remote".  It isn't that simple, even your root fs can be on USB, iSCSI,
whatever.

> be refused if it runs mounted card/usb drive -  this would be 100% better
> than current solution which effectively kills my laptop if I forget to
> unmount card in mmc reader - especially if dmesg contains message with
> the reason why my suspend fails.

You can make the suspend scripts check for that, there's no reason for the
kernel to do it IMO.

Thanks,
Rafael
