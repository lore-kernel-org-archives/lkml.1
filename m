Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbXFXT7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbXFXT7O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 15:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbXFXT64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 15:58:56 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:26355 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbXFXT6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 15:58:55 -0400
Date: Sun, 24 Jun 2007 21:58:54 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: djones@rossove.com, LKML Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org
Subject: Re: Scaling Max IP address limitation
In-Reply-To: <D6003DDE-0C36-437B-B70A-D422DFE153D0@mac.com>
Message-ID: <Pine.LNX.4.64.0706242153240.11964@fbirervta.pbzchgretzou.qr>
References: <467EA7C1.4080006@rossove.com> <D6003DDE-0C36-437B-B70A-D422DFE153D0@mac.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 24 2007 15:08, Kyle Moffett wrote:
>
> Do you really need that many IP addresses?  When somebody finally gets
> around to implementing REDIRECT support for ip6tables then you could
> just redirect them all to the same port on the local system.

The way I see it, it's: "if someone gets around to implement *IPv6 NAT*"
(which, if its designers were asked, is contrary to the idea of ipv6).

> <Unrelated wishful thinking>
> I keep having hopeful dreams that one day netfilter will grow support for
> cross-protocol NAT (IE: NAT a TCPv4 connection over TCPv6 to the IPv6-only
> local web server, or vice versa).  It would seem that would require a merged
> "xtables" program.
>
> Having routing table operations, IPsec transformations, etc just be
> another step in the firewall rules would also be useful.  It would be
> handy to be able to "-j ROUTE", then "-j IPSEC", then "-j ROUTE" again,
> to re-route the now-encapsulated IPsec packets to their proper
> destination.

Absolutely...

> That would also eliminate the sort-of-hacky problems with
> destination network interface in the bridging code:

Where's the hack? iptables operates on what it sees, and it sees br0.
The physdev match is justified IMO.

> "-j BRIDGE" might be
> another step in the process, and conceivably you could have independent
> bridge MAC tables too.

Whether a packet goes out a bridge (was that the intention of -j BRIDGE?)
is determined by the routing table, which, in most cases, is just a matter
of destination address.

> You'd probably also want "-j BRIDGE_TEST" and
> "-j ROUTE_TEST" to compute the output network interface without actually
> modifying the addresses.
>
> That would also appear to get rid of the need for all tables other than
> "filter" and all predefined chains other than "INPUT" and "OUTPUT".  Default
> rules would be these:
> nettables -A INPUT -j CONNTRACK
> nettables -A INPUT -j LOCALMATCH
> nettables -A INPUT --for-this-host -j ACCEPT
> nettables -A INPUT -j OUTPUT

I'd prefer if Linux outputted its packets by default :)

> nettables -A OUTPUT -j ROUTE
> nettables -A OUTPUT -j TRANSMIT

pkttables it is!

But this idea may have its benefit: by not restricting rules to certain
positions like currently, throughput could be achieved. "Evil packets"
f.e. could be dropped really early. (Well, you could also drop them early
_today_, but a DROP in the mangle table will everyone make their eyes roll
:-)



	Jan
-- 
