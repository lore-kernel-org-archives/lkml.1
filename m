Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbYEXQkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbYEXQkt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 12:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756405AbYEXQkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 12:40:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:45569 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347AbYEXQkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 12:40:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Gh1uyrcHL4suiTISTITCUzPEidofG2An/YrQI426qp0H6eX2+DYWUg8Z+wOfbJVPaEQWZxBCDyvN8uUC2OIZCWa66pbPJwMw/0lsgefA57VMEacqYZdlKYj2N8q1q8G8D5N/1arm/zYSQ7YabvOW3GeaJQQ5LFCUMUTeP079Kl8=
Message-ID: <7b9198260805240940v46db928ak9bcacf9363c46d41@mail.gmail.com>
Date: Sat, 24 May 2008 17:40:37 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Sam Ravnborg" <sam@ravnborg.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Steve French" <smfrench@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <48383C26.5040106@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com>
	 <4837AAE2.9090102@zytor.com>
	 <20080524064201.GA4133@uranus.ravnborg.org>
	 <4837E89D.9040008@goop.org>
	 <20080524112704.GA7292@uranus.ravnborg.org>
	 <483827CE.9080200@goop.org>
	 <20080524153611.GA13890@uranus.ravnborg.org>
	 <48383830.6060504@goop.org>
	 <19f34abd0805240857l57e667fdicb240baf898f6296@mail.gmail.com>
	 <48383C26.5040106@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/24 Jeremy Fitzhardinge <jeremy@goop.org>:
> Vegard Nossum wrote:
>>
>> Why not use all-lowercase config_* names? It seems elegant, and fits
>> in with the notion that these are to be used not as macros, but as
>> ordinary constants.
>>
>
> We tend to use all caps for symbolic constants, even if they're enums.
>
>> (The only disadvantage I can see is that they will stand out less. But
>> I don't know how great the disadvantage is.)
>>
>> You could even go further and make them real constants, something
>> along the lines of:
>>
>> enum config_value { no, yes, mod };
>>
>> static const enum config_value config_lockdep_support = yes;
>>
>
> Well, you could use "enum { config_foo = 0/1 }"  to define a proper C
> constant.
>
> But it means you could only use them in C, not in CPP or asm expressions.
>
>   J

Hi,

A thought occurred to me that we may be able to used some preprocessor
magic and do this:

#define config_defined(x) CFGVAL_## x

Which means that, if we get Kconfig to produce:

#define CFGVAL_CONFIG_FOO 0
#define CFGVAL_CONFIG_VALUE_BAR 1
#define CFGVAL_CONFIG_VALUE_BAZ_MODULE 1

We can use this:

if (config_defined(CONFIG_FOO) && some_expr) {
   panic("Oh no.");
}

Thoughts?

-- 
Tom Spink
