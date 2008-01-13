Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbYAMX5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbYAMX5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 18:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbYAMX47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 18:56:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38595 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662AbYAMX46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 18:56:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 3/5] NLM: Have lockd call try_to_freeze
Date: Mon, 14 Jan 2008 00:59:08 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jeff Layton <jlayton@redhat.com>, akpm@linux-foundation.org,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1199988096-19700-1-git-send-email-jlayton@redhat.com> <20080113065453.4774f8dd@tleilax.poochiereds.net> <18314.36787.541818.450563@notabene.brown>
In-Reply-To: <18314.36787.541818.450563@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801140059.09078.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 13 of January 2008, Neil Brown wrote:
> On Sunday January 13, jlayton@redhat.com wrote:
> > On Thu, 10 Jan 2008 13:01:34 -0500
> > Jeff Layton <jlayton@redhat.com> wrote:
> > 
> > > lockd makes itself freezable, but never calls try_to_freeze(). Have it
> > > call try_to_freeze() within the main loop.
> > > 
> > > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > > ---
> > >  fs/lockd/svc.c |    3 +++
> > >  1 files changed, 3 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
> > > index 82e2192..6ee8bed 100644
> > > --- a/fs/lockd/svc.c
> > > +++ b/fs/lockd/svc.c
> > > @@ -155,6 +155,9 @@ lockd(struct svc_rqst *rqstp)
> > >  		long timeout = MAX_SCHEDULE_TIMEOUT;
> > >  		char buf[RPC_MAX_ADDRBUFLEN];
> > >  
> > > +		if (try_to_freeze())
> > > +			continue;
> > > +
> > >  		if (signalled()) {
> > >  			flush_signals(current);
> > >  			if (nlmsvc_ops) {
> > 
> > 
> > I was looking over svc_recv today and noticed that it calls
> > try_to_freeze a couple of times. Given that, the above patch may be
> > unnecessary. I don't think it hurts anything though. Should we keep
> > this patch or drop it?
> 
> I would suggest dropping it.
> Having unnecessary code is likely to be confusing.

But adding a comment instead of it won't hurt, IMHO. :-)

Greetings,
Rafael
