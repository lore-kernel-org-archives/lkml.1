Return-Path: <linux-kernel-owner+w=401wt.eu-S933536AbZFQMF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536AbZFQMF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933378AbZFQMFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:05:08 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:6291 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470AbZFQMFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:05:06 -0400
Subject: Re: [RFC PATCH 0/4]: affinity-on-next-touch
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Stefan Lankes <lankes@lfbs.rwth-aachen.de>,
       "'Andi Kleen'" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-numa@vger.kernel.org, Boris Bierbaum <boris@lfbs.rwth-aachen.de>,
       "'Brice Goglin'" <Brice.Goglin@inria.fr>
In-Reply-To: <20090617102245.2aec2e6e.kamezawa.hiroyu@jp.fujitsu.com>
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>
	 <87zldjn597.fsf@basil.nowhere.org>
	 <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de>
	 <20090612103251.GJ25568@one.firstfloor.org>
	 <004001c9eb53$71991300$54cb3900$@rwth-aachen.de>
	 <1245119977.6724.40.camel@lts-notebook>
	 <003001c9ee8a$97e5b100$c7b11300$@rwth-aachen.de>
	 <1245164395.15138.40.camel@lts-notebook>
	 <20090617102245.2aec2e6e.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Organization: HP/LKTT
Date: Wed, 17 Jun 2009 08:02:28 -0400
Message-Id: <1245240148.31940.6.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 10:22 +0900, KAMEZAWA Hiroyuki wrote:
> On Tue, 16 Jun 2009 10:59:55 -0400
> Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> 
> > On Tue, 2009-06-16 at 15:58 +0200, Stefan Lankes wrote:
> > > > 
> > > > I would like to get these patches working with latest mmotm to test on
> > > > some newer hardware where I think they will help more.  And I would
> > > > welcome your support.  However, I think we'll need to get Balbir and
> > > > Kamezawa-san involved to sort out the interaction with memory control
> > > > group.
> > > > 
> > > > I can send you the more recent rebase that I've done.  This is getting
> > > > pretty old now:  2.6.28-rc4-mmotm-081110-081117.  I'll try to rebase to
> > > > the most recent mmotm [that boots on my platforms], at least so that we
> > > > can build and boot with migrate-on-fault disabled, within the next
> > > > couple of weeks.
> > > > 
> > > 
> > > Sounds good! Send me your last version and I will try to reconstruct your
> > > problems. Afterwards, we could try to solve these problems.
> > > 
> > 
> > Stefan:
> > 
> > I've placed the last rebased version in :
> > 
> > http://free.linux.hp.com/~lts/Patches/PageMigration/2.6.28-rc4-mmotm-081110/
> > 
> > As I recall, this version DOES bug out because of reference count
> > problems due to interaction with the memory controller.
> > 
> please report in precise if memcg has bug.
> An example of test is welcome.

Not an memcg bug.  Just an implementation choice [2 phase migration
handling:  start/end calls] that is problematic for "lazy" page
migration--i.e., "migration-on-touch" in the fault path.  I'd be
interested in your opinion on the feasibility of transferring the
"charge" against the page--including the "try charge" from
do_swap_page()--in migrate_page_copy() along with other page state.

I'll try to rebase my lazy migration series to recent mmotm [as time
permits] in the "near future" and gather more info on the problem I was
having.

Regards,
Lee

