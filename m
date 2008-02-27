Return-Path: <linux-kernel-owner+w=401wt.eu-S1765647AbYB0Axq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765647AbYB0Axq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYB0Axh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:53:37 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:40810 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbYB0Axh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:53:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eBMb3GXyxZVfF038UcGYId0RayG7QHWu7KGcuZn+ATsvH+1WyOyH7qUFlZApDC8MHgbjqFDEakvvuOmHUDCnaHibbiVWCgUEnTOesCbqDIRBzcJWRa9JqkDDP24ca601MQv6EA/iVMqRSnnL2atPHSI/0SgKHcryYrCSKGAsAX8=
Message-ID: <f19298770802261653u62a966d3ud445292a2846d131@mail.gmail.com>
Date: Wed, 27 Feb 2008 03:53:36 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Cc: "John W. Linville" <linville@tuxdriver.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Alexey Zaytsev" <zaytsev.a@protei.ru>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200802270143.17484.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47BEAF3B.3080809@protei.ru> <200802270127.22159.mb@bu3sch.de>
	 <f19298770802261632y4406efc5p1c678c6ef6504c2f@mail.gmail.com>
	 <200802270143.17484.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 3:43 AM, Michael Buesch <mb@bu3sch.de> wrote:
>
> On Wednesday 27 February 2008 01:32:21 Alexey Zaytsev wrote:
>  > On Wed, Feb 27, 2008 at 3:27 AM, Michael Buesch <mb@bu3sch.de> wrote:
>  > >
>  > > On Wednesday 27 February 2008 01:23:17 Alexey Zaytsev wrote:
>  > >  > On Wed, Feb 27, 2008 at 1:47 AM, John W. Linville
>  > >  > <linville@tuxdriver.com> wrote:
>  > >  > > On Wed, Feb 27, 2008 at 01:12:32AM +0300, Alexey Zaytsev wrote:
>  > >  > >  > On Wed, Feb 27, 2008 at 1:04 AM, Michael Buesch <mb@bu3sch.de> wrote:
>  > >  > >
>  > >  > >
>  > >  > > > >  Besides that the bcm43xx driver is not broken. That's the whole reason
>  > >  > >  > >  this damn thread started at all. So it can't be broken.
>  > >  > >  > >
>  > >  > >  > Can't agree here. The bcm43xx driver used to work with 2.6.23 without requiring
>  > >  > >  > any module magic.
>  > >  > >
>  > >  > >  At the risk of prolonging things... :-(
>  > >  > >
>  > >  > >  Isn't the fundamental problem here that the ssb driver claims the same
>  > >  > >  PCI IDs as the bcm43xx driver?  He have hit this same issue a number
>  > >  > >  of times: 8139too vs.  8139cp, eepro vs. e100, sk98lin vs. skge,
>  > >  > >  and I'm sure there are more.  I admit that this situation is a bit
>  > >  > >  more confusing, since the user is less likely to predict a conflict
>  > >  > >  between bcm43xx and the ssb driver.  This is especially true since
>  > >  > >  the user isn't even selecting ssb directly, but is instead selecting
>  > >  > >  the apparently unrelated b44.
>  > >  > >
>  > >  > >  Still, the bcm43xx driver is not fundamentally damaged.  This is
>  > >  > >  fundamentally a "two drivers claiming the same PCI ID" issue, not a
>  > >  > >  "you broke my driver" one.
>  > >  >
>  > >  > Is there any reason the ssb driver should claim the bcm43xx pci ids in
>  > >  > the first place? I have very little understanding what the Sonic Silicon
>  > >  > Backplane really is, but I see that the b44 driver claims its PCI ids
>  > >  > directly. I also think I understand why the b43/b43legacy drivers can't
>  > >  > claim the ids directly: because the driver-device matching is done not
>  > >  > with the pci bus methods, but with the ssb bus methods, and it would
>  > >  > be impossible to automatically choose the right driver for the right
>  > >  > device (with same ssb ids), as the first of the two drivers loaded would
>  > >  > succeed in probe()'ing the pci "ssb bridge" device, and not letting the
>  > >  > other to take control, even after moments later the ssb probe for the
>  > >  > non-supported ssb device would fail. (Or am I completely wrong?)
>  > >  >
>  > >  > That said, I still think that the ssb driver claims the wrong pci ids,
>  > >  > which is especially wrong if the the b43/b43legacy drivers are not
>  > >  > even built. And my patch fixes exactly this problem - the ssb driver
>  > >  > no more claims the broadcom pci ids, when the b43/b43legacy drivers
>  > >  > are not built.
>  > >  >
>  > >  > One better solution I think might be to move the b43_pci_bridge.c
>  > >  > code to a separate module, and let the b43/b43legacy drivers
>  > >  > depend on it, but as I said, I have little knowledge in the
>  > >  > ssb stuff, so I did it the easy way.
>  > >
>  > >  See the comment in b43_pci_bridge.c
>  > >
>  > Yes, I've seen it. And this design, kind of, causes me some trouble.
>
>  There are several reasons to not do a seperate module.
>
>  First one being: People won't load it and complain about a regression.
>  Yeah, stupid stuff like that happens all the time. That's the reason we
>  SELECT the ssb code instead of using DEPENDS ON. People will otherwise not
>  enable it and report regressions.
>  And please don't say this won't happen. It _did_ happen when b44-PCI was
>  a seperate kconfig option. People reported regressions, although there were none.
>
I mean, not to make it a separate config option, of course it should
be hidden and
autoselected, but a separate module with maybe a symbol both b43/b43legacy
could depend on.

>  Second one being: It's overkill to have a seperate module for two lines of code
>  and a PCI ID table.
>
>  Third one being: We want the code to be as small as possible, as it must
>  all run on embedded machines. In general being as small as possible should
>  be the way to go.
>

If compiled statically, which I think is the right thing for embedded systems,
it should not take much additional space when separated from the ssb code.
