Return-Path: <linux-kernel-owner+w=401wt.eu-S1751712AbZLWFI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbZLWFI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 00:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbZLWFI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 00:08:27 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:54639 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZLWFI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 00:08:26 -0500
Date: Wed, 23 Dec 2009 14:08:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Richard Henderson <rth@twiddle.net>,
       linux-alpha@vger.kernel.org, linux-sh@vger.kernel.org,
       Russell King <linux@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Mike Frysinger <vapier@gentoo.org>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Tony Luck <tony.luck@intel.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       Kyle McMartin <kyle@mcmartin.ca>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC][PATCH 0/14] Convert remaining arches to read/update_persistent_clock
Message-ID: <20091223050810.GA25791@linux-sh.org>
References: <1261540762.3508.61.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261540762.3508.61.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 07:59:22PM -0800, john stultz wrote:
> In this case the generic read_persistent_clock() and
> update_persistent_clock() methods have been provided to allow the
> generic timekeeping code to initialize xtime and set the persistent
> clock when NTP is synced. However many arches haven't converted, so the
> generic code has to handle the case where the arch is doing this
> management itself.
> 
> This patch series tries to convert the following 14 architectures over
> to use read_persistent_clock() and update_persistent_clock() as
> applicable, killing off about 200 lines of arch specific code.
> 
While I think that this is a good goal, many of the underlying
architectures have veered pretty far away from having meaningful
persistent clock interfaces after having moved entirely to generic
timekeeping and the RTC subsystem.

In the case of SH at least that interface along with the generic CMOS
stuff is largely a stop-gap for antiquated platforms that don't have
proper RTC drivers and likely never will, while the default for all of
the rest of the platforms effectively returns a fixed dummy value. I
copied this approach from MIPS originally, so there are at least a few
architectures that this will apply to.

In any event, I wonder if it might make more sense to take something like
the SPARC implementation that is simply a wrapper around the RTC, move
that out in to a more generic place, and permit architectures to select
an RTC class backed persistent clock instead (it seems to be only
platforms that haven't caught up yet in terms of generic time and RTC
migration that would want to define this interface on their own at all at
this point)?
