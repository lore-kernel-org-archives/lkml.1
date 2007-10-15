Return-Path: <linux-kernel-owner+w=401wt.eu-S1763652AbXJOPNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763652AbXJOPNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 11:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554AbXJOPN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 11:13:26 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:35463 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739AbXJOPNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 11:13:24 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 7 (2.6.23) Smack: Simplified Mandatory Access Control Kernel
Date: Mon, 15 Oct 2007 11:12:47 -0400
User-Agent: KMail/1.9.7
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>, torvalds@osdl.org,
       akpm@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <779660.41682.qm@web36610.mail.mud.yahoo.com>
In-Reply-To: <779660.41682.qm@web36610.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710151112.47248.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 October 2007 11:30:53 pm Casey Schaufler wrote:
> --- "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:
> > Hi Casey,
> >
> > On Sun, Oct 14, 2007 at 10:15:42AM -0700, Casey Schaufler wrote:
> > > +
> > > +CIPSO Configuration
> > > +
> > > +It is normally unnecessary to specify the CIPSO configuration. The
> > > default +values used by the system handle all internal cases. Smack
> > > will compose
> >
> > CIPSO
> >
> > > +label values to match the Smack labels being used without
> > > administrative +intervention.
> >
> > I have two issues with CIPSO and Smack:
> >
> > 1-
> >
> > Using default configuration (system startup script + smacfs fstab line),
> > system
> > can't access any service outside the Lan. "ICMP parameter problem
> > message" always
> > appear from the first Wan router (traceroute + tcpdump at [1]).
> >
> > Services inside the LAN can be accessed normally. System can connect to a
> > Lan Windows share. It also connects to the gateway HTTP server easily.
> >
> > After some tweaking, I discovered that using CIPSOv6 solves all above
> > problems:
> > $ echo -n "NLBL_CIPSOv6" > /smack/nltype
> >
> > Is this a normal behaviour ?
>
> Well ... sort of. CIPSOv6 isn't actually implemented in the
> labeled networking code. What you're seeing is unlabeled packets.
>
> As far as CIPSOv4 and your WAN router, It is possible that it is
> configured either to reject CIPSO packets or to allow only CIPSO
> packets in a particular DOI or to enforce a CIPSO policy of its
> own.

The how/why of the packet rejection probably isn't all that important, but the 
most likely scenario based on the ICMP error code is that the router simply 
does not know about the CIPSO IP option type and is dropping the packet as a 
result.  I'd be very surprised to see a standard router in general use which 
has policy to perform packet level access control using CIPSO options/labels.

-- 
paul moore
linux security @ hp
