Return-Path: <linux-kernel-owner+w=401wt.eu-S1764286AbYFFGNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764286AbYFFGNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 02:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYFFGNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 02:13:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:44063 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751613AbYFFGNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 02:13:04 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/17eYRpdb1dXwApJdj9FFWBI1Lad4Qw5jH9Zxpfa
	fbZ/5+2jtLyR0e
Subject: Re: [patch] Re: PostgreSQL pgbench performance regression in
	2.6.23+
From: Mike Galbraith <efault@gmx.de>
To: Greg Smith <gsmith@gregsmith.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <Pine.GSO.4.64.0806060027290.8466@westnet.com>
References: <1211440207.5733.8.camel@marge.simson.net>
	 <20080522082814.GA4499@linux.vnet.ibm.com>
	 <1211447105.4823.7.camel@marge.simson.net>
	 <1211452465.7606.8.camel@marge.simson.net>
	 <1211455553.4381.9.camel@marge.simson.net>
	 <1211456659.29104.20.camel@twins>
	 <1211458176.5693.6.camel@marge.simson.net>
	 <1211459081.29104.40.camel@twins>
	 <Pine.GSO.4.64.0805230232190.28654@westnet.com>
	 <1211536814.5851.18.camel@marge.simson.net>
	 <20080523101000.GA13964@elte.hu>
	 <1211537717.5851.22.camel@marge.simson.net>
	 <Pine.GSO.4.64.0805231907150.25273@westnet.com>
	 <1211586407.4786.5.camel@marge.simson.net>
	 <Pine.GSO.4.64.0805260851510.24771@westnet.com>
	 <1211867950.5505.47.camel@marge.simson.net>
	 <Pine.GSO.4.64.0806060027290.8466@westnet.com>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 08:13:00 +0200
Message-Id: <1212732780.13981.43.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-06-06 at 01:03 -0400, Greg Smith wrote:

> I think I might not be testing exactly the same thing you did, though, 
> because the pattern doesn't match.  I think that my Q6600 system runs a 
> little bit faster than yours, which is the case for small numbers of 
> clients here.  But once we get above 8 clients your setup is way faster, 
> with the difference at 15 clients being the largest.  Were you perhaps 
> using batch mode when you generated these results?

No, those were with stock settings.

> Regardless, clearly your patch reduces the regression with the default 
> parameters to a mild one instead of the gigantic one we started with.

Unfortunately, after the recent reverts, we're right back to huge :-/

I'm trying to come up with a dirt simple solution that doesn't harm
other load types.  I've found no clear reason why we regressed so badly,
it seems to be a luck of the draw run order thing.  As soon as the load
starts jamming up a bit, it avalanches into a serialized mess again.  I
know the why, just need to find that dirt simple and pure win fix.
 
> Considering how generally incompatible this benchmark is with this 
> scheduler, and that there are clear workarounds (feature disabling) I can 
> document in PostgreSQL land to "fix" the problem defined for me now, I'd 
> be happy if all that came from this investigation was this change.  I'd 
> hope that being strengthened against this workload improves the 
> scheduler's robustness for other tasks of this type, which I'm sure there 
> are more of than just pgbench.

I consider pgbench to be a pretty excellent testcase.  Getting this
fixed properly will certainly benefit similar loads, Xorg being one
that's just not as extreme as pgbench.

> You get my vote for moving toward committing it+backport even if 
> the improvement is only what I saw in my tests.  If I can figure out how 
> to get closer to the results you got, all the better.

It's committed, but I don't think a back-port is justified.  It does
what it's supposed to do, but there's a part 2.  I suspect that your
results differ from mine due to that luck of the run order draw thing.

	-Mike

