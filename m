Return-Path: <linux-kernel-owner+w=401wt.eu-S1763498AbYEGQvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763498AbYEGQvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 12:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762329AbYEGQvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 12:51:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:21933 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762065AbYEGQu6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 12:50:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H53qPuks4VusqC1Ow9cm5KNBhLLhXp87zj7UfXpFzvmn/bSUE1Xq3tOBOUHi5cUwBE2egnZdloRRQ1kynyl+ymd1PmD4kxHA1l6IMp8V9BYly2id58bo9DQblD3xnIqVDPtqU1FrNSIO52Ec7QatOePSkdz374j93g0FvKaV42w=
Message-ID: <c878e2290805070950o260fbb77m27407a483af9dbc9@mail.gmail.com>
Date: Wed, 7 May 2008 18:50:54 +0200
From: "Kim Hansen" <kimhanse@gmail.com>
To: "Alex Dubov" <oakad@yahoo.com>
Subject: Re: tifm_7xx1: SD card is ignored
Cc: linux-kernel@vger.kernel.org, drzeus@drzeus.cx
In-Reply-To: <202777.76958.qm@web36706.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <c878e2290805061056k4b97513boa924eae90d649391@mail.gmail.com>
	 <202777.76958.qm@web36706.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 3:21 PM, Alex Dubov <oakad@yahoo.com> wrote:
>> Unfortunately my machine crashes every hour or so when I run 2.6.25,
>> both with the home build kernel and with the Debian kernel, this makes
>> it impossible for me to do any real testing. The SD card works on the
>> home build kernel, but not on the Debian kernel, I will wait for
>> 2.6.25 to become stable for me and then find the difference between
>> the two build that prevents the SD card from working on one of them.

Now it just looks like it sometimes work and other times don't, on
some kernels it works on 80% inserts and on other it only works on 5%.
This means that the problem most likely has not been fixed between
2.6.24 and 2.6.25, it was just a coincidence that it worked on on and
not the other the first few times I tested it.

>> I have also tried to compile 2.6.24 for myself now in order to see if
>> the SD would work there, it didn't, but I got a reaction in the dmesg
>> now:
>>   mmc0: card claims to support voltages below the defined range. These
>> will be ignored.
>>   mmc0: SDIO card claims to support the incompletely defined 'low
>> voltage range'. This will be ignored.
>>   mmc0: error -110 whilst initialising SDIO card
>>
>> This might explain what the problem is?
>>
>> Anyway, thanks for your time, I will just wait a little longer as it
>> almost works now,
>
>
> First, where's debug log? There are plenty of debug messages in the MMC code -
> just enable the debug printout and send it to me or Pierre.
>
> Second, I'm not sure the problem is tifm specific, otherwise where's SDIO stuff
> comes from?

I think you are right, it looks like this computer uses the sdhci interface.

I have captured some logs now, there is logs of a successful insert
and remove, and of an unsuccessful.

Successful  insert: 16:18:50   remove:  16:20:26
Unsuccessful insert:  16:21:38  remove:  16:21:47

The log can be found at: http://i9.dk/~kim/mmc-log.txt.bz2

This is the part from the unsuccessful insert:
sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000040
mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
mmc0: clock 187500Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
mmc0: clock 187500Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
mmc0: starting CMD0 arg 00000000 flags 000000c0
sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000001
mmc0: req done (CMD0): 0: 00000000 00000000 00000000 00000000
mmc0: clock 187500Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
mmc0: starting CMD8 arg 000001aa flags 000002f5
sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
mmc0: req done (CMD8): -110: 00000000 00000000 00000000 00000000
mmc0: starting CMD5 arg 00000000 flags 000002e1
sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
mmc0: req failed (CMD5): -110, retrying...
sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
mmc0: req failed (CMD5): -110, retrying...
sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
mmc0: req failed (CMD5): -110, retrying...
sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00000001
mmc0: req done (CMD5): 0: ffffffff 00000000 00000000 00000000
mmc0: card claims to support voltages below the defined range. These
will be ignored.
mmc0: SDIO card claims to support the incompletely defined 'low
voltage range'. This will be ignored.
mmc0: clock 187500Hz busmode 1 powermode 2 cs 0 Vdd 20 width 0 timing 0
mmc0: starting CMD5 arg 00300000 flags 000002e1
sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
mmc0: req failed (CMD5): -110, retrying...
sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
mmc0: req failed (CMD5): -110, retrying...
sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
mmc0: req failed (CMD5): -110, retrying...
sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 0x00018000
mmc0: req done (CMD5): -110: 00000000 00000000 00000000 00000000
mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
mmc0: error -110 whilst initialising SDIO card
mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0

-- 
Kim Hansen
Vadgårdsvej 3, 2.tv
2860 Søborg
Fastnet: 3956 2437 -- Mobil: 3091 2437
