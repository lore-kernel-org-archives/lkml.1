Return-Path: <linux-kernel-owner+w=401wt.eu-S932262AbYBZXN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbYBZXN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763515AbYBZXMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:12:55 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:38690 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbYBZXMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:12:53 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Date: Wed, 27 Feb 2008 00:12:03 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Alexey Zaytsev <zaytsev.a@protei.ru>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
References: <47BEAF3B.3080809@protei.ru> <f19298770802261412j7a3fec4bv1754db8123796d54@mail.gmail.com> <20080226224757.GB3100@tuxdriver.com>
In-Reply-To: <20080226224757.GB3100@tuxdriver.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802270012.04335.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2008 23:47:57 John W. Linville wrote:
> On Wed, Feb 27, 2008 at 01:12:32AM +0300, Alexey Zaytsev wrote:
> > On Wed, Feb 27, 2008 at 1:04 AM, Michael Buesch <mb@bu3sch.de> wrote:
> 
> > >  Besides that the bcm43xx driver is not broken. That's the whole reason
> > >  this damn thread started at all. So it can't be broken.
> > >
> > Can't agree here. The bcm43xx driver used to work with 2.6.23 without requiring
> > any module magic.
> 
> At the risk of prolonging things... :-(
> 
> Isn't the fundamental problem here that the ssb driver claims the same
> PCI IDs as the bcm43xx driver?  He have hit this same issue a number
> of times: 8139too vs.  8139cp, eepro vs. e100, sk98lin vs. skge,
> and I'm sure there are more.  I admit that this situation is a bit
> more confusing, since the user is less likely to predict a conflict
> between bcm43xx and the ssb driver.  This is especially true since
> the user isn't even selecting ssb directly, but is instead selecting
> the apparently unrelated b44.
> 
> Still, the bcm43xx driver is not fundamentally damaged.  This is
> fundamentally a "two drivers claiming the same PCI ID" issue, not a
> "you broke my driver" one.

You got the point exactly right John. :)
The special "problem" about this is that the b44 driver, which _seems_
to have nothing to do with b43, registers the b43 PCI IDs.
(This is just for convenience. See the comment in the header of
b43_pci_bridge.c for details).
So if you use the b44 driver, but also want to use the bcm43xx driver,
you have to load the bcm43xx driver first to make it probe before
b44 registers the b43 PCI IDs.

The bcm43xx driver is not broken _at_ _all_. In fact, its code did not
even slightly change since ages.

I do see the issue, but I don't feel like changing the complicated SSB
KConfig stuff (it has lots of weird dependencies) to fix this bug
that is actually trivial to work around. Besides that, how many people
do we have, which do have a b44 card plus a bcm4311 rev 1 (there are _LOTS_
of revisions of the 43xx hardware)?

So I'd rather fix b43 to work on the card. See the patch I just sent.

-- 
Greetings Michael.
