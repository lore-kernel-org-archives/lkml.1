Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbYJXTUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbYJXTUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 15:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbYJXTUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 15:20:36 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:39224 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbYJXTUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 15:20:34 -0400
Date: Fri, 24 Oct 2008 21:20:31 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>, linux-mm@kvack.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC][PATCH] lru_add_drain_all() don't use
	schedule_on_each_cpu()
Message-ID: <20081024192031.GA4155@osiris.boeblingen.de.ibm.com>
References: <2f11576a0810210851g6e0d86benef5d801871886dd7@mail.gmail.com> <2f11576a0810211018g5166c1byc182f1194cfdd45d@mail.gmail.com> <20081023235425.9C40.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023235425.9C40.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 12:00:17AM +0900, KOSAKI Motohiro wrote:
> Hi Heiko,
> > This bug is caused by folloing dependencys.
> > 
> > some VM place has
> >       mmap_sem -> kevent_wq
> > 
> > net/core/dev.c::dev_ioctl()  has
> >      rtnl_lock  ->  mmap_sem        (*) almost ioctl has
> > copy_from_user() and it cause page fault.
> > 
> > linkwatch_event has
> >     kevent_wq -> rtnl_lock
> > 
> > 
> > So, I think VM subsystem shouldn't use kevent_wq because many driver
> > use ioctl and work queue combination.
> > then drivers fixing isn't easy.
> > 
> > I'll make the patch soon.
> 
> My box can't reproduce this issue.
> Could you please test on following patch?

Your patch seems to fix the issue. At least I don't see the warning anymore ;)

Thanks,
Heiko
