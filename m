Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab0BVT0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 14:26:10 -0500
Received: from senator.holtmann.net ([87.106.208.187]:41258 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab0BVT0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 14:26:07 -0500
Subject: Re: Firmware versioning best practices II
From: Marcel Holtmann <marcel@holtmann.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Vipin Mehta <Vipin.Mehta@atheros.com>
In-Reply-To: <43e72e891002221114w24304ab0x5aea7dfc81b4d9d6@mail.gmail.com>
References: <43e72e891002191823h3245bc0cn7a8745ae77409aa8@mail.gmail.com>
	 <1266662106.1820.4034.camel@macbook.infradead.org>
	 <1266663639.10357.1.camel@jlt3.sipsolutions.net>
	 <1266664166.1820.4165.camel@macbook.infradead.org>
	 <1266664247.11514.0.camel@jlt3.sipsolutions.net>
	 <1266665535.1820.4238.camel@macbook.infradead.org>
	 <1266747222.18491.5.camel@violet>
	 <43e72e891002221114w24304ab0x5aea7dfc81b4d9d6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Feb 2010 20:27:34 +0100
Message-ID: <1266866854.18491.42.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

> >> > > > That doesn't make much sense anyway. If the firmware filename is
> >> > > > foo-$APIVER-$CODEVER every code change would need a corresponding
> >> > > driver
> >> > > > change. If it is just foo-$APIVER then the $CODEVER can be embedded
> >> > > in
> >> > > > the firmware file and printed so you know which code you're using,
> >> > > but
> >> > > > if it doesn't influence the API I don't see why it should be part of
> >> > > the
> >> > > > filename?
> >> > >
> >> > > The idea is that just like with shared libraries, you have a symlink
> >> > > from the 'soname' foo-3.fw to the actual file foo-3-1.4.1.fw.
> >> >
> >> > Ah ok. I indeed do that manually with iwlwifi firmware :)
> >> >
> >> > > For shared libraries, it's easy to create those symlinks automatically
> >> > > using ldconfig. For firmware that doesn't really work though -- since
> >> > > the soname isn't encoded in the file like it is in ELF libraries.
> >> >
> >> > Right. Though I guess we could come up with a unified firmware wrapper
> >> > format that the firmware loader can unwrap.
> >>
> >> I suppose we could, but this seems like overkill to me.
> >
> > I have to agree. This looks like total overkill to me.
> >
> > Just use the $APIVER in the firmware filename.
> 
> OK -- so what goes into linux-firmware is just the latest
> 
> foo-$(API)
> 
> > And if someone wants to
> > keep track of more details then they can manually symlink them.
> 
> Well do we want the older foo-$(API)-$(VAR) files in linux-firmware
> too for those companies/developers wishing to do this?

personally I would say no, but for some projects it might make sense. I
would just leave this up to the project/driver itself.

> What about deprecating APIs of the firmware based on kernel releases.
> I see it reasonable to deprecate a firmware API completely for a
> future kernel release provided you maintain all features and
> functionality in par. Does that sound reasonable?

Realistically you have to deprecate firmware versions at some point
anyway. So yes, that makes sense. However I would leave this again up to
the driver itself and how far the maintainers wanna go in supported
older API versions.

> > Unless we have full control over the source code of every firmware used
> > in the kernel, why bother. It is up to the companies providing them
> > anyway to make sure everything works as expected and the community can't
> > fix it.
> 
> Well that's exactly it -- we do have access to the code for ar9170 for
> example, so these details will become more relevant in the future.

That is one of the few exception. However even for ar9170 there has to
be release engineering team that creates the binary and uploads it into
linux-firmware.git since I don't see the majority of people compiling it
from source. And at that point the release engineering needs to test the
API compatibility.

Regards

Marcel


