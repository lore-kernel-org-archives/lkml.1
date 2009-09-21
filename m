Return-Path: <linux-kernel-owner+w=401wt.eu-S1756474AbZIUOnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbZIUOnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 10:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756320AbZIUOnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 10:43:07 -0400
Received: from mail09.linbit.com ([212.69.161.110]:54415 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308AbZIUOnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 10:43:06 -0400
Date: Mon, 21 Sep 2009 16:43:08 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: lmb@suse.de, jens.axboe@oracle.com, neilb@suse.de, hch@infradead.org,
       James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
       drbd-dev@lists.linbit.com, akpm@linux-foundation.org,
       bart.vanassche@gmail.com, davej@redhat.com, gregkh@suse.de,
       kosaki.motohiro@jp.fujitsu.com, kyle@moffetthome.net,
       torvalds@linux-foundation.org, nab@linux-iscsi.org, knikanth@suse.de,
       philipp.reisner@linbit.com, sam@ravnborg.org, Mauelshagen@redhat.com
Subject: Re: [GIT PULL] DRBD for 2.6.32
Message-ID: <20090921144308.GG8072@barkeeper1-xen.linbit>
Mail-Followup-To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	lmb@suse.de, jens.axboe@oracle.com, neilb@suse.de,
	hch@infradead.org, James.Bottomley@suse.de,
	linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com,
	akpm@linux-foundation.org, bart.vanassche@gmail.com,
	davej@redhat.com, gregkh@suse.de, kosaki.motohiro@jp.fujitsu.com,
	kyle@moffetthome.net, torvalds@linux-foundation.org,
	nab@linux-iscsi.org, knikanth@suse.de, philipp.reisner@linbit.com,
	sam@ravnborg.org, Mauelshagen@RedHat.com
References: <20090918200803.GM23126@kernel.dk> <20090919141334N.fujita.tomonori@lab.ntt.co.jp> <20090919220232.GB31849@suse.de> <20090921223815U.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090921223815U.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 10:39:42PM +0900, FUJITA Tomonori wrote:
> > Either
> > 
> > a) there's going to be a transition period during which the "old"
> > interface is supported but depreciated and scheduled to be removed (all
> > driving the new unified same back-end),
> 
> We should avoid removing the existing interface. Once we merge drbd, I
> don't think that it's a good idea to remove the drbd user interface.


the drbd user interface is presented via
low level drbdsetup
and high level drbdadm (parses configuration files,
and calls out to drbdsetup).

changing (simplifying) the in-kernel configuration can be done any time,
as long as we can write a compat layer in the user land tools,
i.e. write drbdsetup so it will accept the same command line,
and try, based on "something" (sysfs file, genetlink group, 
environment variable, whatever) the "new" kernel interface,
or the "old" one.

I don't see any issue here.

> I don't think so. It's much easier to implement something that
> supports fewer user interfaces.

We can choose whatever user-kernel interface you like,
and change it with every dot release --
we'd just need to add additional compat code into
the drbdsetup userland binary.

> > > BTW, DM already has something like drbd? I thought that there is a
> > > talk about that new target at LinuxCon.
> > 
> > dm-replicator is nowhere near as usable as DRBD, and not upstream yet
> 
> I don't think usability at this point is important. The design
> matters. dm-replicator is built on the existing framework.
> 
> And my question is, if drbd and dm-replicator will provide similar
> features, then why do we need both in mainline?

dm-replicator is not there yet, and as such has zero user base.

To actually use it in the HA clustering world, quite a lot
userland glue would have to be written, which is not there yet either.

In contrast, DRBD is used in production, in many thousands of
installations worldwide since many years.

By design, dm-replicator is more comparable to dm-raid1, with the
knowledge that several mirror legs may break independently
(resulting in one "dirty log" per mirror leg), and come back
independendly, as well as the option of adding an on-disk ring-buffer to
any mirror leg.

It is by design NOT able to do dual-active mode.

If any of you happens to be at LinuxCon,
please discuss with Heinz (Maulshagen, dm-replicator)
and Phil (Reisner, DRBD), who both are present.

Heinz' talk about replicator is scheduled today, 10:30 am, 
that would be a good opportunity, I guess.

> > either. (Further, it's another independent implementation, pursued
> > instead of unifying any of the existing ones or helping to merge drbd -
> > don't get me started on my thoughts of that.)
> 
> Again, dm-replicator is built on the existing framework instead of
> adding another 'multiple (virtual) devices' framework into mainline.

Well, not exactly.

It adds quite a bit of additional framework (to the device mapper
subsystem), before it then starts to use that additional framework
via the generic device mapper hooks.

On that same line DRBD could argue that it uses the existing generic
block layer framework, just adding a bit functionality ;)

-- 
: Lars Ellenberg
: LINBIT | Your Way to High Availability
: DRBD/HA support and consulting http://www.linbit.com

DRBD® and LINBIT® are registered trademarks of LINBIT, Austria.
