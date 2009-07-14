Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbZGNWpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbZGNWpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 18:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756728AbZGNWpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 18:45:46 -0400
Received: from mail-qy0-f192.google.com ([209.85.221.192]:53123 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707AbZGNWpq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 18:45:46 -0400
MIME-Version: 1.0
In-Reply-To: <20090714221638.GA6512@elf.ucw.cz>
References: <20090710084323.GA6522@elf.ucw.cz>
	 <20090710103243.GB7789@elf.ucw.cz>
	 <a55d774e0907100431j3fdc4671i6b185019594367fa@mail.gmail.com>
	 <20090713202302.GC2569@elf.ucw.cz> <20090713205749.GE2569@elf.ucw.cz>
	 <20090713220726.GA28375@elf.ucw.cz>
	 <d6200be20907131829o77bce3d8w8f238bc079478368@mail.gmail.com>
	 <20090714094629.GB2076@elf.ucw.cz>
	 <d6200be20907141507s39b54cccq9f0cedc325d3a203@mail.gmail.com>
	 <20090714221638.GA6512@elf.ucw.cz>
Date: Tue, 14 Jul 2009 15:45:45 -0700
Message-ID: <d6200be20907141545k2b40b790x1af853b89517891c@mail.gmail.com>
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

On Tue, Jul 14, 2009 at 3:16 PM, Pavel Machek<pavel@ucw.cz> wrote:
...
>> >> This driver only supports a subset of Synaptics' devices so a more
>> >> generic driver will eventually be needed. The patch below adds support
>> >> for a more recent but similar panel.
>> >
>> > Ok, that should be simple enough to apply, but lets do improvements
>> > when we cleaned the code enough for the mainline...?
>>
>> We need this change now. Your cleanup will cause conflicts for anyone
>> using our driver, so it would be better if it includes all our fixes.
>
> Well, I don't expect you to use the cleaned-up driver as-is: I had to
> remove the wakelocks functionality as infrastructure is not in
> mainline.

OK. The driver does not use wakelocks tough, only earlysuspend, so
your cleaned up version should be fully functional. The early suspend
hooks are only used to save power in idle when the screen is off.

> (Plus, I do not have hardware to test your latest version).

True, but the protocol documentation is available:
http://www.synaptics.com/sites/default/files/511_000099_01F.pdf

>
> Applying small patch on top of cleaned up driver should be better than
> carrying whole driver itself, right?

Perhaps, but the only problem I encountered with this driver so far
was when calling disable_irq from the interrupt handler stopped
working on non-smp systems in 2.6.30 (which is another patch you
should probably apply first).

>
> [Alternatively... I can try to incorporate your change, but I'd need
> your testing at that point.]
>                                                                        Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>



-- 
Arve Hjønnevåg
