Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbXJ3Xo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbXJ3Xo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbXJ3XoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:44:19 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42479 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753495AbXJ3XoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:44:18 -0400
Date: Tue, 30 Oct 2007 16:44:14 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071030164414.b353e41c.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710301607430.19750@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
	<1193433239.5032.95.camel@localhost>
	<alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>
	<1193434278.5032.106.camel@localhost>
	<alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
	<20071026180713.aeedfac2.pj@sgi.com>
	<Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com>
	<20071026194144.6042316a.pj@sgi.com>
	<alpine.DEB.0.9999.0710262149090.26464@chino.kir.corp.google.com>
	<20071027161955.e9d4d2db.pj@sgi.com>
	<alpine.DEB.0.9999.0710272231170.23796@chino.kir.corp.google.com>
	<20071028164637.8d1b45b0.pj@sgi.com>
	<alpine.DEB.0.9999.0710281742090.26837@chino.kir.corp.google.com>
	<20071028212745.57a7db67.pj@sgi.com>
	<alpine.DEB.0.9999.0710282130320.32474@chino.kir.corp.google.com>
	<20071029001554.c12b6b6c.pj@sgi.com>
	<alpine.DEB.0.9999.0710301607430.19750@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> If your argument is that most applications are written to implement 
> mempolicies without necessarily thinking too much about its cpuset 
> placement or interactions with cpusets, then the requirement of remapping 
> nodes when a cpuset changes for effected mempolicies isn't actually that 
> important.

Just because they didn't think about cpuset remapping when they coded
their mempolicy calls, doesn't mean they wouldn't be broken by changes
in how mempolicy numbers nodes.  Often, it's the other way around:
the less they though of it, the more likely changing it would break
them.

> In other words, my Choice C with AND'd behavior as opposed to 
> remapping behavior could be introduced as a replacement for Choice A.

No - I will not agree to changing the default mempolicy kernel API node
numbering at this time.  Period.  Full stop.  We can add non-default
choices for now, and perhaps in the light of future experience, we
may choose to do more later.

> Those applications that currently rely on the remapping are going to be 
> broken anyway because they are unknowingly receiving different nodes than 
> they intended, this is the objection to remapping that Lee agreed with.

No, they may or may not be broken.  That depends on whether or not they had
specific hardware locality or affinity needs.

> The remap doesn't take into account any notion of locality or affinity to 
> physical controllers and seems to be merely a convenience of not 
> invalidating the entire mempolicy in light of an ever-changing cpuset 
> policy.

If you're running apps that have specific hardware affinity requirements,
then perhaps you shouldn't be moving them about in the first place ;).
And if they did have such needs, aren't they just as likely to be busted
by AND'ing off some of their nodes as they are by remapping those nodes?

I sure wish I knew what real world, actual, not hypothetical, situations
were motivating this.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
