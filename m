Return-Path: <linux-kernel-owner+w=401wt.eu-S933315AbZHDSvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315AbZHDSvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 14:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933286AbZHDSvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 14:51:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37618 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933271AbZHDSvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 14:51:31 -0400
Subject: Re: fanotify - overall design before I start sending patches
From: Eric Paris <eparis@redhat.com>
To: John Stoffel <john@stoffel.org>
Cc: Valdis.Kletnieks@vt.edu, Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "malware-list@dmesg.printk.net" <malware-list@dmesg.printk.net>,
       "greg@kroah.com" <greg@kroah.com>, "jcm@redhat.com" <jcm@redhat.com>,
       Douglas Leeder <douglas.leeder@sophos.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "arjan@infradead.org" <arjan@infradead.org>,
       "david@lang.hm" <david@lang.hm>,
       "jengelh@medozas.de" <jengelh@medozas.de>,
       "aviro@redhat.com" <aviro@redhat.com>,
       "mrkafk@gmail.com" <mrkafk@gmail.com>,
       "alexl@redhat.com" <alexl@redhat.com>, "jack@suse.cz" <jack@suse.cz>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "hch@infradead.org" <hch@infradead.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "mmorley@hcl.in" <mmorley@hcl.in>, "pavel@suse.cz" <pavel@suse.cz>
In-Reply-To: <19064.31705.491774.122207@stoffel.org>
References: <1248466429.3567.82.camel@localhost>
	 <200908041709.51659.tvrtko.ursulin@sophos.com>
	 <1249403268.2361.21.camel@dhcp231-106.rdu.redhat.com>
	 <19585.1249406551@turing-police.cc.vt.edu>
	 <19064.31705.491774.122207@stoffel.org>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 14:50:15 -0400
Message-Id: <1249411815.2361.26.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 14:20 -0400, John Stoffel wrote:
> >>>>> "Valdis" == Valdis Kletnieks <Valdis.Kletnieks@vt.edu> writes:
> 
> Valdis> On Tue, 04 Aug 2009 12:27:48 EDT, Eric Paris said:
> >> On Tue, 2009-08-04 at 17:09 +0100, Tvrtko Ursulin wrote:
> >> > Would it make more sense to deny on timeouts and then evict? I am thinking it
> >> > would be more secure with no significant drawbacks. Also for usages like HSM
> >> > allowing it without data being in place might present wrong content to the
> >> > user.
> >> 
> >> I'd be willing to go that route as long as noone else complains.
> 
> Valdis> Yes, in my world, "deny on timeout and evict" is the better
> Valdis> design decision.  For an HSM, you'd rather have a
> Valdis> quick-and-ugly death on a failed file open than an app
> Valdis> accidentally reading the HSM's stub data thinking it's the
> Valdis> original data.
> 
> Speaking as somone who is working slowly to deploy an HSM service, one
> thing to note is that when you *do* see the stub file contents, you
> know that your HSM is busted somehow. 
> 
> How will fanotify deal with this issue?  Sorry, I haven't paid enough
> attention to this thread though I know I should since it's up my $WORK
> alley.

fanotify doesn't explicitly deal with it at all.  If the HSM implemented
as a fanotify listener starts to misbehave and not respond, processes
will start to get EACCES.  If it misses 10 in a row it'll be evicted and
processes will start to see the stubs.

-Eric

