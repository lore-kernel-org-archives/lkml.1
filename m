Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbYKCSO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbYKCSO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 13:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbYKCSOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 13:14:48 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:38667 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbYKCSOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 13:14:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=F0QO0E9//TfFU2H71Ls3ahQMd2F4PJch/zS4835G9u0knz7P0KqGo67yH/0FmCYCyB
         V3vDf/X9BKWGpwwVVETvZ+0sGx5i+0vZl9KM5LgUkGAD0KThgUqZWKql4bTT9878Ncig
         27f5wnrDHD4ztm4POoDxUjw+/O1NirNNQ6ZCs=
Message-ID: <bc64b4640811031014x7ceec076r44260fef2a4a9b6f@mail.gmail.com>
Date: Mon, 3 Nov 2008 21:14:46 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH] power_supply: only register tosa_battery driver on tosa
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Mark Brown" <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20081103173237.GA13733@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225271050-21171-1-git-send-email-dbaryshkov@gmail.com>
	 <bc64b4640811021236t3458bf69vd1becc4ab1133be1@mail.gmail.com>
	 <20081103145514.GA23466@oksana.dev.rtsoft.ru>
	 <bc64b4640811030820j660b8386x39bf2285b1dba887@mail.gmail.com>
	 <20081103162547.GA25546@oksana.dev.rtsoft.ru>
	 <bc64b4640811030841h5bcc537fy4b645c6d293b7b46@mail.gmail.com>
	 <20081103165820.GA8004@oksana.dev.rtsoft.ru>
	 <bc64b4640811030909s5bbb05dao9f83523aac9dd8ef@mail.gmail.com>
	 <20081103173237.GA13733@oksana.dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/3 Anton Vorontsov <avorontsov@ru.mvista.com>:
> On Mon, Nov 03, 2008 at 08:09:14PM +0300, Dmitry wrote:
> [...]
>> >> Yup.
>> >> I see few ways to resolve this:
>> >> * write better wm97xx interface. Dunno if that is feasible or possible.
>> >>   One of the possible solutions is to pass battery and ts device names
>> >>   and data from within board data via ac97 layer to wm97xx-core. This
>> >>   will provide several benefits (e.g. then we can drop lots of parameters
>> >>   from wm97xx-core, which are really board parameters).
>> >
>> > That would be great indeed. But for now, just don't compile the two
>> > drivers on the tosa platform. No need for machine_is_*() hacks...
>>
>> That is a bit strange requirement. During several past months there was
>> a lot of efforts put into supporting multi-machine PXA kernel images.
>
> Yes, I know this.
>
> But you're implementing hacks instead of fixing the problem.
>
> Btw, you inserted the machine_is() into the tosa driver, but
> wm97xx driver registers unconditionally. That could be a problem
> when wm97xx loads first, and then you try to load the tosa_battery
> module on tosa machine.
>
> Let's insert machine_is() hack into the wm97xx driver as well?

That's why I suggested moving driver registration into _set_pdata()
function in that driver.

>
> --
> Anton Vorontsov
> email: cbouatmailru@gmail.com
> irc://irc.freenode.net/bd2
>



-- 
With best wishes
Dmitry
