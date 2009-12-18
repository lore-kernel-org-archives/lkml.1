Return-Path: <linux-kernel-owner+w=401wt.eu-S1750915AbZLRFDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750915AbZLRFDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 00:03:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbZLRFDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 00:03:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbZLRFDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 00:03:30 -0500
Message-ID: <4B2B0CCE.2020406@redhat.com>
Date: Fri, 18 Dec 2009 15:02:06 +1000
From: Peter Hutterer <peter.hutterer@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: add multi-input quirk for NextWindow Touchscreen.
References: <20091203050810.GA26595@barra.bne.redhat.com>	<87zl60s17o.fsf@macbook.be.48ers.dk> <4B1836A6.405@redhat.com>	<871vjasxnm.fsf@macbook.be.48ers.dk> <4B190D88.4090102@redhat.com>	<87ws12rh5j.fsf@macbook.be.48ers.dk> <4B1C96C4.5080709@redhat.com> <87hbs0mqju.fsf@macbook.be.48ers.dk>
In-Reply-To: <87hbs0mqju.fsf@macbook.be.48ers.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/09 19:42, Peter Korsgaard wrote:
>   Peter>  [root@touchie sbin]# ./nwtool -u -i
>   Peter>  Version:		2.99
>   Peter>  Serial:			617241
>   Peter>  Model:			1901
>   Peter>  HW capabilities:	0x40
>   Peter>  Rightclick delay:	1000 ms
>   Peter>  Doubleclick time:	200 ms
>   Peter>  Report mode:		4
>   Peter>  Drag threshold:		500
>   Peter>  Buzzer time:		40 ms
>   Peter>  Buzzer tone:		40
>   Peter>  Calibration key:	4
>   Peter>  Calibration presses:	3
>
> Hmm, what is report mode 4? Some kind of multi touch mode?
>
> What do you see if you install the Nextwindow USB config tool under
> Windows (unfortunately doesn't work under Wine) and look in the mouse
> tab? I guess you have a 4th option here.
>
> I see this:  http://peter.korsgaard.com/nw.png

argh. now you made me use vista! ;)

Installed version 2.8 today, it offers three modes in his interface: 
None, HID Mouse and "USB Digitiser". The last one was selected when I 
started into Vista. There's an extra checkbox "Multi-Touch reporting" 
that was not ticked.

The different combinations and the reporting mode output of nwtool:
USB Digitizer - multi-touch not ticked: reporting mode 4
USB Digitizer - multi-touch ticked: reporting mode 3
USB HID Mouse - multi-touch not ticked: reporting mode 1
USB HID Mouse - multi-touch ticked: reporting mode 9
None - multi-touch not ticked: reporting mode 0
None - multi-touch ticked: reporting mode 8

For reporting mode 4 and 3, the events are Z/Rx + touch
For reporting mode 1 and 9, the events are ABS_X/Y and left button
For reporting mode 0 and 8, no events are sent (unsurprisingly)

So it seems the only difference between our two models is the default 
reporting mode - assuming that 4 is the default, we've had this thing 
for a year without doing much with it but it could well be that someone 
set it earlier or one of the HP Touchsmart software pieces changed it.

>   >>  It's probably offtopic here, but we can move the discussion to the X
>   >>  list if you prefer - Last time I asked there I didn't get any reply
>   >>  though:
>   >>
>   >>  http://article.gmane.org/gmane.comp.freedesktop.xorg/40071/
>
>   Peter>  Ask louder :) I think I remember your email but it got flooded out of
>   Peter>  my inbox. In general there should be some method to do that though I
>   Peter>  need to check the implementation.
>
> OK, great - Let me know what you find. I did hack something up with
> evtouch, but would like to move to evdev instead.
> I'm willing to work on getting evdev to handle multi screen touchscreen
> setups better if needed, I just need a bit of guidance on how it should
> be handled.

replying to your email right now.

Cheers,
   Peter
