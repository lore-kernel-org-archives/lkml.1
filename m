Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042Ab0AHQqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab0AHQqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 11:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017Ab0AHQql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 11:46:41 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:43922 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab0AHQqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 11:46:40 -0500
Message-ID: <afb1408fa27fc03b71f07d39513c2719.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <4B473F64.2010203@debian.org>
References: <200912142122.nBELMW7d001243@mustang.cs.nmsu.edu>
    <45a44e481001041557t1f87f8d4i959abbbee0c4346@mail.gmail.com>
    <635ab1237a6a988656a2bf28e488f656.squirrel@intranet.cs.nmsu.edu>
    <4B473F64.2010203@debian.org>
Date: Fri, 8 Jan 2010 09:45:30 -0700
Subject: Re: [PATCH] Logitech G13 driver (fixed cc list --- ignore others)
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Giacomo A. Catenazzi" <cate@debian.org>
Cc: "Jaya Kumar" <jayakumar.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       krzysztof.h1@wp.pl, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-input@vger.kernel.org, jkosina@suse.cz,
       linux-fbdev@vger.kernel.org
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Giacomo A. Catenazzi wrote:
> On 07.01.2010 16:59, Rick L. Vinyard, Jr. wrote:
>> Jaya Kumar wrote:
>>> On Tue, Dec 15, 2009 at 5:22 AM, Rick L. Vinyard Jr.
>>> <rvinyard@cs.nmsu.edu>  wrote:
>>>> Additionally, this device contains a 160x43 monochrome LCD display.
>>>> A registered framebuffer device manages this display. The design
>>>> of this portion of the driver was based on the design of the
>>>> hecubafb driver with deferred framebuffer I/O since there is
>>>> no real memory to map.
>>>
>>> Hi Rick,
>>>
>>> Interesting work. I recommend CCing linux-fbdev@vger.kernel.org too
>>> since it contains a fbdev interface.
>>>
>>
>> Thanks. Added.
>>
>>>> +config LOGITECH_G13
>>>> +       tristate "Logitech G13 gameboard support"
>>>> +       depends on HID_LOGITECH
>>>> +       depends on FB
>>>> +       select FB_SYS_FILLRECT
>>>> +       select FB_SYS_COPYAREA
>>>> +       select FB_SYS_IMAGEBLIT
>>>> +       select FB_SYS_FOPS
>
> Sorry to enter in this discussion so late.
>
> What about g15 keyboards and related keyboards?
>
> It would nice if your driver could handle also the other keyboards.
>

I don't have one to test. Technically _I_ don't even have a g13. The two I
currently have are borrowed.

> The package g15daemon handles such keyboards (or LCD screens):
>
> # Logitech g11 -- extra keys, no LCD
> # Logitech G15 (blue) -- extra keys and LCD
> # Logitech G15 v2 (orange) -- extra keys and LCD
> # Logitech Z10 -- extra keys and LCD, shared with audio, not a keyboard
> # Logitech G15 Gamepanel -- extra keys and LCD
>
> but using an daemon has it own problems, so I would like to
> move the support to the kernel.
>

I think the ideal approach is to use a split between a userspace daemon
and the kernel driver. I've exposed a lot of the driver to userspace
through sysfs to allow a great deal of control through a userspace daemon
for the G13.

In particular I think a similar approach with the framebuffer for those
devices would be particularly beneficial. It allows things such as the
cairo library to be used to draw on the LCD which opens up the possibility
for all kinds of userspace applets.

> Is it ok for you?
>

I don't have a problem with it, but I think there might be issues;
especially if the feature reports are different.

There is similar framebuffer code that could be shared even if the usbhid
reports differ since the LCD image format is the same.

But, I don't think the framebuffer code could be completely separated
since the G13 uses the same interrupt pipe for images and key reports.
That's why the framebuffer code (as minimal as it is) is inside the hid
driver.

> Could you use a more generic name for configuration?
> (e.g. CONFIG_LOGITECH_G_SERIES)
>

I don't have a problem with it, but my gut feeling is that they will be
separate drivers. So perhaps a menu option for the G series with the G
series drivers under it???

---

Rick


