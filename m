Return-Path: <linux-kernel-owner+w=401wt.eu-S1756975AbZJBGul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbZJBGul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 02:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbZJBGul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 02:50:41 -0400
Received: from mail-gx0-f212.google.com ([209.85.217.212]:43659 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923AbZJBGuk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 02:50:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=RAZVaDvN/3vgd9CUkf1Z5rNWG4wmPeMMevRZqtGJWdQj7/Tg1AHm/reuHTqbXOVUDC
         dR6p1SKU+yde0sMrBFtvANRt8jlLBZSX0/Yc1xlY9+rwtTmBLqHSOTwDBmbRsF6VOsFL
         I2nQrNFAFf0dd+YFiH6C2HSu0zkKPovnXemTU=
MIME-Version: 1.0
In-Reply-To: <20090928135109.GB17514@mit.edu>
References: <E1MrRDa-0002WF-LO@closure.thunk.org>
	 <200909271813.42829.rjw@sisk.pl> <20090928135109.GB17514@mit.edu>
Date: Fri, 2 Oct 2009 15:50:43 +0900
Message-ID: <aec7e5c30910012350g3908b2ecj4e9ed5f4549c6a4d@mail.gmail.com>
Subject: Re: T400 suspend/resume regression -- bisected to a mystery merge 
	commit
From: Magnus Damm <magnus.damm@gmail.com>
To: Theodore Tso <tytso@mit.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Ondrej Zary <linux@rainbow-software.org>,
       Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 10:51 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Sun, Sep 27, 2009 at 06:13:42PM +0200, Rafael J. Wysocki wrote:
>>
>> commit c7121843685de2bf7f3afd3ae1d6a146010bf1fc
>> Author: Magnus Damm <magnus.damm@gmail.com>
>> Date:   Tue Jul 28 14:09:55 2009 -0700
>>
>>     clocksource: Save mult_orig in clocksource_disable()
>>
>> Please try to revert it and retest.
>
> Using Linus's suggested technique, I bisected it down to this commit:
>
> Author: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Date:   Fri Aug 14 15:47:30 2009 +0200
>
>    timekeeping: Update clocksource with stop_machine
>
>    update_wall_time calls change_clocksource HZ times per second to check
>    if a new clock source is available. In close to 100% of all calls
>    there is no new clock. Replace the tick based check by an update done
>    with stop_machine.
>
>    Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
>    Cc: Ingo Molnar <mingo@elte.hu>
>    Acked-by: John Stultz <johnstul@us.ibm.com>
>    Cc: Daniel Walker <dwalker@fifo99.com>
>    LKML-Reference: <20090814134810.711836357@de.ibm.com>
>    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>
> Unfortunately there are a bunch of patches I'm trying to get in shape
> to push to Linus (the merge window coincided unfortunately with
> LinuxCon/Plumbeer's so I'm a bit behind) so I haven't had a chance to
> take it further.  I'll try reverting each of the above two patches,
> and report back in a day or two.

Just checking, did need to revert
c7121843685de2bf7f3afd3ae1d6a146010bf1fc? I hope not. =)

/ magnus
