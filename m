Return-Path: <linux-kernel-owner+w=401wt.eu-S1759841AbXETQSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841AbXETQSv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 12:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757796AbXETQSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 12:18:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:64051 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757632AbXETQSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 12:18:43 -0400
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
From: Kay Sievers <kay.sievers@vrfy.org>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Andrey Borzenkov <arvidjaar@mail.ru>,
       Uwe Bugla <uwe.bugla@gmx.de>, Ken Chen <kenchen@google.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <2c0942db0705200910t777214efud489f4bc94433bf5@mail.gmail.com>
References: <464F42F3.1080300@madrabbit.org>
	 <20070519191751.E51233A23A2@muan.mtu.ru>
	 <200705200124.13026.uwe.bugla@gmx.de>
	 <200705200845.43621.arvidjaar@mail.ru>
	 <2c0942db0705192316s2682807chd23df6f4de29edcb@mail.gmail.com>
	 <20070520062816.GA4095@ftp.linux.org.uk>
	 <2c0942db0705200822j685ec3b2x399a080622b6fc05@mail.gmail.com>
	 <3ae72650705200854x6a2c829fueff3652653fc21da@mail.gmail.com>
	 <2c0942db0705200910t777214efud489f4bc94433bf5@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 20 May 2007 18:16:39 +0200
Message-Id: <1179677799.3311.5.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+JXGiXTET53e0U4pqsiV7RfE7X4Ok1Dbq9dRQ
 xLeU52d5sNuR/Kwnnmzg7nrUj/FQZxWyIdX1GbRROdn6a4x39D
 jROcx0dcLlX44+ank3W+qm2Z7oYvlQu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-20 at 09:10 -0700, Ray Lee wrote:
> On 5/20/07, Kay Sievers <kay.sievers@vrfy.org> wrote:
> > On 5/20/07, Ray Lee <ray-lk@madrabbit.org> wrote:
> > > On 5/19/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> > > > On Sat, May 19, 2007 at 11:16:59PM -0700, Ray Lee wrote:
> > > > > Ken? Ball's in your court. As the patch isn't providing a killer
> > > > > feature for 2.6.22, I'd suggest just reverting it for now until the
> > > > > issues are ironed out.
> > > >
> > > > Hold it.  The real question here is which logics do we want there.
> > > > IOW, and how many device nodes do we want to appear and _when_ do
> > > > we want them to appear?
> > >
> > > The when part is what looks to make it racy. I'm guessing that we're
> > > relying on udev to create those loop nodes. If so, I think any scheme
> > > that creates more on demand would give transient mount errors while
> > > it's waiting on udev to create more nodes.
> > >
> > > Perhaps if we were to start with 8 loop nodes at init (as we have in
> > > 2.6.21), and then always maintain a margin of 8 (or 4, or...) when
> > > they start being used or detached?
> >
> > Until the tools can request dynamic loop device allocation from the
> > kernel before they want to use the device, you can create as many as
> > needed "static" loop* nodes in /lib/udev/devices/, which will be
> > copied to /dev/ early on every bootup.
> 
> Except that's different than current behavior presented to userspace.
> IOW, we broke userspace for anyone using udev. Which is, y'know, a lot
> of us.
> 
> We're at -rc2 right now. Given that, it looks like we have two
> options. First is to revert all this for now and try again when the
> patch has had more testing and agreement (as this isn't a major
> feature we're talking about here; it's effectively just a cleanup that
> happened to have unfortunate side-effects).
> 
> The second option is that we could have the loop device start with 8
> nodes populated, which would match current behavior.
> 
> A third option of requiring new userspace for 2.6.22 is a non-starter.

Right, providing "preallocated" devices, 8 or the number given in
max_loop, sounds like the best option until the tools can handle that.

Thanks,
Kay

