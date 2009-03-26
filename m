Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbZCZPqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbZCZPqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 11:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbZCZPqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 11:46:13 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:13736 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbZCZPqM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 11:46:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QVvzWCDC4trL58BQIs76/rYPuxr34e8ymVy2LfLwvv+0crpOhh+cq4aIOdGAoHTqRp
         2sRei6u244naBaa9I4d/+cElE3MTATfvjFKBXTWE6aqP3K1v9+58hMuP+1YWF1L6P3h5
         XsFKPmm8n6Mm5txtsdA+HKE2srqMekT5JJtSY=
MIME-Version: 1.0
In-Reply-To: <d82e647a0903250815i3fd46b63x42b0355c0aeaedc8@mail.gmail.com>
References: <1232458448-4412-1-git-send-email-tom.leiming@gmail.com>
	 <Pine.LNX.4.64.0903250039160.4451@axis700.grange>
	 <d82e647a0903241815l66abfc18ldbb26abd7d2c6b4@mail.gmail.com>
	 <Pine.LNX.4.64.0903250817090.5590@axis700.grange>
	 <d82e647a0903250313ka2d270ag78335e7c7f525f22@mail.gmail.com>
	 <Pine.LNX.4.64.0903251117220.5795@axis700.grange>
	 <d82e647a0903250815i3fd46b63x42b0355c0aeaedc8@mail.gmail.com>
Date: Thu, 26 Mar 2009 23:46:08 +0800
Message-ID: <d82e647a0903260846m723b2ebbu3a1515b31d19cc99@mail.gmail.com>
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

2009/3/25 Ming Lei <tom.leiming@gmail.com>:
> 2009/3/25 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
>> On Wed, 25 Mar 2009, Ming Lei wrote:
>>
>>> >> > Now, without .match() no probing is done. Is this an intended change and
>>> >> > soc-camera has to be fixed or is this a bug?
>>> >>
>>> >> It is not a driver-core bug, and soc-camera should be fixed.
>>> >
>>> > So, you're saying this used to be a bug and it has been fixed by this
>>> > patch? Then why isn't this mentioned in the commit message? The commit
>>> > text seems to suggest, that this patch shouldn't introduce any change in
>>> > behaviour, but it does. So, before .match == NULL lead to .probe() being
>>> > called, and now it doesn't anymore?
>>>
>>> Where is soc-camera  driver in kernel tree?
>>
>> drivers/media/video/soc_camera.c
>>
>>> Which bus  is soc-camera device (driver) attached to ?
>>
>> camera bus.
>>
>>> Why doesn't soc-camera  driver  have a match method?
>>
>> Why should it? Because there is only one driver on this bus by definition
>> (and I only register a device on the bus when I find a match between a
>> device and its parent / driver).
>
> I grep the drivers directory ( grep -r -n -I -A 5 -w "struct bus_type"
> ./* ) and
> find soc-camera is the __only__ bus-type which have not implemented  match

Sorry, under arch and sound, there are some instances of bus_type defined, and
few of them ( two or three ) do not have a .match method. So it is better to
not change previous driver core behaviour and allow .probe called if bus->match
not defined.

I'll submit a patch to fix it ,and you need not to fix your soc-camera.

Thanks.

> method, so it is better to define a match method(always return true)
> in soc-camera
> to solve the  problem, OK?
>
> Also, I will submit a patch to warn absence of match (maybe should
> return failed)
> in bus_register().
>
>>
>> What I in any case see wrong with this patch, is that it _silently_
>> changes kernel behaviour without even mentioning it in the commit log!
>
> IMHO, the change should be reasonable, but it is missed carelessly in
> commit log.
>
> Thanks
>
>>
>> Thanks
>> Guennadi
>> ---
>> Guennadi Liakhovetski, Ph.D.
>> Freelance Open-Source Software Developer
>>
>
>
>
> --
> Lei Ming
>



-- 
Lei Ming
