Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773AbYEXKHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773AbYEXKHB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 06:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbYEXKGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 06:06:52 -0400
Received: from gw.goop.org ([64.81.55.164]:38006 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158AbYEXKGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 06:06:51 -0400
Message-ID: <4837E89D.9040008@goop.org>
Date: Sat, 24 May 2008 11:06:21 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Steve French <smfrench@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com> <48374D3F.1080502@zytor.com> <20080524054301.GA3773@uranus.ravnborg.org> <4837AAE2.9090102@zytor.com> <20080524064201.GA4133@uranus.ravnborg.org>
In-Reply-To: <20080524064201.GA4133@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Fri, May 23, 2008 at 10:42:58PM -0700, H. Peter Anvin wrote:
>   
>> Sam Ravnborg wrote:
>>     
>>>> *However*, the best would really be if we changed Kconfig to emit 
>>>> configuration constants what were 0/1 instead of undefined/defined. 
>>>> That way we could do:
>>>>
>>>> 	if (CONFIG_SOMETHING && foo) {
>>>> 		/* ... something ... */
>>>> 	} else if ((mode & S_IWUGO) == 0) {
>>>> 		/* ... */
>>>>         
>>> We could do that - but then it would need another
>>> name not to clash with all the places where we rely
>>> on CONFIG_FOO='n' => CONFIG_FOO is not defined.
>>>
>>> We could teach kconfig to emit something like:
>>> #define KFOO 0   (for the 'n' value)
>>> And 1 or 2 for the y and m values.
>>>
>>>       
>> I don't think we want to use "1 or 2"... I suspect we want to use the 
>> same booleans we currently have.
>>     
> I'm a bit dense (or I need more coffe - it's morning here).
> What "same booleans"?
>   

They should be plain 0/1 booleans.  For a bool/tristate option FOO, it 
would define:

Enabled y:

    #define CONFIG_FOO
    #define CFG_FOO   1
    #undef CONFIG_FOO_MODULE
    #define CFG_FOO_MODULE 0


Enabled m:

    #define CONFIG_FOO
    #define CFG_FOO   1
    #define CONFIG_FOO_MODULE
    #define CFG_FOO_MODULE 1


Disabled n:

    #undef CONFIG_FOO
    #define CFG_FOO   0
    #undef CONFIG_FOO_MODULE
    #define CFG_FOO_MODULE 0

Not sure what CFG_* should be for string/numeric options.  Probably "1" 
if the value is defined, "0" if not, with CONFIG_* being the actual 
value (so a CONFIG_ value of 0 is distinguishable from not defined).

    J
