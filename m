Return-Path: <linux-kernel-owner+w=401wt.eu-S1751961AbZCPEfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbZCPEfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 00:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbZCPEfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 00:35:08 -0400
Received: from kroah.org ([198.145.64.141]:59945 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750818AbZCPEfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 00:35:07 -0400
Date: Sun, 15 Mar 2009 21:33:59 -0700
From: Greg KH <greg@kroah.com>
To: Rory Filer <rfiler@SierraWireless.com>
Cc: Ralf Nyren <ralf@nyren.net>, Stephen Clark <sclark46@earthlink.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kevin Lloyd <klloyd@SierraWireless.com>
Subject: Re: Sierra Wireless (MC8780) HSDPA speed issue
Message-ID: <20090316043359.GA24632@kroah.com>
References: <alpine.DEB.1.10.0903131551310.5791@fujje.iml.umu.se> <20090314040322.GB3417@kroah.com> <alpine.DEB.1.10.0903142021580.5797@fujje.iml.umu.se> <20090314203256.GA7487@kroah.com> <49BC5A90.7070004@earthlink.net> <alpine.DEB.1.10.0903152040030.5825@fujje.iml.umu.se> <8F90F944E50427428C60E12A34A309D21C401BAA8D@carmd-exchmb01.sierrawireless.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8F90F944E50427428C60E12A34A309D21C401BAA8D@carmd-exchmb01.sierrawireless.local>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 15, 2009 at 03:30:54PM -0700, Rory Filer wrote:
> Hi Ralf
> 
> Using the driver we sent you on a call-box (i.e. with a "perfect"
> simulated network connection) on Ubuntu 8.04 we were seeing ~4 Mbps on
> the downlink. So I would rule out any problem with the driver and
> conclude it must be something in either PPP/Linux or in the modem. In
> order to rule out the modem, I've got a question into one of our UMTS
> engineers and will send you a reply when we get the answer. 
> 
> We did play around a little with 2.4 kernels of Linux and discovered
> there is a buffer in PPP_ASYNC.C which, when its size is increased,
> doubled the throughput. If you are savvy enough with Linux, you might
> want to try playing with that. We stopped short of any thorough
> testing of changing this array size, but were pleased with the result.
> If I recall properly, the size of this array is (was, in 2.4) 256
> bytes. Doubling it gave an immediate improvement. We were guessing
> that the small size of this buffer was fine in the "old days" when
> modems peaked at ~56 kbps. Even 8 years ago that was the fastest you
> could go with a GPRS product, now our new HSPA+ products yields 21
> Mbps on Telstra's network! Quite a difference.

Ah, the OBUFSIZE #define in drivers/net/ppp_async.c?

Anyone care to bump this size up and see if that helps out?

thanks,

greg k-h
