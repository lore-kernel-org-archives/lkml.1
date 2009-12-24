Return-Path: <linux-kernel-owner+w=401wt.eu-S1752545AbZLXFKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbZLXFKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 00:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbZLXFKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 00:10:43 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:48739 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbZLXFKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 00:10:39 -0500
Date: Thu, 24 Dec 2009 14:10:21 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Miller <davem@davemloft.net>
Cc: johnstul@us.ibm.com, linux-kernel@vger.kernel.org, rth@twiddle.net,
       linux-alpha@vger.kernel.org, linux-sh@vger.kernel.org,
       linux@arm.linux.org.uk, hskinnemoen@atmel.com, vapier@gentoo.org,
       starvik@axis.com, dhowells@redhat.com, ysato@users.sourceforge.jp,
       tony.luck@intel.com, takata@linux-m32r.org, geert@linux-m68k.org,
       yasutake.koichi@jp.panasonic.com, kyle@mcmartin.ca
Subject: Re: [RFC][PATCH 0/14] Convert remaining arches to read/update_persistent_clock
Message-ID: <20091224051021.GA28878@linux-sh.org>
References: <1261540762.3508.61.camel@localhost.localdomain> <20091223050810.GA25791@linux-sh.org> <20091223.205415.232734959.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091223.205415.232734959.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 08:54:15PM -0800, David Miller wrote:
> From: Paul Mundt <lethal@linux-sh.org>
> Date: Wed, 23 Dec 2009 14:08:10 +0900
> 
> > In any event, I wonder if it might make more sense to take something like
> > the SPARC implementation that is simply a wrapper around the RTC, move
> > that out in to a more generic place, and permit architectures to select
> > an RTC class backed persistent clock instead (it seems to be only
> > platforms that haven't caught up yet in terms of generic time and RTC
> > migration that would want to define this interface on their own at all at
> > this point)?
> 
> This sounds nice but don't we have a slew of RTC types that need
> to be accessed over I2C and thus you can't touch them without
> sleeping?

Yes, and SPI and so on. We do however have plenty of available room for
adding a valid-for-persistent-clock flag to permit drivers to opt-in, so
we can certainly still do better than the status quo. I'll hack something
up and see how it goes.
