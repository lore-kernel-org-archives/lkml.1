Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbZGNWHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbZGNWHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 18:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbZGNWHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 18:07:14 -0400
Received: from mail-qy0-f192.google.com ([209.85.221.192]:64483 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbZGNWHN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 18:07:13 -0400
MIME-Version: 1.0
In-Reply-To: <20090714094629.GB2076@elf.ucw.cz>
References: <20090710084323.GA6522@elf.ucw.cz>
	 <a55d774e0907100155m25366994pe9ec5d0f5f868818@mail.gmail.com>
	 <20090710103243.GB7789@elf.ucw.cz>
	 <a55d774e0907100431j3fdc4671i6b185019594367fa@mail.gmail.com>
	 <20090713202302.GC2569@elf.ucw.cz> <20090713205749.GE2569@elf.ucw.cz>
	 <20090713220726.GA28375@elf.ucw.cz>
	 <d6200be20907131829o77bce3d8w8f238bc079478368@mail.gmail.com>
	 <20090714094629.GB2076@elf.ucw.cz>
Date: Tue, 14 Jul 2009 15:07:12 -0700
Message-ID: <d6200be20907141507s39b54cccq9f0cedc325d3a203@mail.gmail.com>
Subject: Re: HTC: touchscreen driver
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 2:46 AM, Pavel Machek<pavel@ucw.cz> wrote:
>
>> >        if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
>> >                printk(KERN_ERR "synaptics_ts_probe: need I2C_FUNC_I2C\n");
>> > @@ -269,6 +354,9 @@ static int synaptics_ts_probe(
>> >        pdata = client->dev.platform_data;
>> >        if (pdata)
>> >                ts->power = pdata->power;
>> > +       else
>> > +               pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
>> > +
>>
>> Where do you free this?
>
> Well, nowhere; but it should not actually matter. ... btw can this
> path (!pdata) actually trigger? The driver will not be working,
> anyway, in that case..

The driver should work fine without the pdata. The pdata is used to
align the touchscreen data with the screen behind it.

>> > +       u32 flags;
>> > +       u32 inactive_left; /* 0x10000 = screen width */
>> > +       u32 inactive_right; /* 0x10000 = screen width */
>> > +       u32 inactive_top; /* 0x10000 = screen height */
>> > +       u32 inactive_bottom; /* 0x10000 = screen height */
>> > +       u32 snap_left_on; /* 0x10000 = screen width */
>> > +       u32 snap_left_off; /* 0x10000 = screen width */
>> > +       u32 snap_right_on; /* 0x10000 = screen width */
>> > +       u32 snap_right_off; /* 0x10000 = screen width */
>> > +       u32 snap_top_on; /* 0x10000 = screen height */
>> > +       u32 snap_top_off; /* 0x10000 = screen height */
>> > +       u32 snap_bottom_on; /* 0x10000 = screen height */
>> > +       u32 snap_bottom_off; /* 0x10000 = screen height */
>> > +       u32 fuzz_x; /* 0x10000 = screen width */
>> > +       u32 fuzz_y; /* 0x10000 = screen height */
>>
>> I prefer the existing C99 types.
>
> Yes, well, the rest of kernel disagrees with you.

The coding style document claims C99 types are allowed. If that is no
longer the case it should be updated.

>
>> This driver only supports a subset of Synaptics' devices so a more
>> generic driver will eventually be needed. The patch below adds support
>> for a more recent but similar panel.
>
> Ok, that should be simple enough to apply, but lets do improvements
> when we cleaned the code enough for the mainline...?

We need this change now. Your cleanup will cause conflicts for anyone
using our driver, so it would be better if it includes all our fixes.

-- 
Arve Hjønnevåg
