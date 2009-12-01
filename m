Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbZLAU1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbZLAU1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 15:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbZLAU1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 15:27:21 -0500
Received: from mail-ew0-f215.google.com ([209.85.219.215]:58485 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbZLAU1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 15:27:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=NQk4qisUsYNLt3AM1Gk8YZaZRnCu+WNfEhPJme4T8feoWcePFnoTBXRnmiQFXEHKwQ
         e422hP415VkDzA5nWcWhc3BFJ5X/XolSoMVlMZyJp69+HD6kiGcvY2zOQg1JPMarrU0o
         QNur1kjEtsYH0QHSB+K6aoUpSi8Da+8agXFGA=
Message-ID: <4B157C29.6090805@tuffmail.co.uk>
Date: Tue, 01 Dec 2009 20:27:21 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: pm list <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: Bisected: s2disk (uswsusp only) hangs just before poweroff
References: <4B1575AC.6080904@tuffmail.co.uk> <4B157B81.9050703@gmail.com>
In-Reply-To: <4B157B81.9050703@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock wrote:
> On 12/01/09 11:59, Alan Jenkins wrote:
>> Hi
>>
>> Suspend to disk is (sometimes) hanging for me in 2.6.32-rc. I finally
>> got around to bisecting it, which blamed the following commit by Mel:
>>
>> 5f8dcc2 "page-allocator: split per-cpu list into 
>> one-list-per-migrate-type"
>>
>> I was able to confirm this by reverting the commit, which fixed the
>> hang. I had to revert one other commit first to avoid a conflict:
>>
>> a6f9edd "page-allocator: maintain rolling count of pages to free from
>> the PCP"
>>
>> -- detail --
>>
>> When I suspend my EeePc 701 to disk, it sometimes hangs after writing
>> out the hibernation image. The system is still able to resume from this
>> image (after working around the hang by pressing the power button).
>> This is specific to s2disk from the uswsusp package (which is now
>> installed by default on debian unstable). It doesn't happen if I
>> uninstall uswsusp and use the in-kernel suspend instead.
>>
>> The hang doesn't happen if I boot with "init=/bin/bash" and run s2disk.
>> Nor does it happen if I boot normally, then switch to single user mode
>> ("telinit 12").
>>
>> It only happens if I've logged in to KDE. In the past, this has
>> indicated a problem in a network driver, since NetworkManager only made
>> a connection once I logged in. But it still hangs if I remove both ath5k
>> and atl2 before I log into KDE. (I actually tried removing as many
>> modules as possible: atl2, ath5k, usbcore, snd-hda-intel, psmouse,
>> pcspkr, battery, ac, themal, fan, and eeepc-laptop). Perhaps it's
>> something to do with the size of the hibernation image.
>>
>> -- confidence in the bisection result --
>>
>> The randomness was a bit annoying, but it's not too bad. The hang would
>> normally show up in the first 3 hibernation cycles; I don't remember
>> having to wait more than 6.
>>
>> I wrote a script to do s2disk + rtcwake so I could leave it testing
>> without constantly hitting the power button. This let me test 2.6.32-rc8
>> with the reverts for at least 20 hibernation cycles.
>>
>> Regards
>> Alan
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at http://www.tux.org/lkml/
>>
>
> hmm.. maybe this is what I'm seeing over here
> i.g. on my macbook(ati gpu) the first s2ram will
> lagg for about 30/40 secs before waking up
> then every other cycle afterwards reacts as it should.
> Threw in kernels 2.6.30,31 before doing anything
> but showed the same results, leading me to beleive maybe
> I have some userspace issue(libx86)going on.
>
> I'll try reverting that commit to see.
>
> Thanks
>
> Justin P. Mattock

I don't expect so.  My problem doesn't affect s2ram.  And as far as I 
can tell, my hang is forever... it's more than just 40 seconds.

Regards
Alan
