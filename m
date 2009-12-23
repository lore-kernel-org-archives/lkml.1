Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbZLWKI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbZLWKI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 05:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754978AbZLWKIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 05:08:55 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:12312 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbZLWKIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 05:08:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=mOTypWhutH6JSG5vOfwVqyJNs3dS4/d+jV2gvxs6VbYE7c0Nhpaj1gSL8XPzgIh8bN
         KOhAFs90G1hb1lCNfc90LI0aH3JXkilK7mPtFzK0YSHhVMRac4MvoSL/YEsDCLWUpPB8
         bsOQ7L7UOXw8981x5d05hp4bX45dWyzFB6i7I=
MIME-Version: 1.0
In-Reply-To: <20091223050810.GA25791@linux-sh.org>
References: <1261540762.3508.61.camel@localhost.localdomain>
	 <20091223050810.GA25791@linux-sh.org>
Date: Wed, 23 Dec 2009 11:08:51 +0100
X-Google-Sender-Auth: d36bcc51e6414ec7
Message-ID: <10f740e80912230208g6237c530k8c70d9375efbd463@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/14] Convert remaining arches to 
	read/update_persistent_clock
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org,
       linux-sh@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Mike Frysinger <vapier@gentoo.org>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Tony Luck <tony.luck@intel.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       Kyle McMartin <kyle@mcmartin.ca>,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 06:08, Paul Mundt <lethal@linux-sh.org> wrote:
> On Tue, Dec 22, 2009 at 07:59:22PM -0800, john stultz wrote:
>> In this case the generic read_persistent_clock() and
>> update_persistent_clock() methods have been provided to allow the
>> generic timekeeping code to initialize xtime and set the persistent
>> clock when NTP is synced. However many arches haven't converted, so the
>> generic code has to handle the case where the arch is doing this
>> management itself.
>>
>> This patch series tries to convert the following 14 architectures over
>> to use read_persistent_clock() and update_persistent_clock() as
>> applicable, killing off about 200 lines of arch specific code.
>>
> While I think that this is a good goal, many of the underlying
> architectures have veered pretty far away from having meaningful
> persistent clock interfaces after having moved entirely to generic
> timekeeping and the RTC subsystem.

Indeed. When moving to the RTC subsystem, you loose the persistent
clock at boot;
i.e. on m68k, mach_hwclk() can no longer be set, as the RTC driver is
in a separate
(possible loadable) module.

> In the case of SH at least that interface along with the generic CMOS
> stuff is largely a stop-gap for antiquated platforms that don't have
> proper RTC drivers and likely never will, while the default for all of
> the rest of the platforms effectively returns a fixed dummy value. I
> copied this approach from MIPS originally, so there are at least a few
> architectures that this will apply to.
>
> In any event, I wonder if it might make more sense to take something like
> the SPARC implementation that is simply a wrapper around the RTC, move
> that out in to a more generic place, and permit architectures to select
> an RTC class backed persistent clock instead (it seems to be only
> platforms that haven't caught up yet in terms of generic time and RTC
> migration that would want to define this interface on their own at all at
> this point)?

Hmm, haven't looked into how SPARC handles this yet...
Yes, looks like a good idea to me. Any disadvantages with this approach?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
