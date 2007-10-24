Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbXJXT3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbXJXT3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 15:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbXJXT3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 15:29:08 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:50242 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbXJXT3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 15:29:06 -0400
In-Reply-To: <20071024191437.GF30533@stusta.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netdev-owner@vger.kernel.org
MIME-Version: 1.0
Subject: Re: [2.6 patch] unexport icmpmsg_statistics
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF621D1730.3D3366AC-ON8825737E.0069CDD5-8825737E.006AEDF9@us.ibm.com>
From: David Stevens <dlstevens@us.ibm.com>
Date: Wed, 24 Oct 2007 12:29:01 -0700
X-MIMETrack: Serialize by Router on D03NM121/03/M/IBM(Release 7.0.2FP2HF300 | September
 14, 2007) at 10/24/2007 13:29:03,
	Serialize complete at 10/24/2007 13:29:03
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

netdev-owner@vger.kernel.org wrote on 10/24/2007 12:14:37 PM:

> On Wed, Oct 24, 2007 at 12:07:45PM -0700, David Stevens wrote:
> > netdev-owner@vger.kernel.org wrote on 10/24/2007 09:24:10 AM:
> > 
> > > This patch removes the unused EXPORT_SYMBOL(icmpmsg_statistics).
> > > 
> > > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > > 
> > > ---
> > > 4ce74657ac0b1bdcb4c7bc359d05643f8cc4a08b 
> > > diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> > > index 272c69e..233de06 100644
> > > --- a/net/ipv4/icmp.c
> > > +++ b/net/ipv4/icmp.c
> > > @@ -1104,5 +1104,4 @@ void __init icmp_init(struct net_proto_family 
> > *ops)
> > >  EXPORT_SYMBOL(icmp_err_convert);
> > >  EXPORT_SYMBOL(icmp_send);
> > >  EXPORT_SYMBOL(icmp_statistics);
> > > -EXPORT_SYMBOL(icmpmsg_statistics);
> > >  EXPORT_SYMBOL(xrlim_allow);
> > 
> >         "icmpmsg_statistics" belongs with (and replaces some of the 
> > old...)
> > "icmp_statistics". I'm not sure that any modules use it, but I think 
you
> > should remove both or neither.
> 
> icmp_statistics is used by the dccp_ipv4 and sctp modules.

        The only items left in icmp_statistics are "InMsgs, InErrs, 
OutMsgs, OutErrs",
so if dccp and sctp are sending or receiving any in or out ICMP messages, 
they
should be using the new macros (which reference icmpmsg_statistics, not
icmp_statistics) to count them.
        I took a quick look at SCTP. I don't know if that's going through 
icmp_rcv()
or not; if so, I think it's double-counting; if not, then it isn't 
counting the
individual types (as it should), and it should have ICMPMSG macros doing 
that.

        So, again, icmpmsg_statistics either should stay exported, or 
neither
icmpmsg_statistics nor icmp_statistics should be exported (depending on 
how
SCTP and DCCP code is resolved). It's incorrect in the current code to
incrememnt ICMP_MIB_INMSGS without incrementing one of the types too.

 +-DLS


