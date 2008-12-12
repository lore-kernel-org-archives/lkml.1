Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbYLLLAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbYLLLAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 06:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757846AbYLLLAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 06:00:13 -0500
Received: from smtp.movial.fi ([62.236.91.34]:51552 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757625AbYLLLAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 06:00:11 -0500
Message-ID: <49424438.7030205@movial.fi>
Date: Fri, 12 Dec 2008 13:00:08 +0200
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Organization: Movial Creative Technologies
User-Agent: Icedove 1.5.0.14eol (X11/20080724)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Mike Frysinger <vapier.adi@gmail.com>, Julia Lawall <julia@diku.dk>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/28] drivers/base/platform.c: Drop return value from
 platform_driver remove functions
References: <Pine.LNX.4.64.0812101725540.21998@ask.diku.dk> <8bd0f97a0812100928l2c75d373n7eba5aa0cc3882fd@mail.gmail.com> <53806.88.114.236.15.1228947522.squirrel@webmail.movial.fi> <8bd0f97a0812101437r4abb9346p8bc8d512ddc02cde@mail.gmail.com> <20081212051759.GA12563@suse.de>
In-Reply-To: <20081212051759.GA12563@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Dec 10, 2008 at 05:37:42PM -0500, Mike Frysinger wrote:
>> On Wed, Dec 10, 2008 at 17:18, Vorobiev Dmitri wrote:
>>>> On Wed, Dec 10, 2008 at 11:26, Julia Lawall wrote:
>>>>> The return value of the remove function of a driver structure, and thus
>>>>> of
>>>>> a platform_driver structure, is ultimately ignored, and is thus
>>>>> unnecessary.  The goal of this patch is to make it possible to convert
>>>>> the
>>>>> platform_driver functions stored in the remove field such that they
>>>>> return
>>>>> void.  This patch introduces a temporary field remove_new with return
>>>>> type
>>>>> void into the platform_driver structure, and updates the only place that
>>>>> the remove function is called to call the function in the remove_new
>>>>> field,
>>>>> if one is available.  The subsequent patches update some drivers to use
>>>>> the
>>>>> remove_new field.
>>>> why bother with remove -> remove_new convention ?
>>> Please see this email for the background:
>>>
>>> http://lkml.org/lkml/2008/12/10/231
>>>
>>>>  you'll get a
>>>> warning in C about the assignment, but you wont get a build failure,
>>> ...unless you compile with -Werror, which frequently the case.
>> anyone crazy enough to build with -Werror is crazy enough to send in a fix ;)
> 
> Hm, have you noted that some arches have that flag enabled in their
> build?
> 
> And it's not ok to add a couple of hundred build warnings to the system,
> sorry.

Still, what about the whole series? What do you think about int->void migration for the remove() callback?

Thanks,
Dmitri

> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

