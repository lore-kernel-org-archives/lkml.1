Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbYJ3PGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbYJ3PGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 11:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbYJ3PFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 11:05:52 -0400
Received: from xes-mad.com ([216.165.139.214]:43945 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378AbYJ3PFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:05:52 -0400
Subject: Re: [PATCH] rtc-ds1307: Reset bogus register values on m41t00
From: Nate Case <ncase@xes-inc.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200810300116.33131.david-b@pacbell.net>
References: <1225301377-9092-1-git-send-email-ncase@xes-inc.com>
	 <200810300116.33131.david-b@pacbell.net>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 10:05:44 -0500
Message-Id: <1225379144.27415.111.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 01:16 -0700, David Brownell wrote:
> Hmm, you're doing this also for the ds1307 -- not just m41t00.
> Do you know that the ds1307 has this same problem?  We've had
> at least one recent report that it doesn't; see LKML archives
> for the discussion preceding the patch at the URL below.

I only intended for this to be for the M41T00, so thanks for catching
this mistake.

> Seems to me it would be good to do this whenever the oscillator
> gets (re)started, not just for m41t00 chips ... when the clock
> value is garbage, it can't hurt to initialize it.
> 
> Also, can you rework this so it applies on top of the patch
> removing these register checks?  It's in the MM tree now, and
> is archived at
> 
> 
> http://groups.google.com/group/rtc-linux/browse_thread/thread/96f89b3d8201dfef

Ah, I wasn't aware of this change.  The main reason I submitted this
patch was to prevent the driver from bailing out due to the bogus
registers in the m41t00 case.  If you're getting rid of those checks, it
makes my patch less urgent.

But, based on what you're saying, it sounds like I should rework this
patch to make a 'ds1307_reset_regs()' function that would be called both
when the registers are found to be in a bogus state (at least for the
m41t00), and also anytime we restart the oscillator for all chips?

> That rework probably won't be more than removing the last bit of
> the patch you sent.  (And didn't you get a compiler warning about
> the unused "exit_bad" label?)

I didn't get this warning because with the current mainline + my patch,
exit_bad is used in two places.

Thanks for the feedback.

-- 
Nate Case <ncase@xes-inc.com>

