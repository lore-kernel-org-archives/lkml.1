Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbYHMA75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbYHMA75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbYHMA7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:59:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59815
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752331AbYHMA7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:59:47 -0400
Date: Tue, 12 Aug 2008 17:59:48 -0700 (PDT)
Message-Id: <20080812.175948.214598056.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: stack overflow on Sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0808122051240.31704@hs20-bc2-1.build.redhat.com>
References: <20080811.233013.49328708.davem@davemloft.net>
	<20080812.012201.164876122.davem@davemloft.net>
	<Pine.LNX.4.64.0808122051240.31704@hs20-bc2-1.build.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Tue, 12 Aug 2008 20:53:04 -0400 (EDT)

> On Tue, 12 Aug 2008, David Miller wrote:
> 
> > From: David Miller <davem@davemloft.net>
> > Date: Mon, 11 Aug 2008 23:30:13 -0700 (PDT)
> > 
> > > The problem is that CONFIG_STACK_DEBUG doesn't understand
> > > the IRQ stacks at all.
> > > 
> > > I'll see if I can tweak it to handle this.
> > 
> > This patch, on top of my original IRQSTACKS patch for
> > sparc64, seems to get things working for me.
> 
> Thanks, the patch works.

Thanks for testing.  I'm engaged in a few activities right
now related to this:

1) I'm making a final version of this irqstacks patch which
   I'll get into Linus's tree and then submit to -stable.

2) I have a patch which I'm regression testing for gcc which
   gets rid of the 16-byte secondary-reload stack slot.  This
   gcc is emitting 176 byte default stack frames on sparc64.

3) I'm talking with some folks familiar with the V9 ABI about
   the mandatory incoming argument stack slots.  I think they
   can be eliminated in all cases except functions taking
   varargs.  If it cannot be done universally for some
   reason, I'll add a -mkernel option that will eliminate
   them.  This will emit 128 byte default stack frames when
   possible.

So in the end we should hopefully have 128 byte stack frames
coming out of gcc and IRQ stacks in the kernel.
