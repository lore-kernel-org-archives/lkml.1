Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbYFUWwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbYFUWwr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 18:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbYFUWwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 18:52:37 -0400
Received: from submit-tmp.sysedata.no ([195.159.29.133]:33390 "EHLO
	submit-tmp.sysedata.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYFUWwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 18:52:36 -0400
X-Greylist: delayed 1740 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Jun 2008 18:52:36 EDT
Message-ID: <485D7F65.4080700@db.org>
Date: Sun, 22 Jun 2008 00:23:33 +0200
From: "Alfred E. Heggestad" <aeh@db.org>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: driver for USB VoIP phones with CM109 chipset
References: <47AB5012.20509@db.org> <20080207165144.ZZRA012@mailhub.coreip.homeip.net>
In-Reply-To: <20080207165144.ZZRA012@mailhub.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelisted: <dmitry.torokhov@gmail.com>
X-Whitelisted: <linux-input@vger.kernel.org>
X-Whitelisted: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry

Dmitry Torokhov wrote:
> Hi Alfred,
> 
> On Thu, Feb 07, 2008 at 07:38:10PM +0100, Alfred E. Heggestad wrote:
>> From: Alfred E. Heggestad <aeh@db.org>
>>
>> This driver adds support for USB VoIP phones using the CM109 chipset,
>> such as Komunikate KIP-1000 and Genius G-talk. Keypad is scanned and
>> events are reported to the input subsystem. The buzzer can be activated
>> by sending SND_TONE or SND_BELL to the input device. The phone keymap
>> can be selected in run-time by using the "phone" module parameter.
>> The driver has been tested with linux 2.6.24 on i386, and also tested
>> to build cleanly on AMD64.
>> More testing and code review is welcome..
>>
> 
> For a long time I was sitting on the patch not sure what to do about
> the pound key, but I think we need to allocate separate keycodes for
> remote controls and phones that work regardless of users keymap.
> 

do you think we could add a new KEY_KPPOUND to include/linux/input.h ?

I just had a quick look in latest git, but could not find anything..
do you want me to define a key and make a patch for you?

BTW, for now I have defined a work-around in my cm109 driver:

#ifndef KEY_KPPOUND
#define KEY_KPPOUND (KEY_LEFTSHIFT | KEY_3 << 8)
#endif

that hack was "copied" from drivers/input/misc/yealink.c

         case 0x32: return KEY_LEFTSHIFT |
                           KEY_3 << 8;   /*   #          */



/alfred


<snip>
