Return-Path: <linux-kernel-owner+w=401wt.eu-S1759579AbYFJVbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579AbYFJVbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759437AbYFJVbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:31:24 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:24915 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759423AbYFJVbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:31:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mPIc0a+k37qkgZRnlzE+U5zlyXYQXZjxYK4OH6fNlKX6WMzHvdb+FqM2IF1ht0mmF8dXa5QjwQW0pLQhLGxRkaY76IJrR2f0dNDMUr2KUR1R4R3v8uLnxkxD/qE3ZpCWnLEfeXaBQyxGom73iaueuO/wWty2sAft3CdVBIUIYik=  ;
X-YMail-OSG: ZLmkXmMVM1l.rasd294SmdkYROMwat.paWrgu9WvBMz8fbn.gyU74H7K59_B.Ej6fNYDYSSGPY6RGgy2XP59wUxnWzZFegauws4B_V12w7.aS4UZQc61UkoOE2Dcf4FIVRg-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [patch 2.6.26-rc5] make HPET_RTC_IRQ track HPET_EMULATE_RTC
Date: Tue, 10 Jun 2008 14:31:21 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200806052241.44713.david-b@pacbell.net> <200806061644.23449.maximlevitsky@gmail.com>
In-Reply-To: <200806061644.23449.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806101431.21402.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 June 2008, Maxim Levitsky wrote:

> Remember long ago I had a discussion with you about HPET that
> steals RTC irq in 'legacy replacement' mode, and rtc driver thus
> implements rtc on 'top' of hpet.
> 
> New rtc-cmos driver doesn't do this emulation, thus it isn't compatible
> with hpet driver.

That was fixed in 9d8af78b07976d4d84e0df491abd4e9db848d0ad (February)
by Bernhard Walle <bwalle@suse.de> ... if you look at the bug report
associated with this patch, you'll see that rtc-cmos was working OK
with HPET, it's just the legacy RTC driver which got confused after
the recent updates to clock handling.


> But there is a solution,  I didn't agree with firstly, but then I did, and
> I do agree now, and that to put hpet in normal mode.
> 
> What happened with patches that put hpet in normal independent mode?

The story from either Ingo or Thomas (I forget who) was that this is
another case where we have to cope with BIOS braindamage.  Not enough
BIOS vendors expose the relevant IRQ routing that Linux could default
to using HPET in what I'd call "sane" mode.

Now, that still kind of implies there could be an option to use sane
HPET IRQ configuration (doesn't hijack RTC and other IRQs, and there
could be a per-CPU HPET) on at least the systems where that IRQ routing
is available.  Over time I'd hope that systems like that could become
the common case.  But ... someone else would have to do that work.  :)

- Dave
