Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625Ab0ATVMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab0ATVMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 16:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359Ab0ATVMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 16:12:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33735 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995Ab0ATVMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 16:12:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was: Re: [linux-pm] Memory allocations in .suspend became very unreliable)
Date: Wed, 20 Jan 2010 22:12:49 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Bastien ROUCARIES <roucaries.bastien@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20100118110324.AE30.A69D9226@jp.fujitsu.com> <1263943071.724.540.camel@pasglop> <201001201231.17540.oliver@neukum.org>
In-Reply-To: <201001201231.17540.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001202212.49925.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 January 2010, Oliver Neukum wrote:
> Am Mittwoch, 20. Januar 2010 00:17:51 schrieb Benjamin Herrenschmidt:
> > On Tue, 2010-01-19 at 10:04 +0100, Bastien ROUCARIES wrote:
> > > Instead of masking bit could we only check if incompatible flags are
> > > used during suspend, and warm deeply. Call stack will be therefore
> > > identified, and we could have some metrics about such problem.
> > > 
> > > It will be a debug option like lockdep but pretty low cost.
> > 
> > I still believe it would just be a giant can of worms to require every
> > call site of memory allocators to "know" whether suspend has been
> > started or not.... Along the same reasons why we added that stuff for
> > boot time allocs.
> 
> But we have the freezer. So generally we don't require that knowledge.
> We can expect no normal IO to happen.
> The question is in the suspend paths. We never may use anything
> but GFP_NOIO (and GFP_ATOMIC) in the suspend() path. We can
> take care of that requirement in the allocator only if the whole system
> is suspended. As soon as a driver does runtime power management,
> it is on its own.

If you start new kernel threads using the async framework, for example,
GFP_KERNEL allocations are going to be used.

As I said before, IMnshO , duplicating every piece of code that allocates
memory and can be run during suspend/resume as well as in other circumstances
doesn't make sense.

Rafael
