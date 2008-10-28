Return-Path: <linux-kernel-owner+w=401wt.eu-S1752399AbYJ1Ffh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbYJ1Ffh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 01:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYJ1FfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 01:35:10 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:8906 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbYJ1FfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 01:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=T08OCIkLeRhwM/1dI+rbzNim8RBfkFWoCSSIKdWGry3KC0yvOK4F52kDPDzxnRVQdM
         etuNxHYMkySV1nIO56fWjUjzMkyUUldM1SB1bVKX4his64tMrXD5eLiXntNhy00EHKd1
         CCj3kuVrF2D2+SxOQaCIbtT+2qlh7dPNSUVUY=
Subject: Re: [RFC PATCH 3/5] net/ipv4, net/ipv6: use %#p6, %p6 format
 strings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1225170338.5269.127.camel@localhost>
References: <1225166718.5526.18.camel@brick>
	 <1225170338.5269.127.camel@localhost>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 22:35:03 -0700
Message-Id: <1225172104.5526.28.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 22:05 -0700, Joe Perches wrote:
> On Mon, 2008-10-27 at 21:05 -0700, Harvey Harrison wrote:
> > diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> > index eea9542..113c4d9 100644
> > --- a/net/ipv6/addrconf.c
> > +++ b/net/ipv6/addrconf.c
> > @@ -2986,9 +2986,8 @@ static void if6_seq_stop(struct seq_file *seq, void *v)
> >  static int if6_seq_show(struct seq_file *seq, void *v)
> >  {
> >  	struct inet6_ifaddr *ifp = (struct inet6_ifaddr *)v;
> > -	seq_printf(seq,
> > -		   NIP6_SEQFMT " %02x %02x %02x %02x %8s\n",
> > -		   NIP6(ifp->addr),
> > +	seq_printf(seq, "%#p6 %02x %02x %02x %02x %8s\n",
> > +		   &ifp->addr,
> >  		   ifp->idev->dev->ifindex,
> >  		   ifp->prefix_len,
> >  		   ifp->scope,
> 
> Is it really necessary to change the formats and arguments?

Yes, in my patchset %p6 was a format for a pointer whereas NIP6()
expected a struct in6_addr, not a pointer to one.  Unless you were
referring specifically to alignment of the args, whitespace?

> 
> Perhaps it's enough to change the defines to:
> 
> #define NIP6_FMT "%6p"

I thought about this, and it will work if the one place that passes
NIP6_FMT into sscanf gets changed at the same time.  Otherwise,
doing it in-place is probably safer.

> If not, I think the NIP6 and NIP6_SEQFMT should be
> separate patchsets for ease of verification.
> 

OK, will separate it that way once I've had a chance to test this
more.

Cheers,

Harvey

