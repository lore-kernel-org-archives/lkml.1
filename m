Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492Ab0ANXeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab0ANXeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 18:34:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756997Ab0ANXeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 18:34:08 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:39851 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab0ANXeE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 18:34:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BeGB0JQGEt9/VttJAbKEVLD8DhcxriQoXYbCffNrq3JKs8LMOjEYfjOA+sLhPN//mK
         5F9tAHNHrVJ2MpMQtvRlOE57cMKm6fWnDs1C3qgDSbC/HJiA9VFRu3EQ7EeMucg/nfVc
         9Fi1CqcD3x2HrLPgSA0FPQ5A8mJUGqfVsKGno=
MIME-Version: 1.0
In-Reply-To: <8f404284c29a6e7736de49ede9a44a2c.squirrel@intranet.cs.nmsu.edu>
References: <200912142122.nBELMW7d001243@mustang.cs.nmsu.edu>
	 <20091216103423.GE1377@ucw.cz>
	 <alpine.LNX.2.00.0912161504360.3755@pobox.suse.cz>
	 <7f9100aac5f9b06ec78efff25c7a5a71.squirrel@intranet.cs.nmsu.edu>
	 <20100104224817.GA21695@elf.ucw.cz>
	 <45a44e481001041614i35ceef84q5f12a068e2f0b97b@mail.gmail.com>
	 <ca2dc2821001141308s5a552447yb887f619231f449@mail.gmail.com>
	 <044387d146c2f91cb7f593736fcce28f.squirrel@intranet.cs.nmsu.edu>
	 <ca2dc2821001141434u5216161bk8c34e1572c0ae260@mail.gmail.com>
	 <8f404284c29a6e7736de49ede9a44a2c.squirrel@intranet.cs.nmsu.edu>
Date: Fri, 15 Jan 2010 00:34:02 +0100
Message-ID: <ca2dc2821001141534r94976dcs5c6b01fb2ef86afd@mail.gmail.com>
Subject: Re: [PATCH] Logitech G13 driver (fixed cc list --- ignore others)
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       krzysztof.h1@wp.pl, Andrew Morton <akpm@linux-foundation.org>,
       linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
       linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 12:03 AM, Rick L. Vinyard, Jr.
<rvinyard@cs.nmsu.edu> wrote:
> Miguel Ojeda wrote:
>> On Thu, Jan 14, 2010 at 10:48 PM, Rick L. Vinyard, Jr.
>> <rvinyard@cs.nmsu.edu> wrote:
>>> Miguel Ojeda wrote:
>>>> On Tue, Jan 5, 2010 at 1:14 AM, Jaya Kumar <jayakumar.lkml@gmail.com>
>>>> wrote:
>>>>> On Tue, Jan 5, 2010 at 6:48 AM, Pavel Machek <pavel@ucw.cz> wrote:
>>>>>>
>>>>>> Ok, but I guess you should cc auxdisplay people in future.
>>>>>
>>>>> Hi Pavel,
>>>>>
>>>>> I just looked at the drivers/auxdisplay directory and got a bit
>>>>> confused. The reason I got confused is because auxdisplay is actually
>>>>> an fbdev driver but it is outside of the drivers/video directory. It
>>>>> looks like there has only been 1 commit and that was for the Samsung
>>>>> KS0108 controller. It also sort of uses platform support but the way
>>>>> it is abstracted is odd to my thinking. The controller is ks0108, so
>>>>> in my mind that would be the code that would be platform independent,
>>>>> and then that would use a board specific IO driver to push data (eg:
>>>>> parport or gpio or usb). I think in the long term it would probably
>>>>> make sense to write a cleaner approach with a drivers/video/ks0108.c
>>>>> which is cleanly platform independent (and back within fbdev proper)
>>>>> and then a board specific driver in the appropriate location that
>>>>> handles the IO.
>>>>
>>>> I wrote long ago the driver(s) and people that reviewed it thought it
>>>> was better to keep it outside. I think that if someone else is going
>>>> to need ks0108, then I agree: we should write a independent driver.
>>>>
>>>> It should not be hard, it is an easy controller to play with and the
>>>> code is already there. I would try to do it; however, I am not sure if
>>>> I would be the most appropriate person to code such generic driver, as
>>>> I know almost nothing about all drivers/video/* stuff and the ways of
>>>> making it truly generic for future video/ users. Still, I will help
>>>> gladly.
>>>>
>>>
>>> When I started to look at writing the G13 framebuffer the first code I
>>> looked at was the cfag12864b, and started off trying to adapt it.
>>>
>>
>> I hope it was useful, at least at first. : )
>>
>>> However, as I was digging through the video/* directory looking for
>>> something (I forget now what) I came across the hecubafb and patterned
>>> the
>>> G13 after it instead.
>>>
>>> In moving between the two, the biggest difference was that I was able to
>>> strip out alot of the workqueue code you had since all that was provided
>>> by defio. Otherwise, the general structure was almost identical.
>>>
>>> In particular, what would change is the lower half of cfag12864b.c and
>>> you
>>> would be able to eliminate almost everything from the /* Update work */
>>> and below comment with the exception of cfag12864b_update().
>>>
>>> cfag12864b_update() would become almost analogous to the g13_fb_update()
>>> I
>>> have in the G13 driver which is triggered by the deferred_io member of
>>> the
>>> fb_deferred_io structure.
>>>
>>> You would have something like:
>>>
>>> /* Callback from deferred IO workqueue */
>>> static void cfag12864b_deferred_io(struct fb_info *info, struct
>>> list_head
>>> *pagelist)
>>> {
>>>        cfag12864b_update(info->par);
>>> }
>>>
>>> static struct fb_deferred_io cfag12864b_defio = {
>>>        .delay = HZ / CFAG12864B_UPDATE_RATE_DEFAULT,
>>>        .deferred_io = cfag12864b_deferred_io,
>>> };
>>>
>>
>> Thank you for the analysis of cfag12864b. See below.
>>
>>>
>>> The other major change is that you could eliminate the periodic memcmp()
>>> to see if the buffer has change since the deferred_io is only going to
>>> trigger on a page write fault.
>>
>> Yeah, I admit the memcmp() is pretty ugly knowing about deferred_io,
>> which I did not. It is strange that anyone pointed it out long before,
>> is it new? Are there any known drawbacks?
>>
>
> Not sure how old it is... I don't know of any drawbacks.
>
>>>
>>> But, that isn't a major change in the code... only in performance.
>>>
>>
>> So less code and greater performance. That sounds like a winning deal!
>>
>> About ks0108, have you got any thoughts on how to write a generic
>> driver? Do you need something special about ks0108? I only needed raw
>> output operations so I just implemented that. Also, cfag12864b uses
>> two ks0108 controllers and I suppose other LCD's use many more, so
>> there are many points that may need a "research".
>>
>
> Actually, I don't need the ks0108 code. Way back when Alan Cox suggested
> taking a framebuffer approach for the G13, Pavel suggested looking at the
> auxdisplay code.
>
> But, the LCD in the G13 is really a USB device that ships the image out as
> an interrupt message with the framebuffer image as the payload. So, in
> essence, the callback in the G13 is really a usbhid_submit_message() after
> some other work to massage the bits from an xbm format to a format
> specific to the Logitech game panel.
>

Oh, excuse me, I started reading from your first message in this
thread after a search for "ks0108" on my inbox and I thought Jaya was
referring to your code.

Miguel Ojeda

> ---
>
> Rick
>
>
>
