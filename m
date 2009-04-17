Return-Path: <linux-kernel-owner+w=401wt.eu-S1760283AbZDQG6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760283AbZDQG6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 02:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759681AbZDQG6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 02:58:23 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:46804 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760089AbZDQG6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 02:58:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hwNNij7q+HFN3FuM3julGKTCHEnqkwPq2cLeNY8/+aScs1xjHgPF27dsejZo9S61w1
         EwUX51U2tg4Eo7ABz1KYBz14jZby4RVpmEB0+Xqh5PYBOOQra8iuQKp6LLTY7EZT9K/z
         n/anrLft/Hqz9ALg9gVk6bwP1ctAC+NVnz4tQ=
MIME-Version: 1.0
In-Reply-To: <49E7BF34.6060002@zytor.com>
References: <49E38331.3090808@garzik.org> <49E38393.8000700@garzik.org>
	 <20090413182746.GA9954@elte.hu> <49E5EABB.9010402@garzik.org>
	 <b647ffbd0904150751u64e69097q79c511533f949c00@mail.gmail.com>
	 <20090416230731.GA19553@elte.hu> <49E7BD64.7060507@garzik.org>
	 <49E7BF34.6060002@zytor.com>
Date: Fri, 17 Apr 2009 08:58:20 +0200
Message-ID: <b647ffbd0904162358t465b97dtf3b41d045fd0d0a9@mail.gmail.com>
Subject: Re: microcode driver newly spews warnings
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeff Garzik <jeff@garzik.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Oruba <peter.oruba@amd.com>, amd64-microcode@amd64.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/17 H. Peter Anvin <hpa@zytor.com>:
> Jeff Garzik wrote:
>>>
>>> Jeff, did this do the trick for you?
>>
>> Yes -- but I worry about keeping sysfs files around too long?
>>
>>    Jeff
>
> OK, what isn't clear to me is what the proper return value is in this case.
>  In particular, how with the caller react to mc_sysdev_add() returning a
> nonzero value, but still have the sysdev devices created and retained?
>
> What I would expect happen would be that sysdev_register_driver() would
> return an error and we would unregister the notifier, which really isn't the
> right thing -- if the intent is to keep the sysdev devices around for a
> possible later update then we should presumably return zero there, i.e.
> ignore the return value from microcode_init_cpu(); completely?

sysdev_driver_register() doesn't seem to check return values of ->add
callbacks (mc_sysdev_add() in our case). That's why I also wondered
why in this case the microcode module gets unloaded shortly after
having been loaded (maybe the startup script actually checks the
availability of these sysdev files?)

My first impression is that we shouldn't treat the case when a proper
ucode is not found in the firmware as an error. Say, what is a user
upgrades manually via /dev/microcode later on?

>
>        -hpa
>

-- 
Best regards,
Dmitry Adamushko
