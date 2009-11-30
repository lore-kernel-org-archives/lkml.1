Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbZK3Ghd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbZK3Ghd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 01:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbZK3Ghc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 01:37:32 -0500
Received: from mail-ew0-f215.google.com ([209.85.219.215]:47876 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbZK3Ghb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 01:37:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:openpgp:content-type
         :content-transfer-encoding;
        b=RxuAvt6Lk9xDUEKj0oIW+bdYd/Cp23Hn29lxg/DvwcTwSIdwN0Rq6XQoB9HXAd64xx
         1gpuJ4ouefB7ZkUPEPddG6FkSUxwGRS19QG7gwu+UupanXJhiYjkGs9gAZwt1R7l/zcv
         tBh+lnd9fsPuNlWfNCWyw49FXItOwvhmGDNu0=
Message-ID: <4B13682D.4030202@gmail.com>
Date: Mon, 30 Nov 2009 11:37:33 +0500
From: "Andrey A. Porodko" <andrey.porodko@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "A. Porodko" <panda@chelcom.ru>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Balaji Rao <balajirrao@openmoko.org>,
       Linus Walleij <linus.walleij@stericsson.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Patch for MSP430 support on Neuros OSD2 board
References: <4B0E7E07.4080404@chelcom.ru> <4B0E7FE2.7060204@gmail.com> <20091129234605.GA4292@sortiz.org>
In-Reply-To: <20091129234605.GA4292@sortiz.org>
X-Enigmail-Version: 0.96.0
OpenPGP: id=9E6A5CCE
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Ortiz wrote:

Hi Samuel,

The reason I used "ifdef" instead of refactoring code is that I don't
have dm355 board to check nor I'm familiar with this hardware and I was
afraid to screw up what's already done for dm355.
Initially I created a completely separate driver (although based on
dm355) for Neuros, but kernel people told me to combine code with existent.
- Is it possible to find someone with dm355 hardware to check if didn't
screw up it?
- I don't quite understand how to evaluate impact on config_* files, do
you mean I need to check standard kernel configuration files bundled
with kernel and make necessary adjustments there?

Thank you for a quick reply.
> Hi Andrey,
>
> On Thu, Nov 26, 2009 at 06:17:22PM +0500, Andrey A. Porodko wrote:
>   
>> Hello,
>>
>> Here is a patch for MSP430 chip support for Neuros OSD2 (Davinci DM6446
>> based) board.
>> Patch made against 2.6.32-rc6 kernel.
>>     
> Thanks for the patch, here are some comments about it:
>
> - Renaming a file may be acceptable, but you have to delete the prvious one.
> Also, as you're changing the Kconfig symbol, you should evaluate the impact on
> the current users (in config_* files for example).
>
> - Then about the code itself: ifdefs as the one you're doing here is not
> exactly nice, and leads to a lot of code replication and maintenance burden.
> It seems that you're trying to have a common MSP430 driver support for 2
> different boards, which is a good idea. The main problem, if I understand it
> correctly, is those 2 boards are running the same MSP430 HW running different
> FWs.
> What I'd really like to see here would be to have a generic MSP430 support.
> You'd need to define a FW definition structure (it seems it would mostly be
> GPIO settings), then have different static definitions for every known firmware
> revision, and finally have a common probe routine that would go through this
> firmware structure and sets thing accordingly. You would pass the firmware
> revision you're using from your board definitions, unless there are some
> registers on that chip that would let us know about this firmware.
>
> Cheers,
> Samuel.
>
>
>   


-- 
Best regards
Andrey A. Porodko
 

