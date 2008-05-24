Return-Path: <linux-kernel-owner+w=401wt.eu-S1761975AbYEXUrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761975AbYEXUrA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 16:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756689AbYEXUqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 16:46:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33247 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837AbYEXUqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 16:46:52 -0400
Message-ID: <48387DF0.7000600@zytor.com>
Date: Sat, 24 May 2008 13:43:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Tom Spink <tspink@gmail.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Steve French <smfrench@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com>	 <4837AAE2.9090102@zytor.com>	 <20080524064201.GA4133@uranus.ravnborg.org>	 <4837E89D.9040008@goop.org>	 <20080524112704.GA7292@uranus.ravnborg.org>	 <483827CE.9080200@goop.org>	 <20080524153611.GA13890@uranus.ravnborg.org>	 <48383830.6060504@goop.org>	 <19f34abd0805240857l57e667fdicb240baf898f6296@mail.gmail.com>	 <48383C26.5040106@goop.org> <7b9198260805240940v46db928ak9bcacf9363c46d41@mail.gmail.com> <48387CCB.1030801@goop.org>
In-Reply-To: <48387CCB.1030801@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Tom Spink wrote:
>> A thought occurred to me that we may be able to used some preprocessor
>> magic and do this:
>>
>> #define config_defined(x) CFGVAL_## x
>>
>> Which means that, if we get Kconfig to produce:
>>
>> #define CFGVAL_CONFIG_FOO 0
>> #define CFGVAL_CONFIG_VALUE_BAR 1
>> #define CFGVAL_CONFIG_VALUE_BAZ_MODULE 1
>>
>> We can use this:
>>
>> if (config_defined(CONFIG_FOO) && some_expr) {
>>    panic("Oh no.");
>> }
> 
> Well, in that case you could use Willy's magic hack:
> 
> #define config_defined(x)      (x - 0)
> 
> Which isn't a bad alternative to defining a whole pile of new symbols...
> 

That can *strongly* be argued with.

In particular, the use of #ifdef is crap to begin with.  Using #if even 
for the preprocessor makes it possible to trap misspellings.

	-hpa
