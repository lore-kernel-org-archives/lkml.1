Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747AbZGZTPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbZGZTPW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 15:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZGZTPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 15:15:22 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:37746 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbZGZTPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 15:15:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XzlDMqqoCfiMk3HauEA2YiYXoGLZ5IqWb08+KIovdSWQuJAPGRfcvoWUx1RSFk4x7H
         D6HT8nBQUNeqJGjHdLCKuovX4U+R/Dg5N3XVzMqKQCyJt4DspJef0W4iMPcFSUEG1req
         5Hy6daDjXQ2sts7jV87ARnKq2WMIJrTudGooM=
MIME-Version: 1.0
In-Reply-To: <c6b1100b0907210439jf67d886s3125dafa5f4d3928@mail.gmail.com>
References: <c6b1100b0907130127g3d4013c6n3264f79bd74bc9@mail.gmail.com>
	 <c6b1100b0907140404h4fdbe419p8443da43350f3520@mail.gmail.com>
	 <c6b1100b0907210439jf67d886s3125dafa5f4d3928@mail.gmail.com>
Date: Sun, 26 Jul 2009 20:15:19 +0100
Message-ID: <c6b1100b0907261215l71ada148y8a15f6595d939192@mail.gmail.com>
Subject: Re: 2.6.31-rc2: Possible regression in rt61pci driver
From: Chris Clayton <chris2553@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/21 Chris Clayton <chris2553@googlemail.com>:
> 2009/7/14 Chris Clayton <chris2553@googlemail.com>:
> <snip>
>
>> I've updated to 2.6.31-rc3 this morning and done some more testing.
>> I'm now convinced that the rt61pci driver is somehow involved in
>> locking up the laptop. With the (Belkin) rt61 card inserted, the
>> machine will lock up even if I am doing nothing (no web browsing,
>> email or anything else at all) except running this script in a console
>> window:
>>
>> i=0
>> while true; do
>>        let i++
>>        echo -n "$i "
>>        sleep 1
>> done
>>
>> In the tests I have done so far, the counter has never gone beyond 240
>> before the machine locked. With the (no-name) ath5k card inserted I
>> can use the laptop for normal web browsing, email, etc with no
>> problems - the counter in the script above gets to over 2000.
>>
>
> The freeze still happens with 2.6.31-rc3-git5, but I've been doing
> some more fact-finding.
>
> Running the script shown above and with the rt61-based card inserted,
> I can freeze the laptop even if I am doing nothing else on the laptop.
> When the freeze occurs, the laptop is effectively dead, no response to
> mouse movement or keyboard input and no response to pings from
> another machine on my network. However, if I eject the card, the
> laptop comes to life again. The key presses from when the laptop was
> frozen appear on screen and pings from another machine are responded
> to. The script continues to run and display the counter. I then
> reinsert the card and everything appears OK until the laptop freezes
> again a minute or two later. During a test run this morning the
> machine froze at (from the output of the script) 80, 235, 369, 538 and
> 672. Each time, ejecting the card brought the machine back to life.
>
> Trying the same test with the ath5k-based card inserted resulted in
> the script getting to 2300 without the laptop freezing, at which point
> I stopped the script.
>

One more data point. I wondered whether the freeze would "time out" if
I just left the laptop frozen, but my testing shows that it probably
does not (or if it does it takes more than 27 minutes to do so.

I've also tried to bisect again, but, as last time, once I got to the
batch of network-related changes that went into -rc1, I get a series
of kernels that build but either won't boot or have inoperable
wireless networking.

Finally, since I haven't had a single reply to the regression report I
posted almost two weeks ago, I now give up. I'll switch to using the
card supported by the ath5k driver.

<snip>

Chris
-- 
No, Sir; there is nothing which has yet been contrived by man, by
which so much happiness is produced as by a good tavern or inn -
Doctor Samuel Johnson
