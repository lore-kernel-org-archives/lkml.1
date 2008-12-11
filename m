Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbYLKWYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbYLKWYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 17:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758825AbYLKWYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 17:24:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37104 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758336AbYLKWYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 17:24:36 -0500
Date: Thu, 11 Dec 2008 17:24:32 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       mingo@elte.hu, acme@ghostprotocols.net, davem@davemloft.net
Subject: Re: [PATCH] update rwlock initialization for nat_table
In-Reply-To: <20081211141829.cda39684.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0812111721360.25125@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0812101314460.11805@gandalf.stny.rr.com> <49400B7F.7040607@cosmosbay.com> <alpine.DEB.1.10.0812101504280.11805@gandalf.stny.rr.com> <20081211141829.cda39684.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Dec 2008, Andrew Morton wrote:

> On Wed, 10 Dec 2008 15:06:00 -0500 (EST)
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > ---------------------------
> > commit d4175059c8f95e4cd58e0efaa85610ca59469fbd
> > Author: Steven Rostedt <srostedt@redhat.com>
> > Date:   Wed Dec 10 15:00:09 2008 -0500
> > 
> >     update rwlock initialization for nat_table
> >     
> >     Impact: clean up
> 
> It's more than a "cleanup"?
> 
> >     The commit e099a173573ce1ba171092aee7bb3c72ea686e59
> >     (netfilter: netns nat: per-netns NAT table) renamed the
> >     nat_table from __nat_table to nat_table without updating the
> >     __RW_LOCK_UNLOCKED(__nat_table.lock).
> >     
> >     Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > 
> > diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
> > index bea54a6..8d489e7 100644
> > --- a/net/ipv4/netfilter/nf_nat_rule.c
> > +++ b/net/ipv4/netfilter/nf_nat_rule.c
> > @@ -61,7 +61,7 @@ static struct
> >  static struct xt_table nat_table = {
> >  	.name		= "nat",
> >  	.valid_hooks	= NAT_VALID_HOOKS,
> > -	.lock		= __RW_LOCK_UNLOCKED(__nat_table.lock),
> > +	.lock		= __RW_LOCK_UNLOCKED(nat_table.lock),
> >  	.me		= THIS_MODULE,
> >  	.af		= AF_INET,
> >  };
> 
> At present any lockdep messages relating to this lock will print the
> wrong name.  So it's a nanobug, I think?

Well, I'm now working on the RT git tree, and it has a much stronger 
requirement on __RW_LOCK_UNLOCK. It actually uses the variable inside.

For mainline, it is a nanobug, but for -rt it is a compiler error. Since 
it is still a clean up, it would be nice to have it in mainline ;-)

-- Steve

