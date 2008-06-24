Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbYFXE7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbYFXE7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 00:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbYFXE72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 00:59:28 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:31696 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbYFXE71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 00:59:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QmH2Qi3AjDh3oAW3a3chPuzj5f5NE5EF7Ja7j6KAIqlvzADFmKoN1mjnfK+mX300YA
         9DwIliIOWdQqP0sk6Id/ldHbnq8IvoZJWUKWPmozg7ZLj/QHwen2aKno/SHvLv7IQOml
         j1j1BRjNCwW8yZ0/G5dBLvYzcZ/LjRB7/Mq14=
Date: Tue, 24 Jun 2008 00:59:19 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Alfred E. Heggestad" <aeh@db.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: driver for USB VoIP phones with CM109 chipset
Message-ID: <20080624045919.GA18612@anvil.corenet.prv>
References: <47AB5012.20509@db.org> <20080207165144.ZZRA012@mailhub.coreip.homeip.net> <485D7F65.4080700@db.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485D7F65.4080700@db.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alfred,

On Sun, Jun 22, 2008 at 12:23:33AM +0200, Alfred E. Heggestad wrote:
> Hi Dmitry
>
> Dmitry Torokhov wrote:
>> Hi Alfred,
>>
>> On Thu, Feb 07, 2008 at 07:38:10PM +0100, Alfred E. Heggestad wrote:
>>> From: Alfred E. Heggestad <aeh@db.org>
>>>
>>> This driver adds support for USB VoIP phones using the CM109 chipset,
>>> such as Komunikate KIP-1000 and Genius G-talk. Keypad is scanned and
>>> events are reported to the input subsystem. The buzzer can be activated
>>> by sending SND_TONE or SND_BELL to the input device. The phone keymap
>>> can be selected in run-time by using the "phone" module parameter.
>>> The driver has been tested with linux 2.6.24 on i386, and also tested
>>> to build cleanly on AMD64.
>>> More testing and code review is welcome..
>>>
>>
>> For a long time I was sitting on the patch not sure what to do about
>> the pound key, but I think we need to allocate separate keycodes for
>> remote controls and phones that work regardless of users keymap.
>>
>
> do you think we could add a new KEY_KPPOUND to include/linux/input.h ?
>
> I just had a quick look in latest git, but could not find anything..
> do you want me to define a key and make a patch for you?
>
I was pretty sure I have commited that patch a few weeks ago but I was
wrong. Anyway, please take a look at the master branch of my input tree
on git.kernel.org, it has a few new keycode definitions I woudl like us
to start using.

> BTW, for now I have defined a work-around in my cm109 driver:
>
> #ifndef KEY_KPPOUND
> #define KEY_KPPOUND (KEY_LEFTSHIFT | KEY_3 << 8)
> #endif
>
> that hack was "copied" from drivers/input/misc/yealink.c
>
>         case 0x32: return KEY_LEFTSHIFT |
>                           KEY_3 << 8;   /*   #          */
>

Yeah, well, sometimes we let suboptimal solutions sneak in... our fault.

-- 
Dmitry
