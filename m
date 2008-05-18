Return-Path: <linux-kernel-owner+w=401wt.eu-S1758722AbYERQJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722AbYERQJc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 12:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbYERQJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 12:09:24 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:58319 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbYERQJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 12:09:23 -0400
Date: Mon, 19 May 2008 01:10:34 +0900 (JST)
Message-Id: <20080519.011034.25909336.anemo@mba.ocn.ne.jp>
To: macro@linux-mips.org
Cc: a.zummo@towertech.it, hvr@gnu.org, akpm@linux-foundation.org,
       rtc-linux@googlegroups.com, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RTC: M41T80: Century Bit support
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <Pine.LNX.4.55.0805171959030.10067@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805170057370.4049@cliff.in.clinika.pl>
	<20080518.000242.41199304.anemo@mba.ocn.ne.jp>
	<Pine.LNX.4.55.0805171959030.10067@cliff.in.clinika.pl>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2008 20:16:20 +0100 (BST), "Maciej W. Rozycki" <macro@linux-mips.org> wrote:
> > How about doing like this?
> > 
> > 1. If CEB was 0, keep current behavior. (does not touch CB bit)
> > 
> > 2. If CEB was 1, detect polarity of CB bit on get_datetime, and set or
> >    clear CB bit on set_datetime based on the polarity.
> 
>  That's what I did initially as it is as obvious as you can get.  But as I
> noted, CFE, the firmware used with the SWARM, does not set CEB even though
> it takes CB into account.  The approach is not useful therefore at least
> for one major user of the device.

Oh I had missed that the firmware does not set CEB.  Hmm...

>  Of course CFE is BSD-licensed and can be changed too, but based on my
> experience with how serious bugs are handled, I would not count on getting
> such a minor change integrated into the official sources.
> 
> > Please look at "c_polarity" variable in rtc-pcf8563.c driver.
> 
>  Hmm, not terribly useful as few of us if anybody live back in the 20th
> century. ;-)  I think let's scrap the patch in this case and let our
> grandchildren solve the problem -- a proposal has been published and can
> be reused as needed.

OK for me.  Lets hear how our grandchildren complain on this fault. :)

---
Atsushi Nemoto
