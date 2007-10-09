Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbXJIFJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbXJIFJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 01:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbXJIFI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 01:08:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbXJIFI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 01:08:57 -0400
Message-ID: <470B0CC8.6060303@redhat.com>
Date: Tue, 09 Oct 2007 01:08:24 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Arjan van de Ven <arjan@infradead.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: gigabit ethernet power consumption
References: <20071008220720.GF3484@elf.ucw.cz>
In-Reply-To: <20071008220720.GF3484@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
> I've found that gbit vs. 100mbit power consumption difference is about
> 1W -- pretty significant. (Maybe powertop should include it in the
> tips section? :).
> 
> Energy Star people insist that machines should switch down to 100mbit
> when network is idle, and I guess that makes a lot of sense -- you
> save 1W locally and 1W on the router.
> 
> Question is, how to implement it correctly? Daemon that would watch
> data rates and switch speeds using mii-tool would be simple, but is
> that enough?

I believe you misspelled "ethtool".

While you're at it, why stop at 100Mb?  I believe you save even more power at 
10Mb, which is why WOL puts the card in 10Mb mode.  In my experience, you 
generally want either the maximum setting or the minimum setting when going for 
power savings, because of the race-to-idle effect.  Workloads that have a 
sustained fractional utilization are rare.  Right now I'm at home, hooked up to 
a cable modem, so anything over 4Mb is wasted, unless I'm talking to the box 
across the room, which is rare.

Talk to the NetworkManager folks.  This is right up their alley.

	-- Chris
