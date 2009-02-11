Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbZBKKhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbZBKKhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 05:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbZBKKhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 05:37:43 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:46179 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbZBKKhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 05:37:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ihqL9kAROEnhISafacOQX6er+fXV6tcAwCvVGzvnQTEaEdtQlNrEThGJr6WpjKPylr
         edl16sqdu1wM4WRqJEBAzBSXIv8i/NRx6uYKOH3nvoR1eq0He/JuOPr0yn1v66u/8dWQ
         z+rrmCmsBs8UDlLrYGTV/cNoJzUkygvHHySfc=
MIME-Version: 1.0
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090120C0B8@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE19090120BD69@mi8nycmail19.Mi8.com>
	 <20090209143716.57467016.akpm@linux-foundation.org>
	 <BD79186B4FD85F4B8E60E381CAEE19090120C0B8@mi8nycmail19.Mi8.com>
Date: Wed, 11 Feb 2009 11:37:41 +0100
Message-ID: <ca2dc2820902110237u7c050e98t29019cc89d66a6a3@mail.gmail.com>
Subject: Re: [PATCH] auxdisplay: remove PARPORT dependency
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: hartleys <hartleys@visionengravers.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 11:46 PM, hartleys <hartleys@visionengravers.com> wrote:
> On Monday, February 09, 2009 3:37 PM, Andrew Morton wrote:
>> (please cc the maintainers on patches)
>
> Sorry about missing that.  I wasn't sure how patches to Kconfig were
> handled.
>
>>> Remove PARPORT dependency for Auxiliary Display support.
>>>
>>> This is not needed since the dependency for the KS0108 driver is
>>> PARPORT_PC.
>>>
>>
>> OK, but the patch also accidentally removes the parport dependency
>> from cfag12864b.c and cfag12864bfb.c.
>>
>> A quick grep indicates that those drivers don't need parport, but I
>> didn't look very closely.
>
> I think the dependency will be handled automatically.  Both cfag12864b.c
> and cfag12864bfb.c are enabled by CFAG12864B which has a dependency on
> KS0108, which it turn depends on PARPORT_PC.

That's true; however, I think it is intentional: cfag12864bfb depends
on cfags12864b, and this one depends on ks0108, which depends on
parport and, for the moment, there aren't more entries on "Auxiliary
Display support". Thereafter, if PARPORT is not selected, the user is
not bothered with an additional menu entry on "Device Drivers".

I don't know which is the trend nowadays in this subject (i.e. to show
every menu althought empty or not). I see Andrew has already added the
patch, so I bet on his decision ;)

>
>>>
>>> diff --git a/drivers/auxdisplay/Kconfig b/drivers/auxdisplay/Kconfig
>>> index 14b9d5f..c07e725 100644
>>> --- a/drivers/auxdisplay/Kconfig
>>> +++ b/drivers/auxdisplay/Kconfig
>>> @@ -6,7 +6,6 @@
>>>  #
>>>
>>>  menuconfig AUXDISPLAY
>>> -    depends on PARPORT
>>>      bool "Auxiliary Display support"
>>>      ---help---
>>>        Say Y here to get to see options for auxiliary display
> drivers.
>>> @@ -14,7 +13,7 @@ menuconfig AUXDISPLAY
>>>
>>>        If you say N, all options in this submenu will be skipped and
>>> disabled.
>>>
>>> -if AUXDISPLAY && PARPORT
>>> +if AUXDISPLAY
>>>
>>>  config KS0108
>>>      tristate "KS0108 LCD Controller"
>>
>> Your email client wordwraps patches.  Please fix that up for next
> time.
>
> Sorry about that also.  Do you have any idea how to correctly configure
> Outlook to not mess with wordwraps?  I know, it's a stupid client, but's
> that's what I'm stuck with here at work.  I've been beating my head with
> it trying to get it to work correctly.
>
>
