Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbYIPVHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbYIPVHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 17:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbYIPVHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 17:07:11 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:41254 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671AbYIPVHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 17:07:10 -0400
Message-ID: <48D01FFB.1010302@lwfinger.net>
Date: Tue, 16 Sep 2008 16:07:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
       Adel Gadllah <adel.gadllah@gmail.com>,
       wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Michael Buesch <mb@bu3sch.de>,
       bcm43xx-dev@lists.berlios.de, John Linville <linville@tuxdriver.com>
Subject: Re: Regression in 2.6.27-rcX caused by commit      bc19d6e0b74ef03a3baf035412c95192b54dfc6f
References: <48CFC03A.8020708@lwfinger.net> <200809161742.15527.mb@bu3sch.de>    <48CFE820.7010305@lwfinger.net>    <20080916195134.GB14879@srcf.ucam.org> <39295.87.81.255.5.1221597846.squirrel@phoenix.slamd64.com>
In-Reply-To: <39295.87.81.255.5.1221597846.squirrel@phoenix.slamd64.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carlos Corbacho wrote:
>> diff --git a/drivers/net/wireless/b43/rfkill.c
>> b/drivers/net/wireless/b43/rfkill.c
>> index fec5645..e8b2acb 100644
>> --- a/drivers/net/wireless/b43/rfkill.c
>> +++ b/drivers/net/wireless/b43/rfkill.c
>> @@ -49,21 +49,18 @@ static void b43_rfkill_update_state(struct b43_wldev
>> *dev)
>>  	struct b43_rfkill *rfk = &(dev->wl->rfkill);
>>
>>  	if (!dev->radio_hw_enable) {
>> -		rfk->rfkill->state = RFKILL_STATE_HARD_BLOCKED;
>> +		rfkill_force_state(rfk->rfkill, RFKILL_STATE_HARD_BLOCKED);
>>  		return;
>>  	}
>>
>>  	if (!dev->phy.radio_on)
>> -		rfk->rfkill->state = RFKILL_STATE_SOFT_BLOCKED;
>> +		rfkill_force_state(rfk->rfkill, RFKILL_STATE_SOFT_BLOCKED);
>>  	else
>> -		rfk->rfkill->state = RFKILL_STATE_UNBLOCKED;
>> -
>> +		rfkill_force_state(rfk->rfkill, RFKILL_STATE_UNBLOCKED);
>>  }
> 
> Just this should be enough to fix the regression for 2.6.27 (and should be
> trivial to port to b43legacy) in the immediate term (I was planning to
> send something similar).
> 
> The rest of the patch is out-of-scope for 2.6.27, but is definitely along
> he right lines, IMHO (and it would be good if we can get a working version
> of it in to 2.6.28). I may try and look at it later, as I do have my b43
> hardware handy.

This one doesn't crash, but it doesn't turn the light off.

I'm done testing for now!

John,

Revert the patch until the rfkill guys get their house in order.

Larry


