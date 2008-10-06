Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbYJGNHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbYJGNHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 09:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbYJGNGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 09:06:47 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36231 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753329AbYJGNGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 09:06:46 -0400
Date: Mon, 6 Oct 2008 17:11:40 +0200
From: Pavel Machek <pavel@suse.cz>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: I need some serious help to debug suspend to ram problem
Message-ID: <20081006151140.GD1380@ucw.cz>
References: <48D4E685.8030801@gmail.com> <200809201810.45057.rjw@sisk.pl> <48D66F9C.4000204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D66F9C.4000204@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>>> I hit a dead end when trying to understand why my notebook can't 
>>> resume from suspend to ram
>>> if this is done two times a row.
>>>
>>> Single suspend/resume cycle works almost perfectly (beep that goes 
>>> through the sound card is muted... no morse code for me... :-(
>>>
>>> )
>>>
>>> I compiled a minimal kernel (absolutely nothing but disk drivers, all experimental option like nohz
>>> turned off)
>>>
>>> But I had to turn SMP, since without it system won't resume first time I suspend it.
>>> (How could this affect suspend?)
>>
>> It could if the system is 64-bit.  In which case please have a look at
>> http://bugzilla.kernel.org/show_bug.cgi?id=11237
>>
>>> With SMP and minimal kernel (of course  no closed drivers), I get same behavior,
>>> first resume works second hangs.
>>>
>>> I then added some debug code to real mode wakeup code, I put there in first
>>> place instructions, that will save some magic value to rtc (to alarm
>>> registers that I know are preserved during boot cycle), and I 
>>> discovered   sad thing that first time bios does pass control to 
>>> linux, but second time
>>> (when it hangs), it doesn't. 
>>>
>>>
>>> I tried to update bios, and I got same results.
>>>
>>> Of course it does work with that @#$%^& OS
>>
>> So we're doing something wrong.  Please try the appended patch.
>>
>>> I then proceeded to test recently posted low memory corruption patch, and
>>> it did show that that @#$%^& BIOS does corrupt low memory I then 
>>> reserved all low memory, but system began to hand after first 
>>> suspend,
>>> in exactly same way, but as expected I soon discovered, that that forces real
>>> mode page to be above 1M, ok, then I reserved almost all low memory except
>>> 100K window in the middle, so low allocations will work, but be placed in
>>> region bios less likely to corrupt, and still that didn't help, still 
>>> same hang.    
>
> More information, I compiled kernels back to 2.6.19, and they all have exactly the same issue.
>

I must say you have done quite a lot of homework...

Ok, it looks like BIOS hangs before it can pass control to kernel. I
have seen it once before, and it was before we were using i8259 and
BIOS expected us to use ioapic (or vice-versa; its *long* time ago).

Good luck...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
