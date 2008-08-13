Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbYHMJcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbYHMJcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 05:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYHMJcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 05:32:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44551
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751860AbYHMJca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 05:32:30 -0400
Date: Wed, 13 Aug 2008 02:32:31 -0700 (PDT)
Message-Id: <20080813.023231.110118129.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: harvey.harrison@gmail.com, mingo@elte.hu, hpa@zytor.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       per.liden@ericsson.com, jon.maloy@ericsson.com,
       allan.stephens@windriver.com
Subject: Re: [PATCH] tipc: Use the appropriate swab helper rather than an
 internal helper
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080812212017.febf1392.akpm@linux-foundation.org>
References: <20080812205422.4273d598.akpm@linux-foundation.org>
	<1218600348.30194.105.camel@brick>
	<20080812212017.febf1392.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 12 Aug 2008 21:20:17 -0700

> On Tue, 12 Aug 2008 21:05:47 -0700 Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > ___generally means I am an internal implementation detail, don't use
> > me.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> > Sorry for breaking the build Andrew, my testing has been with all the __constant
> > versions in-tree removed.
> > 
> >  net/tipc/subscr.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/net/tipc/subscr.c b/net/tipc/subscr.c
> > index 0326d30..f5da05d 100644
> > --- a/net/tipc/subscr.c
> > +++ b/net/tipc/subscr.c
> > @@ -85,7 +85,7 @@ static struct top_srv topsrv = { 0 };
> >  
> >  static u32 htohl(u32 in, int swap)
> >  {
> > -	return swap ? (u32)___constant_swab32(in) : in;
> > +	return swap ? (u32)swab32(in) : in;
> >  }
> 
> yes, that's what I did too, only I dropped the
> seems-to-me-to-be-unneeded (u32) cast.

I've applied Andrew's patch.
