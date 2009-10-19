Return-Path: <linux-kernel-owner+w=401wt.eu-S1753125AbZJSLpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbZJSLpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 07:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZJSLpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 07:45:19 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:41146 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbZJSLpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 07:45:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C+BRW1kKqAkaWiTBhctvK6UnRTZvEdsta5Mb0qtjB6gGXSUD77HjK+bQPjodNFRePN
         nJoUJdPH64b8hbBzl4vBnY2/E7RItXAnfmTWC3ZTviHuK0kQLaZmPjs+1BaMXAYYeRXN
         bnihrUfrRoW/41C1RNvQ0xE4rPOTdUd0ep3io=
MIME-Version: 1.0
In-Reply-To: <20091018214704.GA26592@kroah.com>
References: <4ADACD3A.9020803@gmail.com>
	 <9b2b86520910180544g94ecc8fuf0d7849e18cd8937@mail.gmail.com>
	 <20091018214704.GA26592@kroah.com>
Date: Mon, 19 Oct 2009 13:45:20 +0200
Message-ID: <2ccd6e3c0910190445va8ff4a8x94dc4044ac01057d@mail.gmail.com>
Subject: Re: Fast LKM symbol resolution with SysV ELH hash table
From: Carmelo Amoroso <carmelo73@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/18 Greg KH <greg@kroah.com>:
> On Sun, Oct 18, 2009 at 01:44:04PM +0100, Alan Jenkins wrote:
>> Hypothetically: imagine we both finish our work and testing on the
>> same machine shows hash tables saving 100% and bsearch saving 90%.  In
>> absolute terms, hash tables might have an advantage of 0.03s on my
>> system (where bsearch saved 0.3s), and a total advantage of 0.015s for
>> the modules you tested (where hash tables saved ~0.15s).
>>
>> Would you accept bsearch in this case?  Or would you feel that the
>> performance of hash tables outweighed the extra memory requirements?
>
> The performance difference in "raw" time speed might be much different
> on embedded platforms with slower processors, so it might be worth the
> tiny complexity to get that much noticed speed.
>

yes, right. Further the figures I reported on the slides were taken
from a development
system with the rootfs mounted via NFS (no HDD or flash), with a debug
kernel and so on.

>> (This leaves the question of why you need to load 0.015s worth of
>> always-needed in-tree kernel code as modules.  For those who haven't
>> read the slides, the  reasoning is that built-in code would take
>> _longer_ to load.  The boot-loader is often slower at IO, and it
>> doesn't allow other initialization to occur in parallel).
>
> Distros are forced to build almost everything as modules.  I've played
> with building some modules into the kernel directly (see the openSUSE
> moblin kernels for examples of that), but when you have to suport a much
> larger range of hardware types and features that some users use and
> others don't, and the ability to override specific drivers by others due
> to manufacturer requests for specific updates, the need to keep things
> as modules is the only way to solve the problem.
>
> So I'm glad to see this speedup happen, very nice work everyone.
>

Just a few other notes. The current implementation I did based on SysV
has a drawback
that is not backward compatible, so you cannot use old modules with a kernel
with the option enabled due to changes on struct kernel_symbol.
Anyway I've just figured out how to change it to remove this limitation.
I need some time to review these patches.
Further, the newer implementation based on GNU hash which we are
working on right now,
will not require the extra .undef.hash ELF sections because hash
values are already embedded
into the GNU hash table, with a reduction in terms of footprint.

> thanks,
>
> greg k-h
>

Thanks to you too,
Carmelo
