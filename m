Return-Path: <linux-kernel-owner+w=401wt.eu-S1751819AbXA0BUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbXA0BUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 20:20:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbXA0BUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 20:20:06 -0500
Received: from cavan.codon.org.uk ([217.147.92.49]:37624 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbXA0BUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 20:20:04 -0500
Date: Sat, 27 Jan 2007 01:19:54 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: David Brownell <david-b@pacbell.net>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, akpm@osdl.org
Message-ID: <20070127011954.GA13534@srcf.ucam.org>
References: <20061219185223.GA13256@srcf.ucam.org> <200701261356.42171.david-b@pacbell.net> <20070126231521.GA12370@srcf.ucam.org> <200701261642.56896.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701261642.56896.david-b@pacbell.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Fix /sys/device/.../power/state regression
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 04:42:56PM -0800, David Brownell wrote:
> On Friday 26 January 2007 3:15 pm, Matthew Garrett wrote:
> > It's certainly the case that fixing those drivers would result in a 
> > better long-term situation - however, nobody currently seems to have any 
> > interest in doing so...
> 
> And the way these things work, unfortunately, is that merging your patch
> would ensure nobody ever gets such interest.  Removing that "state" file
> (and its bogus infrastructure) has already taken a few years too long.

I'd argue that the onus is on those who wish to remove the interface to 
ensure that equivalent functionality exists first. It's not as if it's 
especially /hard/, just tedious and requires access to a large quantity 
of hardware.

> > This patch restores useful functionality  
> > without breaking the extra sanity checks that you've added. I appreciate 
> > that it's not an interface that you want to support in the long term 
> > (well, even the short term...),
> 
> You imply that it _was_ once supported, which is not true.  Like any
> other bug (in this case "design bug"), it was there and could be abused.
> And like some other bugs, fixing it can trigger complaints from (ab)users.
> 
> It's been several years now that this interface has been well recognized as
> trouble.  Years in which all _other_ users went and did the Right Thing:
> they stopped using it, or never started.

Now this is what throws me somewhat. Last May, you argued strongly in 
favour of keeping the interface:

"Which IMO makes removing this a Bad Thing.  It needs to have some
kind of replacement in place before the "magic numbers" go away."

(http://lists.osdl.org/pipermail/linux-pm/2006-May/002376.html)

"How could we schedule the removal before we have even had a couple
releases to fine-tune its replacement, and verify that the main issues
with the current thing are fully resolved?"

(http://lists.osdl.org/pipermail/linux-pm/2006-May/002382.html)

"> Maybe date will need to be shifted...

How about "one year after its replacement is ready"?"

(http://lists.osdl.org/pipermail/linux-pm/2006-May/002384.html)

I don't think there /has/ been any strong indication from the PM 
community that this interface was going to go away in the near future - 
the last time somebody tried to remove it (rather than incidentally 
breaking it), there were complaints and the matter seemed to drop.

Now, the current situation is that the interface is scheduled for 
removal in July (not something I especially agree with, and something 
you seemed to disagree with less than a year ago). However, the changes 
in 2.6.19 effectively crippled it. The current situation is that the 
only widely-used bus where this interface still works is USB, so to a 
large extent the interface has already been removed. If the interface is 
that broken, then it should just be removed now - if it's going to be 
carried around until July, it should be fixed so that it works as well 
as it did in 2.6.18 and below. The patch does that. 

-- 
Matthew Garrett | mjg59@srcf.ucam.org
