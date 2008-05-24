Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbYEXOgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbYEXOgg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 10:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbYEXOg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 10:36:29 -0400
Received: from gw.goop.org ([64.81.55.164]:37813 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbYEXOg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 10:36:28 -0400
Message-ID: <483827CE.9080200@goop.org>
Date: Sat, 24 May 2008 15:35:58 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Steve French <smfrench@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com> <48374D3F.1080502@zytor.com> <20080524054301.GA3773@uranus.ravnborg.org> <4837AAE2.9090102@zytor.com> <20080524064201.GA4133@uranus.ravnborg.org> <4837E89D.9040008@goop.org> <20080524112704.GA7292@uranus.ravnborg.org>
In-Reply-To: <20080524112704.GA7292@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> I assume you wanted to say:
>   
>>    #undef  CONFIG_FOO
>>    #define CFG_FOO   1
>>    #define CONFIG_FOO_MODULE
>>    #define CFG_FOO_MODULE 1
>>     
> Because then the CONFIG_* is not changed
> and we do not want to change that.
>   

Yeah, I didn't intend to change the meaning of CONFIG_FOO.

> I'm not fully convinced about:
>   
>>    #define CFG_FOO   1
>>     
> But on the other hand it is only in odd
> cases we distingush between built-in and module.
> So it makes most sense.
>   

I think CONFIG_ and CFG_ should be exact parallels, so if CONFIG_FOO is 
undefined, CFG_FOO should be 0.

>> Not sure what CFG_* should be for string/numeric options.  Probably "1" 
>> if the value is defined, "0" if not, with CONFIG_* being the actual 
>> value (so a CONFIG_ value of 0 is distinguishable from not defined).
>>     
> For non-boolean/tristate values we simply skip CFG_ values - thats
> the most simple approach.

I suppose, but it might be useful to know whether a constant is present:

	if (CFG_THINGY_LIMIT && x > CONFIG_THINGY_LIMIT) {...}

(which fails if CONFIG_THINGY_LIMIT is undefined, so I guess it still 
doesn't work very well).

    J
