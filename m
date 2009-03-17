Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbZCQPay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbZCQPay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 11:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbZCQPal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 11:30:41 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46519 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbZCQPak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 11:30:40 -0400
Date: Tue, 17 Mar 2009 11:28:02 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>
Subject: Re: 2.6.29-rc8: Reported regressions from 2.6.28
Message-ID: <20090317152801.GA6737@tuxdriver.com>
References: <b6a2187b0903141958u9dae0fdk1f44b387108b99e4@mail.gmail.com> <b6a2187b0903142006u546fad9eme66f9ea7b464b81f@mail.gmail.com> <1237140665.24621.2.camel@johannes.local> <alpine.LFD.2.00.0903151136310.3131@localhost.localdomain> <1237143683.24621.7.camel@johannes.local> <20090315202603.GA9077@elte.hu> <b6a2187b0903160624gb9d207dv301506e589d93ed4@mail.gmail.com> <alpine.LFD.2.00.0903161250080.3082@localhost.localdomain> <b6a2187b0903161655q15437156qc926c8db37d8ba4b@mail.gmail.com> <20090317144802.GF3549@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090317144802.GF3549@tuxdriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 10:48:02AM -0400, John W. Linville wrote:
> On Tue, Mar 17, 2009 at 07:55:49AM +0800, Jeff Chua wrote:
> > On Tue, Mar 17, 2009 at 3:57 AM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > 
> > > IOW, if you've pinpointed 71c11fb57b924c160297ccd9e1761db598d00ac2 as
> > > being bad, then you should go back and double-check that its parent
> > > (in this case 4607816f608b42a5379aca97ceed08378804c99f) is good.
> > > Because if it's parent is also bad, then that just means that you made
> > > some mistake in "git bisect".
> > > In this case, it really sounds like maybe you marked the parent good, even
> > > though you should have marked it bad.
> > 
> > I should have been more careful, just got thrown off during the last
> > few steps of the bisect. But with the bad association to the AP after
> > a57a59f247b651e8ed6d3eeb7e2f9d83b83134c9 (iwlwifi: remove implicit
> > direct scan), can someone suggest where to go from here?
> 
> The obvious question for me is did you try this?
> 
> 	git revert a57a59f247b651e8ed6d3eeb7e2f9d83b83134c9

Hmmm...more like this:

git revert 41bb73eeac5ff5fb217257ba33b654747b3abf11
git revert b23f99bcfa12c7b452f7ad201ea5921534d4e9ff
git revert 71c11fb57b924c160297ccd9e1761db598d00ac2
git revert 4607816f608b42a5379aca97ceed08378804c99f
git revert a57a59f247b651e8ed6d3eeb7e2f9d83b83134c9
 
This first one has a conflict -- just take the hunk.

> Does that restore operation for you?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
