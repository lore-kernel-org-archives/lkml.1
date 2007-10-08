Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356AbXJHWcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbXJHWcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 18:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbXJHWcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 18:32:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:3077 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbXJHWcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 18:32:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,244,1188802800"; 
   d="scan'208";a="230991065"
Message-ID: <470AAFD7.9060002@intel.com>
Date: Mon, 08 Oct 2007 15:31:51 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Arjan van de Ven <arjan@infradead.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: gigabit ethernet power consumption
References: <20071008220720.GF3484@elf.ucw.cz>
In-Reply-To: <20071008220720.GF3484@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Oct 2007 22:32:02.0387 (UTC) FILETIME=[0C0FEA30:01C809FB]
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

you most certainly want to do this in userspace I think.

One of the biggest problems is that link negotiation can take a significant amount
of time, well over several seconds (1 to 3 seconds typical) with gigabit, and
having your ethernet connection go offline for 3 seconds may not be the desired
effect for when you want to get more bandwidth in the first place.

However, when a laptop is in battery mode, switching down from gigabit to 100mbit
makes a lot more sense, so this is something I would recommend. This can be as
easy as changing the advertisement mask of the interface and renegotiating the
link. Userspace could handle that very easily.

Auke
