Return-Path: <linux-kernel-owner+w=401wt.eu-S1755106AbYEWJc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbYEWJc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 05:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbYEWJcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 05:32:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:42239 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbYEWJci convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 05:32:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YYgkwavUQjs+KgAnEaRGGzEaVlj9toIp8WpBEuKZcgPofJeCFJ+vZjV3wM47WNu0JAlbXbednO63LuXqvSyyrPF+ywSH9rhtEERXxyezDyL7JkzMNyhx1HDplkwLDYFogYqp0zBrhVvapWNEY7IGHsofeRrssiL/Vkf8uiixSu8=
Message-ID: <c878e2290805230232n441351bl3a1038dfacffb4d8@mail.gmail.com>
Date: Fri, 23 May 2008 11:32:32 +0200
From: "Kim Hansen" <kimhanse@gmail.com>
To: "Pierre Ossman" <drzeus@drzeus.cx>
Subject: Re: tifm_7xx1: SD card is ignored
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080521142124.3e43eea4@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <c878e2290805061056k4b97513boa924eae90d649391@mail.gmail.com>
	 <202777.76958.qm@web36706.mail.mud.yahoo.com>
	 <c878e2290805070950o260fbb77m27407a483af9dbc9@mail.gmail.com>
	 <20080521142124.3e43eea4@mjolnir.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 2:21 PM, Pierre Ossman <drzeus@drzeus.cx> wrote:
> On Wed, 7 May 2008 18:50:54 +0200
> "Kim Hansen" <kimhanse@gmail.com> wrote:
>
>> Now it just looks like it sometimes work and other times don't, on
>> some kernels it works on 80% inserts and on other it only works on 5%.
>> This means that the problem most likely has not been fixed between
>> 2.6.24 and 2.6.25, it was just a coincidence that it worked on on and
>> not the other the first few times I tested it.
>
> I missed the start of this, but I assume it is just the one card that
> exhibits this craziness?

I can reproduce it on 3 different cards: SD 512MB, SD 4GB, MMC 64kB.

>> I have captured some logs now, there is logs of a successful insert
>> and remove, and of an unsuccessful.
>>
>> Successful  insert: 16:18:50   remove:  16:20:26
>> Unsuccessful insert:  16:21:38  remove:  16:21:47
>>
>> The log can be found at: http://i9.dk/~kim/mmc-log.txt.bz2
>>
>> This is the part from the unsuccessful insert:
>
> *snip*
>
>> sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000001
>> mmc0: req done (CMD5): 0: ffffffff 00000000 00000000 00000000
>
> What can I say, the card thinks it's an SDIO card. :)
>
> The question is why. Might be some shoddy wiring between the card and
> the controller that causes some unlucky misinterpretations. Might also
> be that the card needs some increased delay to function correctly. Try
> adding:
>
>        msleep(500);
>
> to mmc_rescan() in drivers/mmc/core/core.c. Put it right after
> mmc_power_up().

I will try that.

-- 
Kim Hansen
Vadgårdsvej 3, 2.tv
2860 Søborg
Fastnet: 3956 2437 -- Mobil: 3091 2437
