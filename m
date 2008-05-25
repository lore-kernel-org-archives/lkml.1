Return-Path: <linux-kernel-owner+w=401wt.eu-S1758281AbYEYSqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbYEYSqV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756736AbYEYSqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:46:08 -0400
Received: from senator.holtmann.net ([87.106.208.187]:41544 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078AbYEYSqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:46:06 -0400
Cc: Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, aoliva@redhat.com,
       alan@lxorguk.ukuu.org.uk, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>
Message-Id: <BF546351-0C53-41C4-977A-6A777AF4D602@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Michael Buesch <mb@bu3sch.de>
In-Reply-To: <200805252039.17673.mb@bu3sch.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Sun, 25 May 2008 20:46:00 +0200
References: <1211550282.28967.8.camel@pmac.infradead.org> <1211724803.17151.36.camel@johannes.berg> <41FE0259-522B-4B9B-A75D-7B97A9FD723F@holtmann.org> <200805252039.17673.mb@bu3sch.de>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

>>> The fact that userspace uses the key as a filename is maybe
>>> unfortunate,
>>> maybe fortunate, but shouldn't have anything to do with what sort of
>>> keys the kernel allows.
>>
>> I disagree with you. The kernel should be free of these kind of
>> subdirectory stuff. We saw devfs failing and we have a flat device
>> node names in the kernel. Why do we have to duplicate information in
>> the firmware filenames where we have all the information already
>> present in the driver model. The reason that people are lazy doesn't
>> work for me.
>
> I think you don't really understand what we are trying to explain.
> So I'll try it once again.
>
> We are _not_ saying that having hierarchy policy decisions in the  
> kernel
> is a good thing. It's just the case that we _currently_ have this kind
> of firmware filename, that happens to _map_ to a hierarchy policy
> currently made by udev.
>
> That's either unfortunate (to you) or fortunate (to me).
> In either case we have to live with it and we can _not_ break it.
> By introducing a policy that forbids the use of the slash, we do break
> this.

we can change these things. We do it all the time.

>>> Also, you said above (quoting again):
>>>
>>>> You are fully
>>>> exploiting the request_firmware() interface and making any kind of
>>>> userspace policy impossible.
>>>
>>> That's not true at all. If you decide that the userspace policy  
>>> should
>>> be to load $modulename/$firmwarekey then you'd maybe have something
>>> like /lib/firmware/b43/b43-test/ucode5.fw
>>> and /lib/firmware/b43/b43-osfw/ucode5.fw
>>> and /lib/firmware/b43/b43/ucode5.fw, this doesn't preclude the use.
>>>
>>> Now, if it had been like that from the beginning, Michael probably
>>> wouldn't have used the string "b43" (or "b43-*") but rather  
>>> requested
>>> "broadcom/ucode5.fw" by default and "osfw/ucode5.fw" for the open
>>> source
>>> firmware, but since it's just a key that doesn't matter.
>>
>> That something works at the moment is not a reason for me not to fix
>> it and improve the current framework around firmware loading. I have
>> been a lot of times saying that the request_firmware() should not
>> include "/" in the filename and driver authors followed it. Some of
>> them did it anyway and so these need fixing now.
>
> But to forbid usage of "/" is the _wrong_ way to go, as it breaks
> existing setups.
>
> b43 users are not going to accept re-installing or moving the firmware
> files to another place. We had that in the past. It will result in a  
> _lot_
> of angry complaints like "How dare can you break my setup!".

Again, I don't plan to break any setup. I actually do think it is a  
good idea to group firmware files in subdirectories in /lib/firmware,  
but this subdirectory name doesn't belong in the kernel.

We will update udev to read the driver name and look into /lib/ 
firmware/<driver>/<filename> and /lib/firmware/<filename> for the  
firmware file.

Then we will set a date and note it in the future remove document.  
Something like 12 month after an updated udev has been released. This  
gives the distribution two generations time to update udev and kernel  
packages.

Regards

Marcel

