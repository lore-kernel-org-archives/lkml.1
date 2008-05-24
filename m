Return-Path: <linux-kernel-owner+w=401wt.eu-S1762098AbYEXUw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762098AbYEXUw3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 16:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761126AbYEXUwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 16:52:21 -0400
Received: from gw.goop.org ([64.81.55.164]:44696 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760299AbYEXUwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 16:52:20 -0400
Message-ID: <48387FE7.2080608@goop.org>
Date: Sat, 24 May 2008 21:51:51 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Tom Spink <tspink@gmail.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Steve French <smfrench@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com>	 <4837AAE2.9090102@zytor.com>	 <20080524064201.GA4133@uranus.ravnborg.org>	 <4837E89D.9040008@goop.org>	 <20080524112704.GA7292@uranus.ravnborg.org>	 <483827CE.9080200@goop.org>	 <20080524153611.GA13890@uranus.ravnborg.org>	 <48383830.6060504@goop.org>	 <19f34abd0805240857l57e667fdicb240baf898f6296@mail.gmail.com>	 <48383C26.5040106@goop.org> <7b9198260805240940v46db928ak9bcacf9363c46d41@mail.gmail.com> <48387CCB.1030801@goop.org> <48387DF0.7000600@zytor.com>
In-Reply-To: <48387DF0.7000600@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>> Tom Spink wrote:
>>> A thought occurred to me that we may be able to used some preprocessor
>>> magic and do this:
>>>
>>> #define config_defined(x) CFGVAL_## x
>>>
>>> Which means that, if we get Kconfig to produce:
>>>
>>> #define CFGVAL_CONFIG_FOO 0
>>> #define CFGVAL_CONFIG_VALUE_BAR 1
>>> #define CFGVAL_CONFIG_VALUE_BAZ_MODULE 1
>>>
>>> We can use this:
>>>
>>> if (config_defined(CONFIG_FOO) && some_expr) {
>>>    panic("Oh no.");
>>> }
>>
>> Well, in that case you could use Willy's magic hack:
>>
>> #define config_defined(x)      (x - 0)
>>
>> Which isn't a bad alternative to defining a whole pile of new symbols...
>>
>
> That can *strongly* be argued with.
>
> In particular, the use of #ifdef is crap to begin with.  Using #if 
> even for the preprocessor makes it possible to trap misspellings. 

Yes, I'd agree if we were starting from scratch.  But given that we 
can't get rid of CONFIG_* and their dubious semantics, we just have to 
make do.

But typo-detection *would* be very nice: I can never remember if its 
CONFIG_MEMORY_HOTPLUG or CONFIG_HOTPLUG_MEMORY.

    J
