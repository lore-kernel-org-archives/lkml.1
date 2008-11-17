Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbYKQSze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbYKQSze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYKQSz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:55:26 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:40249 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbYKQSzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:55:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VpfTh9QVmOLpukyl+QDzJdwIV+v2UhnveD5yVnQaj3b3NvvapapCWBIaxtB/GYtL66
         tWpfdIATEsoI5lFpKxI7Mk7pU8hS+BSfNi3oU9/JWXPjsFg7fvJiWQAAaYUb4yYq7pmR
         HrSpIWxehH0QhX3aDLlJlSl/R0Hjy6p/gNEZo=
Message-ID: <4921BE16.4070408@gmail.com>
Date: Mon, 17 Nov 2008 20:55:18 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Nick Kossifidis <mickflemm@gmail.com>, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org
Subject: Re: [ath5k-devel] Bugs on aspire one A150
References: <491506DB.1070000@gmail.com> <b6c5339f0811100851t1fd9a180pfe24312081885467@mail.gmail.com> <4918A8C5.3050607@gmail.com> <40f31dec0811101412n1a4faf86sf4b1f37bb41caef9@mail.gmail.com> <491B17B3.204@gmail.com> <20081114034730.GA9482@hash.localnet> <491DCA12.3000304@gmail.com> <20081117171433.M54175@bobcopeland.com>
In-Reply-To: <20081117171433.M54175@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Copeland wrote:
> On Fri, 14 Nov 2008 20:57:22 +0200, Maxim Levitsky wrote
>> Bob Copeland wrote:
>>> On Wed, Nov 12, 2008 at 07:51:47PM +0200, Maxim Levitsky wrote:
>>>>>> Why it doesn't accept new mac?, can this be fixed?
>>>> Any update on mac changer status?
>>> As a first stab, can you try this patch?  This sets the address on
>> Works almost perfectly,
>>
>> when I load the module, then run macchanger, and then ifconfig wlan0 up
>> then it works, if I do an ifconfig up once, then ifdowning the interface, it
>> doesn't.
> 
> Yeah, I had actually written more for that patch originally, but didn't 
> post it because it was a bit more invasive.  I think the issue is just that 
> start() shouldn't program the mac at all and let add_interface handle that.
> I'll post a revised patch in a day or two.

> 
>> The noise floor calibration issue bites me again and gain.
>> When it shows up, usually card continues to work, but at next assotiation
>> stops working.
> 
> Does this help?
> http://marc.info/?l=linux-wireless&m=122570806813839&w=2
I'll test this, I guess that it should indeed help.

> 
>> Transfer speeds are unusually low:
> 
> You can try using the minstrel rate control algorithm, it may help.
> s
This actually seems to be iwl3945 bug.

This is the tests I did:


1 . Upload / download from my desktop computer (connected via wired interface)
Speeds are rock solid 1.3 Mbytes/s in both directions

2. Then I tried to upload to my laptop (iwl3945)
Speeds were around 600 Kbytes/s, then after few minutes the ath5k dropped association, associated
again and transfer speed dropped below 64 Kbyte/s
(They didn't stall thought)

3. Then I reloaded the ath5k, it didn't help, 64 Kbyte/s again.

4. Then I tried to transfer files to desktop, 1.3 Mbytes/s again.

5. then tried the laptop, 64 Kbyte/s again

6. Then I reloaded the iwl3945 on laptop, and got 600 Kbytes/s.

It still isn't very clear who is responsible, but this is very fishy.
Maybe the ath5k shouldn't drop association, though.

600 Kbytes/s isn't good ether.


Also ath5k stopped working at all, when I did long test transfer between desktop and laptop, dmesg was full
of some strange message repeated, I haven't been able to reproduce that again, when I do, I will post that message.


In general, ath5k works nice here, big thanks to you for such great work.


Best regards,
	Maxim Levitsky
