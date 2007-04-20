Return-Path: <linux-kernel-owner+w=401wt.eu-S1754447AbXDTLBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbXDTLBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 07:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992478AbXDTLBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 07:01:33 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40371 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754447AbXDTLBc (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 07:01:32 -0400
Date: Fri, 20 Apr 2007 21:01:19 +1000
From: David Chinner <dgc@sgi.com>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070420110119.GS32602149@melbourne.sgi.com>
References: <20070419065404.GB1782@ff.dom.local> <20070419144618.GG32602149@melbourne.sgi.com> <20070420081325.GB1695@ff.dom.local> <20070420085354.GP32602149@melbourne.sgi.com> <20070420102157.GD1695@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420102157.GD1695@ff.dom.local>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 12:21:57PM +0200, Jarek Poplawski wrote:
> On Fri, Apr 20, 2007 at 06:53:54PM +1000, David Chinner wrote:
> ...
> > Yes, after spending another two hours working out why my fix was
> > then hanging in cancel_rearming_delayed_work() I was a little bit
> > annoyed at the now obviously misleading comment. Five minutes later
> 
> I agree with your feelings, but strictly speaking it's not "obviously
> misleading":
> 
> " * cancel_rearming_delayed_work - reliably kill off a delayed
> keventd work whose handler rearms the delayed work."

" This is not reliable if the handler rearms itself conditionally
and it is restarted by external means."

> And all your rearmed works were, probably, reliably killed!

Yeah, it's the ones that weren't that we the problem ;)

> > I'd fixed the bug properly. A better comment would have saved me two
> > hours of wasted time.....
> 
> It seems to be an Achilles' heel of linux... 

Too true....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
