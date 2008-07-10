Return-Path: <linux-kernel-owner+w=401wt.eu-S1758341AbYGJPoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbYGJPoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbYGJPnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:43:52 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34989 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbYGJPnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:43:52 -0400
Date: Thu, 10 Jul 2008 09:40:09 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Cedric Le Goater <clg@fr.ibm.com>,
       Pavel Machek <pavel@ucw.cz>, Paul Menage <menage@google.com>,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/4] Container Freezer: Reuse Suspend Freezer
Message-ID: <20080710144009.GA8619@us.ibm.com>
References: <20080707225823.502032693@us.ibm.com> <20080708123150.3034d83f.kamezawa.hiroyu@jp.fujitsu.com> <1215545954.9023.120.camel@localhost.localdomain> <6599ad830807081306l61622eadk215a25d02ee94b00@mail.gmail.com> <6599ad830807081307j811689aldf0f6cb38579c450@mail.gmail.com> <1215640723.7149.35.camel@localhost.localdomain> <20080710094231.58d9e1b9.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710094231.58d9e1b9.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting KAMEZAWA Hiroyuki (kamezawa.hiroyu@jp.fujitsu.com):
> On Wed, 09 Jul 2008 14:58:43 -0700
> Matt Helsley <matthltc@us.ibm.com> wrote:
> 
> > 
> > On Tue, 2008-07-08 at 13:07 -0700, Paul Menage wrote:
> > > On Tue, Jul 8, 2008 at 1:06 PM, Paul Menage <menage@google.com> wrote:
> > > > On Tue, Jul 8, 2008 at 12:39 PM, Matt Helsley <matthltc@us.ibm.com> wrote:
> > > >>
> > > >> One is to try and disallow users from moving frozen tasks. That doesn't
> > > >> seem like a good approach since it would require a new cgroups interface
> > > >> "can_detach()".
> > > >
> > > > Detaching from the old cgroup happens at the same time as attaching to
> > > > the new cgroup, so can_attach() would work here.
> > 
> > Update: I've made a patch implementing this. However it might be better
> > to just modify attach() to thaw the moving task rather than disallow
> > moving the frozen task. Serge, Cedric, Kame-san, do you have any
> > thoughts on which is more useful and/or intuitive?
> > 
> 
> Thank you for explanation in previous mail.
> 
> Hmm, just thawing seems atractive but it will confuse people (I think).
> 
> I think some kind of process-group is freezed by this freezer and "moving
> freezed task" is wrong(unexpected) operation in general.  And there will
> be no demand to do that from users.
> I think just taking "moving freezed task" as error-operation and returning
> -EBUSY is better.
> 
> Thanks,
> -Kame

I'm torn.  Allowing the moves is kind of cool, but I think I agree that
we should start out with the simpler semantics, which in this case is
disallowing the move.  The race Li may have found will only become more
complicated when both sides of the race can change the task's frozen
state.

-serge
