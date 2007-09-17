Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbXIQLjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbXIQLjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 07:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbXIQLjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 07:39:12 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:32099 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbXIQLjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 07:39:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Kzreua0wKfNk6CwwQuYW2My6dMwhw6woeQf3GGG+bSSeC5BhvryFrE+UzNzryLVconUVix/KmeEKzfMOHyCpnDSNHSXFly0A+pzy4IMfZ9kRvH55esTEj0qijYfJEmKWGWatM146pJS7sZlQnkHtSywn9KQex0FvjAsEka11DkU=
Message-ID: <46EE66EA.3090902@gmail.com>
Date: Mon, 17 Sep 2007 13:37:14 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Sergey Dolgov <dolgovs@gmail.com>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: ata_piix, laptop cdrom, ICH7: EH, limiting speed to PIO
References: <20070911212030.GA2817@slk.laptop>	 <6bffcb0e0709120933p6d58127fv3c85076fe41daaca@mail.gmail.com>	 <20070912200706.GA2620@slk.laptop> <46E849B7.9040402@googlemail.com>	 <20070912212025.GB2620@slk.laptop> <46E8663E.3080205@googlemail.com>	 <46ED19F0.8060205@gmail.com> <ac0be4d70709170257o62e856f4re049c968ab5590a7@mail.gmail.com>
In-Reply-To: <ac0be4d70709170257o62e856f4re049c968ab5590a7@mail.gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Dolgov wrote:
> On 9/16/07, Tejun Heo <htejun@gmail.com> wrote:
>> Michal Piotrowski wrote:
>>> Sergey Dolgov pisze:
>>>> On Wed, Sep 12, 2007 at 10:19:03PM +0200, Michal Piotrowski wrote:
>>>>> Sergey Dolgov pisze:
>>>>>> Hi Michal,
>>>>>>
>>>>>> On Wed, Sep 12, 2007 at 06:33:20PM +0200, Michal Piotrowski wrote:
>>>>>>> Hi Sergey,
>>>>>>>
>>>>>>> On 11/09/2007, Sergey Dolgov <dolgovs@gmail.com> wrote:
>>>>>>>> Hi!
>>>>>>>>
>>>>>>>> On my hp nx7300 laptop, 2 following scenarios can happen during bootup
>>>>>>>> (see attachments for the full logs): the "good" one [1] and the one
>>>>>>>> where multiple EHs lead to limiting the speed [2].
>>>>>>>>
>>>>>>>> [1] one is more rare, but it seems to be persistent over reboots: once
>>>>>>>> it happened, just rebooting the machine always results in behaviour
>>>>>>>> like [1].
>>>>>>>>
>>>>>>>> [1] results in a working cdrom from the start. An attempt to use cdrom
>>>>>>>> after [2] happened results in even more EHs, resulting in "configured
>>>>>>>> for PIO4", after which the cdrom is finaly working.
>>>>>>>>
>>>>>>>> The version I'm using is 2.6.23-rc6, but the same used to happen with
>>>>>>>> the previous rc's, and probably with 2.6.22 too (I can check).
>>>>>>> It would be great if you could check it.
>>>>>> I've just built 2.6.22.6 with basically the same configuration, and
>>>>>> the behaviour is just the same, i.e. both [1] and [2] still can
>>>>>> happen.
>>>>> Ok, thanks.
>>>>>
>>>>> BTW please check cables and PCU.
>>>> What's a PCU?
>>> s/PCU/PSU - power supply unit
>>>
>>>> BTW, this only happens when using libata of course. The
>>>> old CONFIG_IDE stuff works fine every time.
>>> This maybe one of libata weirdness (I really don't get it why some hardware
>>> works perfectly fine with an old IDE and don't work well with libata).
>> Hmmm... Is MWDMA2 mode used with ide driver too?
>>
> 
> What's the best way to tell whether it does or not? (the log says
> "selected mode 0x22", see below)

Yes, that's MWDMA2.  Hmm... We're seeing many cases where MWDMA doesn't
work with libata while it works fine with IDE but have no idea what's
going on yet.  :-(

-- 
tejun
