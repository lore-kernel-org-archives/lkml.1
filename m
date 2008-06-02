Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbYFBQKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbYFBQKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 12:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYFBQK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 12:10:27 -0400
Received: from elasmtp-galgo.atl.sa.earthlink.net ([209.86.89.61]:36979 "EHLO
	elasmtp-galgo.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752024AbYFBQK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 12:10:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=cUPVyXTXmOUu6VMwEuCl89UA4xHt2jcJIq4EIa1FD+ZnWMRFYrDI0PqtnD2gw3Nk;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Mon, 2 Jun 2008 12:10:07 -0400
From: Bill Fink <billfink@mindspring.com>
To: Glen Turner <gdt@gdt.id.au>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, James Cammarata <jimi@sngx.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: add ability to clear stats via ethtool -
 e1000/pcnet32
Message-Id: <20080602121007.1e81cf05.billfink@mindspring.com>
In-Reply-To: <48437C25.7080400@gdt.id.au>
References: <482DA5B6.1020606@sngx.net>
	<482DB46A.8020103@cosmosbay.com>
	<482EF192.4070707@sngx.net>
	<482F5113.5090703@cosmosbay.com>
	<482F610D.2080108@sngx.net>
	<20080518003104.GK28241@solarflare.com>
	<482FBA09.80201@sngx.net>
	<483E0AAE.2020107@sngx.net>
	<20080528221118.63da4092.akpm@linux-foundation.org>
	<483EA2D1.8050603@sngx.net>
	<20080529154525.3916c7b5@core>
	<20080530151250.b44a119a.billfink@mindspring.com>
	<20080531131143.516ca56e@core>
	<20080531195702.0b879dd1.billfink@mindspring.com>
	<48437C25.7080400@gdt.id.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.8.6; powerpc-yellowdog-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4ded225e7aee61fabeb594fab101a79868350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 96.234.158.248
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2008, Glen Turner wrote:

> 
> > Yes, every individual Linux network administrator can re-create the
> > wheel by devising their own scripts, but it makes much more sense
> > to me to implement a simple general kernel mechanism once that could
> > be used generically, than to have hundreds (or thousands) of Linux
> > network administrators each having to do it themselves (perhaps
> > multiple times if they have a variety of types of systems and types
> > of NICs).
> 
> Hi Bill,
> 
> If you pull the stats using a SNMP polling tool (torrus, cacti, mrtg)
> then those package's graphs give nice "did this get better or worse"
> output for debugging network issues.

I do use mrtg for network monitoring to determine when things go
bad, but when they do go bad, then I typically need to get much
more detailed info when troubleshooting the problem.

> I'd suggest you use one of those tools rather than writing your
> own scripts.  Even if 99% of the time the graphs record zero errors,
> knowing when those errors started is very valuable and well worth
> the additional effort of configuring the tools over a command-line
> or a kernel hack.

First of all, when assisting a user, they typically aren't even
running an snmp daemon (and there might be firewall issues to
access it if they are).  And I don't think the "ethtool -S" driver
stats are even accessible via SNMP (although they may contribute
to more generic interface stats which are), and it is the specific
driver stats which are often key to help diagnosing the problem.

> The more sophisticated tools can do alerting to Nagios should
> a variable suddenly change its behaviour.

Definitely useful for certain arenas.

> The Cisco/Juniper/everyone-else feature to run console stats
> separately from SNMP stats is nice, but it's rather tuned to
> the needs of router-heads and tends to fall apart when multiple
> staff are debugging a fault.

I use it all the time in coordination with network peers and
joint troubleshooting.  They clear the interface stats, and they
and I can then view the interface stats as a test is run (they
give me RO access to view the stats), or vice versa depending
on whose network is being examined.

> If we do proceed with better command line stats then the number
> of errored seconds and the worst errored second and its value
> would be useful. These useful numbers can't be calculated by
> the SNMP polling tools and it's hard to see how they could be
> done in user-space.

I'm all for any improved debugging/diagnostic capabilities, including
the extremely useful ability to clear/snapshot driver stats (there
could also be an option to un-snapshot if you wanted to get back to
seeing the absolute counter values).

						-Bill
