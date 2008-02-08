Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbYBHVYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbYBHVYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYBHVX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:23:58 -0500
Received: from submit01.sysedata.no ([195.159.29.244]:45175 "EHLO
	submit01.sysedata.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbYBHVX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:23:56 -0500
Message-ID: <47ACC866.6010206@db.org>
Date: Fri, 08 Feb 2008 22:23:50 +0100
From: "Alfred E. Heggestad" <aeh@db.org>
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: driver for USB VoIP phones with CM109 chipset
References: <47AB5012.20509@db.org> <20080207165144.ZZRA012@mailhub.coreip.homeip.net>
In-Reply-To: <20080207165144.ZZRA012@mailhub.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

ok, let us define a new KEY_KPPOUND in linux/input.h

this also means that any application wanting to use this key must
be updated to read this new keycode.

do you want me to add a new value for KEY_KPPOUND in linux/input.h
and include it in the next patch, or can you add that value to the
tree first?


> Another item is keymap for different devices - the best way to handle
> it I think it to implement getkeycodes and setkeycodes methods for
> the input device and have alternative keymaps loaded from userspace
> instead of adding module parameters.
> 

I agree - I dont want to upgrade the driver code whenever there is a
new phone with different key-mapping.

regarding get/set-keycodes, please let me know how I should
proceed on this one..


> The rest of the driver looks great and I am sorry I was ignoring it
> for so long.
> 

no worries, I am happy to fix the remaining issues and submit new
versions of the patch..


/alfred

