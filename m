Return-Path: <linux-kernel-owner+w=401wt.eu-S1761995AbZCYPP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761995AbZCYPP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 11:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZCYPPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 11:15:12 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:10223 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbZCYPPL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:15:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C83Olj2dUgklY3AEp8bLFiYIyFpA6b6WXFOUPYlD+9G5rdFzYRmxTgAkf/bTOKyA9i
         c2wKjT4qOCDsPwszXQ2gq/jipsli25LX54+DMyyXw/Y6ym9wOv8ve+FUuym9ANJ7NGLu
         qvFDMJ6N3QvoMK6pE24d1EVcuWv/56G7nGmDY=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0903251117220.5795@axis700.grange>
References: <1232458448-4412-1-git-send-email-tom.leiming@gmail.com>
	 <Pine.LNX.4.64.0903250039160.4451@axis700.grange>
	 <d82e647a0903241815l66abfc18ldbb26abd7d2c6b4@mail.gmail.com>
	 <Pine.LNX.4.64.0903250817090.5590@axis700.grange>
	 <d82e647a0903250313ka2d270ag78335e7c7f525f22@mail.gmail.com>
	 <Pine.LNX.4.64.0903251117220.5795@axis700.grange>
Date: Wed, 25 Mar 2009 23:15:09 +0800
Message-ID: <d82e647a0903250815i3fd46b63x42b0355c0aeaedc8@mail.gmail.com>
Subject: Re: [PATCH] driver core: check bus->match without holding device lock
From: Ming Lei <tom.leiming@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: kay.sievers@vrfy.org, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/25 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> On Wed, 25 Mar 2009, Ming Lei wrote:
>
>> >> > Now, without .match() no probing is done. Is this an intended change and
>> >> > soc-camera has to be fixed or is this a bug?
>> >>
>> >> It is not a driver-core bug, and soc-camera should be fixed.
>> >
>> > So, you're saying this used to be a bug and it has been fixed by this
>> > patch? Then why isn't this mentioned in the commit message? The commit
>> > text seems to suggest, that this patch shouldn't introduce any change in
>> > behaviour, but it does. So, before .match == NULL lead to .probe() being
>> > called, and now it doesn't anymore?
>>
>> Where is soc-camera  driver in kernel tree?
>
> drivers/media/video/soc_camera.c
>
>> Which bus  is soc-camera device (driver) attached to ?
>
> camera bus.
>
>> Why doesn't soc-camera  driver  have a match method?
>
> Why should it? Because there is only one driver on this bus by definition
> (and I only register a device on the bus when I find a match between a
> device and its parent / driver).

I grep the drivers directory ( grep -r -n -I -A 5 -w "struct bus_type"
./* ) and
find soc-camera is the __only__ bus-type which have not implemented  match
method, so it is better to define a match method(always return true)
in soc-camera
to solve the  problem, OK?

Also, I will submit a patch to warn absence of match (maybe should
return failed)
in bus_register().

>
> What I in any case see wrong with this patch, is that it _silently_
> changes kernel behaviour without even mentioning it in the commit log!

IMHO, the change should be reasonable, but it is missed carelessly in
commit log.

Thanks

>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
>



-- 
Lei Ming
