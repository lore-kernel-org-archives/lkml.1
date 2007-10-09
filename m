Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbXJIFU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbXJIFU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 01:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbXJIFUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 01:20:51 -0400
Received: from 1wt.eu ([62.212.114.60]:2855 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbXJIFUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 01:20:51 -0400
Date: Tue, 9 Oct 2007 07:18:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@infradead.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: gigabit ethernet power consumption
Message-ID: <20071009051856.GT10199@1wt.eu>
References: <20071008220720.GF3484@elf.ucw.cz> <470AAFD7.9060002@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470AAFD7.9060002@intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Auke,

On Mon, Oct 08, 2007 at 03:31:51PM -0700, Kok, Auke wrote:
> Pavel Machek wrote:
> > Hi!
> > 
> > I've found that gbit vs. 100mbit power consumption difference is about
> > 1W -- pretty significant. (Maybe powertop should include it in the
> > tips section? :).
> > 
> > Energy Star people insist that machines should switch down to 100mbit
> > when network is idle, and I guess that makes a lot of sense -- you
> > save 1W locally and 1W on the router.
> > 
> > Question is, how to implement it correctly? Daemon that would watch
> > data rates and switch speeds using mii-tool would be simple, but is
> > that enough?
> 
> you most certainly want to do this in userspace I think.
> 
> One of the biggest problems is that link negotiation can take a significant amount
> of time, well over several seconds (1 to 3 seconds typical) with gigabit, and
> having your ethernet connection go offline for 3 seconds may not be the desired
> effect for when you want to get more bandwidth in the first place.
> 
> However, when a laptop is in battery mode, switching down from gigabit to 100mbit
> makes a lot more sense, so this is something I would recommend. This can be as
> easy as changing the advertisement mask of the interface and renegotiating the
> link. Userspace could handle that very easily.

If something does that, it must *only* be in userspace so that we can
easily disable it. It's amazing how many laptops consider that you
don't want any performance when you run off batteries. I've seen a
2GHz laptop falling back to 600 MHz when running on batteries, which
was very inconvenient when the laptop in question was used to go
sniffing gigabit traffic in datacenters... I would even go as far
as to say that my notebook runs lowpower only when it's plugged into
the wall because it's when I'm typing or doing low activity things.

In my opinion, battery != low power, battery == mobility. It's user's
choice which must imply low power, so that must be done with a dedicated
daemon.

Regards,
Willy

