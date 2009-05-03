Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbZECPie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbZECPie (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 11:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbZECPiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 11:38:24 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54682 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836AbZECPiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 11:38:23 -0400
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: david@lang.hm
Cc: Willy Tarreau <w@1wt.eu>, Bart Van Assche <bart.vanassche@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>, Kyle Moffett <kyle@moffetthome.net>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
In-Reply-To: <alpine.DEB.1.10.0905030816090.15782@asgard>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>
	 <20090501015902.ed8b56d3.akpm@linux-foundation.org>
	 <e2e108260905020033h457ed97ayfd8392d1249a943a@mail.gmail.com>
	 <20090503053557.GH570@1wt.eu> <alpine.DEB.1.10.0905022239100.15782@asgard>
	 <1241360474.5596.4.camel@mulgrave.int.hansenpartnership.com>
	 <alpine.DEB.1.10.0905030735500.15782@asgard>
	 <1241361925.5596.27.camel@mulgrave.int.hansenpartnership.com>
	 <alpine.DEB.1.10.0905030753380.15782@asgard>
	 <1241363371.5596.45.camel@mulgrave.int.hansenpartnership.com>
	 <alpine.DEB.1.10.0905030816090.15782@asgard>
Content-Type: text/plain
Date: Sun, 03 May 2009 10:38:21 -0500
Message-Id: <1241365101.5596.69.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-03 at 08:22 -0700, david@lang.hm wrote:
> On Sun, 3 May 2009, James Bottomley wrote:
> 
> >> On Sun, 3 May 2009, James Bottomley wrote:
> >>
> >>> Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
> >>>
> >>> On Sun, 2009-05-03 at 07:36 -0700, david@lang.hm wrote:
> >>>> On Sun, 3 May 2009, James Bottomley wrote:
> >>>>
> >>>>> Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
> >>>>>
> >>>>> On Sat, 2009-05-02 at 22:40 -0700, david@lang.hm wrote:
> >>>>>> On Sun, 3 May 2009, Willy Tarreau wrote:
> >>>>>>
> >>>>>>> On Sat, May 02, 2009 at 09:33:35AM +0200, Bart Van Assche wrote:
> >>>>>>>> On Fri, May 1, 2009 at 10:59 AM, Andrew Morton
> >>>>>>>> <akpm@linux-foundation.org> wrote:
> >>>>>>>>> On Thu, 30 Apr 2009 13:26:36 +0200 Philipp Reisner <philipp.reisner@linbit.com> wrote:
> >>>>>>>>>
> >>>>>>>>>> This is a repost of DRBD
> >>>>>>>>>
> >>>>>>>>> Is it being used anywhere for anything?  If so, where and what?
> >>>>>>>>
> >>>>>>>> One popular application is to run iSCSI and HA software on top of DRBD
> >>>>>>>> in order to build a highly available iSCSI storage target.
> >>>>>>>
> >>>>>>> Confirmed, I have several customers who're doing exactly that.
> >>>>>>
> >>>>>> I will also say that there are a lot of us out here who would have a use
> >>>>>> for DRDB in our HA setups, but have held off implementing it specificly
> >>>>>> because it's not yet in the upstream kernel.
> >>>>>
> >>>>> Actually, that's not a particularly strong reason because we already
> >>>>> have an in-kernel replicator that has much of the functionality of drbd
> >>>>> that you could use.  The main reason for wanting drbd in kernel is that
> >>>>> it has a *current* user base.
> >>>>>
> >>>>> Both the in kernel md/nbd and drbd do sync and async replication with
> >>>>> primary side bitmaps.  The main differences are:
> >>>>>
> >>>>>      * md/nbd can do 1 to N replication,
> >>>>>      * drbd can do active/active replication (useful for cluster
> >>>>>        filesystems)
> >>>>>      * The chunk size of the md/nbd is tunable
> >>>>>      * With the updated nbd-tools, current md/nbd can do point in time
> >>>>>        rollback on transaction logged secondaries (a BCS requirement)
> >>>>>      * drbd manages the mirror state explicitly, md/nbd needs a user
> >>>>>        space helper
> >>>>>
> >>>>> And probably a few others I forget.
> >>>>
> >>>> one very big one:
> >>>>
> >>>> DRDB has better support for dealing with split brain situations and
> >>>> recovering from them.
> >>>
> >>> I don't really think so.  The decision about which (or if a) node should
> >>> be killed lies with the HA harness outside of the province of the
> >>> replication.
> >>>
> >>> One could argue that the symmetric active mode of drbd allows both nodes
> >>> to continue rather than having the harness make a kill decision about
> >>> one.  However, if they both alter the same data, you get an
> >>> irreconcilable data corruption fault which, one can argue, is directly
> >>> counter to HA principles and so allowing drbd continuation is arguably
> >>> the wrong thing to do.
> >>
> >> but the issue is that at the time the failure is taking place, neither
> >> side _knows_ that the other side is running. In fact, they both think that
> >> the other side is dead.
> >
> > Resolving this is the job of the HA harness, as I said ... the usual
> > solution being either third node pings or confirmable switchover.
> 
> and none of those solutions are failsafe in a distributed environment (in 
> a local environment you can have a race to see which system powers off the 
> other first to ensure that at most one is running, but you can't do that 
> reliably remotely)

Um, yes they are, that's why they're used.

Do you understand how they work?

Third node ping means that there has to be an external third node acting
as mediator (like a quorum device) ... usually in a third location.  A
node surviving has to make contact with it before failover can proceed
automatically (the running node has to be in contact to keep running).

Confirmable switchover is where the cluster detects the failure and
pages an admin to check on the remote and confirm or deny the switch
over manually.  Without the confirmation it just waits.

Both of these mechanisms are robust to split brain.  By and large most
enterprises I've seen go for confirmable switchover, but some do
implement third node ping.

> >> with DRDB, when the two sides start talking again they will discover that
> >> they are different and complain, loudly, to the sysadmin that they need
> >> help
> >
> > The object of HA is to prevent data becoming toast, not to point it out
> > to the sysadmin after the fact.
> 
> it needs to do both
> 
> >> with md/ndb you have the situation where both sides will try to resync to
> >> the other side as soon as the packets can get through. this can end up
> >> corrupting both sides if it's not caught fast enough
> >
> > Actually, that's just your implementation: md/nbd does nothing to
> > re-establish the replication, it has to be done by the HA harness after
> > split brain resolution.  What a correct harness would do is to compare
> > the HA event log and the intent logs to see if there had been activity
> > to both sides after loss of contact and, if their had, to flag the data
> > corruption problem and not resume replication.
> >
> > This corruption situation isn't unique to replication ... any time you
> > may potentially have allowed both sides to write to a data store, you
> > get it, that's why it's the job of the HA harness to sort out whether a
> > split brain happened and what to do about it *first*.
> 
> but you can have packets sitting in the network buffers waiting to get to 
> the remote machine, then once the connection is reestablished those 
> packets will go out. no remounting needed., just connectivity restored. 
> (this isn't as bad as if the system tries to re-sync to the temprarily 
> unavailable drive by itself, but it can still corrupt things)

This is an interesting thought, but not what happens.  As soon as the HA
harness stops replication, which it does at the instant failure is
detected, the closure of the socket kills all the in flight network
data.

There is an variant of this problem that occurs with device mapper
queue_if_no_path (on local disks) which does exactly what you say (keeps
unsaved data around in the queue forever), but that's fixed by not using
queue_if_no_path for HA.  Maybe that's what you were thinking of?

> a cluster spread across different locations has problems to face that a 
> cluster within easy cabling distance does not.
> 
> DRDB has been extensivly tested and build to survive in the harsher 
> environment.

There are commercial HA products based on md/nbd, so I'd say it's also
hardened for harsher environments

>  md/ndb is a reasonable approximation for the simple 
> enviornment of two servers in one datacenter, but that doesn't mean that 
> it handles the rest of the possible conditions.

The implementations I've seen do ... and that includes some fairly
exotic cascading WAN replication ones.

James


