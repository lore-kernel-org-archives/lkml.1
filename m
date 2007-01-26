Return-Path: <linux-kernel-owner+w=401wt.eu-S1751757AbXAZXPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbXAZXPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 18:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbXAZXPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 18:15:39 -0500
Received: from cavan.codon.org.uk ([217.147.92.49]:57498 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbXAZXPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 18:15:38 -0500
Date: Fri, 26 Jan 2007 23:15:21 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: David Brownell <david-b@pacbell.net>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, akpm@osdl.org
Message-ID: <20070126231521.GA12370@srcf.ucam.org>
References: <20061219185223.GA13256@srcf.ucam.org> <20070125050009.GA8672@srcf.ucam.org> <20070126204140.GA8407@suse.de> <200701261356.42171.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701261356.42171.david-b@pacbell.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Fix /sys/device/.../power/state regression
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 01:56:41PM -0800, David Brownell wrote:

> I thought the resolution was that fixing a few of those drivers
> should solve the problem Matthew needed resolved, and that in
> the meanwhile "rmmod drivername" should suffice.  There also seemed
> to be agreement that power management for wireless devices needed
> more work; there might need to be a state between "down/off" and
> "configured and able to talk IP".

It's certainly the case that fixing those drivers would result in a 
better long-term situation - however, nobody currently seems to have any 
interest in doing so, and I've only got access to a subset of the 
hardware and approximately none of the documentation. It's likely that 
I'll end up spending time on that, but right now I'm afraid that other 
things are taking a higher priority.

I'm not sure what you mean by using rmmod instead. Most drivers don't 
explicitly set the power state when unbinding, and I can't see anywhere 
in the generic PCI code that will do it.

As I've said before, I think it's unreasonable to cripple interfaces for 
(mostly) aesthetic reasons without ensuring that equivalent 
functionality already exists. This patch restores useful functionality 
without breaking the extra sanity checks that you've added. I appreciate 
that it's not an interface that you want to support in the long term 
(well, even the short term...), and that suggesting its removal provides 
a useful incentive to fix things properly in the long term. But it would 
be nice if we didn't make it impossible to do this until the right thing 
is implemented.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
