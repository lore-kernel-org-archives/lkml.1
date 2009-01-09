Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbZAIIpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbZAIIpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 03:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbZAIIpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 03:45:43 -0500
Received: from 1wt.eu ([62.212.114.60]:1306 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585AbZAIIpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 03:45:42 -0500
Date: Fri, 9 Jan 2009 09:45:40 +0100
From: Willy Tarreau <w@1wt.eu>
To: jmerkey@wolfmountaingroup.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Kernel Blocking Firewall
Message-ID: <20090109084540.GH5038@1wt.eu>
References: <40416.166.70.238.44.1231467823.squirrel@webmail.wolfmountaingroup.com> <20090109064658.GG5038@1wt.eu> <37611.166.70.238.44.1231486566.squirrel@webmail.wolfmountaingroup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37611.166.70.238.44.1231486566.squirrel@webmail.wolfmountaingroup.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 12:36:06AM -0700, jmerkey@wolfmountaingroup.com wrote:
> > On Thu, Jan 08, 2009 at 07:23:43PM -0700, jmerkey@wolfmountaingroup.com
> > wrote:
> >> iptables is just too cumbersome and memory comsumptive to work well and
> >> has a shitty app inteface so I wrote one with a kernel level database
> >> and
> >> combined it with postfix.    This firewall actually drops packets on the
> >> floor by port, or in their entirety by IP address to deal with these
> >> jerks.
> >>
> >> The code is a kernel module that will build an RBL database to disk and
> >> it
> >> will cache up to 500,000 IP addresses efficiently on a 1GB home personal
> >> computer.  The more memory you have, the more IP addresses you can
> >> cache.
> >> It is configurable and possible to hold millions of them if you have 4GB
> >> of memory in the server.
> >
> > why didn't you use ipset for that ? It's designed exactly for this usage
> > and is a lot easier to use than plain iptables for dynamic filtering.
> >
> > Willy
> 
> 
> No database to store the 500,000+ addresses you will harvest in about 2
> months, that's why.  The one I did uses an lru cached database that runs
> in the kernel, and not userspace, so you can filer real time, and manage
> the database real time.

ipset runs in kernel too, you just add/remove entries from userspace
without having to touch all other ones. It has no problem storing one
million addresses and doing fast lookups on them.

I'm not dismissing your work, I just think it's a duplicate effort.

Also, since you're speaking about botnets, you should support automatic
expiration of those addresses, because almost all those addresses are
dynamic and will match a bot for a small amount of time, then match a
normal non-infected user. One of the reasons you found 500k addresses
might very well be because each bot appears one hundred times at different
addresses.

Willy

