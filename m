Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbYDJRQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbYDJRQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 13:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbYDJRQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 13:16:33 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53316 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611AbYDJRQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 13:16:32 -0400
Date: Thu, 10 Apr 2008 12:14:53 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>, sukadev@us.ibm.com,
       Andrew Morton <akpm@osdl.org>, serue@us.ibm.com,
       "David C. Hansen" <haveblue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] change clone_flags type to u64
Message-ID: <20080410171453.GA7023@sergelap.ibm.com>
References: <20080409222611.GA28087@us.ibm.com> <20080409223231.GA28267@us.ibm.com> <871w5enmk7.fsf@basil.nowhere.org> <47FE073B.3060007@fr.ibm.com> <20080410125205.GG10019@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410125205.GG10019@one.firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andi Kleen (andi@firstfloor.org):
> > I guess that was a development rationale. 
> 
> But what rationale? It just doesn't make much sense to me.
> 
> > Most of the namespaces are in 
> > use in the container projects like openvz, vserver and probably others 
> > and we needed a way to activate the code.
> 
> You could just have added it to feature groups over time.
> 
> > 
> > Not perfect I agree.
> >  
> > > With your current strategy are you sure that even 64bit will
> > > be enough in the end? For me it rather looks like you'll
> > > go through those quickly too as more and more of the kernel
> > > is namespaced.
> > 
> > well, we're reaching the end. I hope ! devpts is in progress and
> > mq is just waiting for a clone flag.
> 
> Are you sure?

Well for one thing we can take a somewhat different approach to new
clone flags.  I.e. we could extend CLONE_NEWIPC to do mq instead of
introducing a new clone flag.  The name doesn't have 'sysv' in it,
and globbing all ipc resources together makes some amount of sense.
Similarly has hpa+eric pointed out earlier, suka could use
CLONE_NEWDEV for ptys.  If we have net, pid, ipc, devices, that's a
pretty reasonable split imo.  Perhaps we tie user to devices and get
rid of CLONE_NEWUSER which I suspect noone is using atm (since only
Dave has run into the CONFIG_USER_SCHED problem).  Or not.  We could
roll uts into net, and give CLONE_NEWUTS a deprecation period.

-serge
