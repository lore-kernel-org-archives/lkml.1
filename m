Return-Path: <linux-kernel-owner+w=401wt.eu-S932598AbYB0A2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598AbYB0A2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764638AbYB0A2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:28:14 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:45029 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763981AbYB0A2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:28:13 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Date: Wed, 27 Feb 2008 01:27:21 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "John W. Linville" <linville@tuxdriver.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Alexey Zaytsev" <zaytsev.a@protei.ru>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org
References: <47BEAF3B.3080809@protei.ru> <20080226224757.GB3100@tuxdriver.com> <f19298770802261623j1a3429dcmcf855ec6781ffcbb@mail.gmail.com>
In-Reply-To: <f19298770802261623j1a3429dcmcf855ec6781ffcbb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802270127.22159.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 February 2008 01:23:17 Alexey Zaytsev wrote:
> On Wed, Feb 27, 2008 at 1:47 AM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > On Wed, Feb 27, 2008 at 01:12:32AM +0300, Alexey Zaytsev wrote:
> >  > On Wed, Feb 27, 2008 at 1:04 AM, Michael Buesch <mb@bu3sch.de> wrote:
> >
> >
> > > >  Besides that the bcm43xx driver is not broken. That's the whole reason
> >  > >  this damn thread started at all. So it can't be broken.
> >  > >
> >  > Can't agree here. The bcm43xx driver used to work with 2.6.23 without requiring
> >  > any module magic.
> >
> >  At the risk of prolonging things... :-(
> >
> >  Isn't the fundamental problem here that the ssb driver claims the same
> >  PCI IDs as the bcm43xx driver?  He have hit this same issue a number
> >  of times: 8139too vs.  8139cp, eepro vs. e100, sk98lin vs. skge,
> >  and I'm sure there are more.  I admit that this situation is a bit
> >  more confusing, since the user is less likely to predict a conflict
> >  between bcm43xx and the ssb driver.  This is especially true since
> >  the user isn't even selecting ssb directly, but is instead selecting
> >  the apparently unrelated b44.
> >
> >  Still, the bcm43xx driver is not fundamentally damaged.  This is
> >  fundamentally a "two drivers claiming the same PCI ID" issue, not a
> >  "you broke my driver" one.
> 
> Is there any reason the ssb driver should claim the bcm43xx pci ids in
> the first place? I have very little understanding what the Sonic Silicon
> Backplane really is, but I see that the b44 driver claims its PCI ids
> directly. I also think I understand why the b43/b43legacy drivers can't
> claim the ids directly: because the driver-device matching is done not
> with the pci bus methods, but with the ssb bus methods, and it would
> be impossible to automatically choose the right driver for the right
> device (with same ssb ids), as the first of the two drivers loaded would
> succeed in probe()'ing the pci "ssb bridge" device, and not letting the
> other to take control, even after moments later the ssb probe for the
> non-supported ssb device would fail. (Or am I completely wrong?)
> 
> That said, I still think that the ssb driver claims the wrong pci ids,
> which is especially wrong if the the b43/b43legacy drivers are not
> even built. And my patch fixes exactly this problem - the ssb driver
> no more claims the broadcom pci ids, when the b43/b43legacy drivers
> are not built.
> 
> One better solution I think might be to move the b43_pci_bridge.c
> code to a separate module, and let the b43/b43legacy drivers
> depend on it, but as I said, I have little knowledge in the
> ssb stuff, so I did it the easy way.

See the comment in b43_pci_bridge.c

-- 
Greetings Michael.
