Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbYEaK2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbYEaK2T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 06:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYEaK2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 06:28:09 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:49136 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbYEaK2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 06:28:08 -0400
X-Originating-Ip: 216.16.235.2
Date: Sat, 31 May 2008 06:27:52 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: linux-kernel@vger.kernel.org
Subject: OOM policy, overcommit control, and soft limits
Message-ID: <20080531102752.GA25244@foursquare.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam (whitelisted),
	SpamAssassin (not cached, score=-16.8, required 5,
	autolearn=not spam, ALL_TRUSTED -1.80, BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: <cdfrey@netdirect.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The kernel provides things like ulimit, overcommit_memory, and the OOM
killer notifications, so in theory memory management should not be a
problem, but from time to time, I have a real need to regain control of
my system when it runs away on me.

I like how mode 2 of overcommit_memory uses the ratio as a boundary limit.
Ideally I would like something like this as a soft limit, so once the
system gets that full, I get a warning.

Here's my ideal OOM flow:

	1) set my soft limit to 90% of RAM

	2) any malloc that hits this limit first runs through a notification
		hook, that talks to a userspace daemon if present,
		or just denies the malloc if not

	3) the daemon can decide whether to allow the allocation, going
		beyond the soft limit

	4) the daemon can make these decisions automatically based on
		policy (i.e. X always gets the green light), or if we
		want to get fancy it can talk to some pre-allocated
		GUI to present the decision to the user...
		(i.e. Allocate / Deny / Stop / Kill)

	5) if the user foolishly keeps allocating, then the current
		OOM killer comes into play

I'm sure someone has thought of this before me.  Does anything remotely
similar to this already exist?  I've googled for OOM policy, but so far
all I've seen is Rusty Lynch's patch from 2003, and really, I want this
behaviour to happen when there is still a bit of memory left, so things
can be dealt with before they are OOM-level dire.

Thanks in advance,
- Chris

