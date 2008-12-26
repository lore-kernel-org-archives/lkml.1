Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbYLZTO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbYLZTO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 14:14:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYLZTOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 14:14:19 -0500
Received: from usul.saidi.cx ([204.11.33.34]:41875 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751333AbYLZTOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 14:14:18 -0500
Message-ID: <49552CF5.60705@overt.org>
Date: Fri, 26 Dec 2008 11:13:57 -0800
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       lkml <linux-kernel@vger.kernel.org>, Ben Dooks <ben-linux@fluff.org>
Subject: Re: MMC: Add 8-bit bus width support
References: <200812260947.21672.david-b@pacbell.net>
In-Reply-To: <200812260947.21672.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
>> I am not aware of mmc cards having 8 pins yet.
> 
> Transcend seems to have one that's reasonably available;
> NewEgg has the 4GB card for $US 9.50, and Transcend sells
> it direct too (at least in the US).  I'm a bit curious
> what read rates they achieve ... likely not 50 MB/sec!
> 
> The relevant search keyword seems to be "MMCplus".

Right. MMCplus and MMCmobile cards are all required to have
8 bit support, and they've been around for years. The catch
is that there have been essentially no controllers out in
the wild which can take advantage of them. Even when the
controller chip supports 8 bit operation, the ODM usually
only connects 4 pins up - and when they actually do, it's
for a controller which we don't know how to control :-)

This OMAP controller is a first.

> A third use for 8-bit bus widths is the CE-ATA.org stuff
> (ATA over MMC) ... I'm not sure how real that is, but the
> Seagate website has two "Lyrion" products of 30MB and 60MB
> using 8-bit MMC for small disks.  I had thought bigger
> drives had been announced (e.g. from Samsung, 200+ MB);
> maybe they're visible only through OEM channels.

True - except that CE-ATA wants to signal ATA command completion
on the CMD line which I'm fairly certain requires explicit
hardware level support. In the absence of that, you'd have to
poll.

--phil
