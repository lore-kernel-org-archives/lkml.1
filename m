Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbYLAMDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbYLAMDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbYLAMDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:03:09 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:7433 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbYLAMDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:03:08 -0500
X-Spam-Flag: NO
X-Spam-Score: -9.389
Message-ID: <4933D278.7050403@tremplin-utc.net>
Date: Mon, 01 Dec 2008 13:03:04 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.18) Gecko/20081120 Mandriva/2.0.0.18-1mdv2009.1 (2009.1) Thunderbird/2.0.0.18 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       hmh@hmh.eng.br
Subject: Re: HP accelerometer: free fall detection working, testers wanted
References: <20081121212121.GA7222@elf.ucw.cz> <20081128104459.GA32417@atrey.karlin.mff.cuni.cz> <493310BD.8050506@tremplin-utc.net> <200812011255.22383.trenn@suse.de>
In-Reply-To: <200812011255.22383.trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Renninger schreef:
> On Sunday 30 November 2008 23:16:29 Éric Piel wrote:
>> Pavel Machek schreef:
>>> Hi!
>>>
>>>>> I got free fall detection to work -- apparently BIOS does all the
>>>>> important stuff itself.
>>>>>
>>>>> Now... I'd like some testers. (Don't comment on code... yet. Yes, it
>>>>> has some issues).
>>>> Also, how do you try free fall? Did you try also with the lid
>>>> opened?
>>> With the lid opened, too, yes. I just took the machine, then tried to
>>> let go and catch it meter below that. (Of course I did not really let
>>> go, but released the grip and followed...)
>> Hi,
>> I've tested it. Mostly, it works. If I let it fall, it detects it. If I
>> repeat, it detects it again. If shake it, it doesn't detect any freefall
>> (good). However, for this to work on my laptop (2510p), after the device
>> is turned on, the AC must be unplugged and lid closed before it starts
>> working. It seems that that's only this specific state that triggers the
>> configuration of the sensor by the bios. Once setup, I can plug back and
>> open again the lid, the sensor keeps detecting the freefalls (until it's
>> turned off again).
>>
>> So I think it's still necessary to explicitly set up the sensor. It's
>> just a matter of setting up the registers as the bios does. We should be
>> able to manage (just by dumping them once).
>>
>> BTW, there were a couple of problems with the scripts. You have change
>> "/dev/misc" to "/dev/freefall" (which I also like more) but forgot to
>> update the driver itself.
>>
>> For hp3dg, it couldn't find the led (not the same truncation of the name
>> of the led). Probably you could replace the name of the led by:
>> /sys/class/leds/*hddprotect*/
>>
>> The led never turns off, because the sleep is slightly shorter than the
>> unload command.
>>
>> Moreover, on my system I have neither /proc/acpi/button/lid/LID/state
>> nor /proc/acpi/ac_adapter/AC0/state ! I guess they could be replaced by
>> a clever use of /dev/input/eventX (contening Lid) and
>> /sys/class/power_supply/*/online
> These should still exist (bug?), as long as you do compile with ACPI_PROCFS
> (and load the ac, button modules).
> But there should also exist a sysfs replacement:
> http://userweb.kernel.org/~lenb/doc/LPC2008-API-web/
> gives an overview of what is converted and where it should pop up now.
Yes, I explicitly compiled my kernel without ACPI_PROCFS. This was just
to remind Pavel that his brand new script relies on deprecated
interfaces ;-)

Eric
