Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbZFBIO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbZFBIO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 04:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757549AbZFBIOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 04:14:45 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:23934 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757308AbZFBIOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 04:14:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=IebQyEG3S/NP3MG6DLRYnwhGqXQmYT80PEapW+j0hJoBBxcN6acxJVnX7p4M5/elF8
         +JgyZJfRL8M0NAlFU0ToinPLPQAThIC+OXVsU9B8FqWpNMUMIim0oPzjK02P4Qpcjull
         Z+97uGY1++hqTZR68LV1INZvivWA/Uw/570HQ=
MIME-Version: 1.0
Reply-To: Tobias_Mueller@twam.info
In-Reply-To: <4A24965C.2020901@cosmicpenguin.net>
References: <17be05570905230453i591eb83bnb359f6365c109718@mail.gmail.com>
	 <20090526151621.a7446c60.akpm@linux-foundation.org>
	 <17be05570905301105h395689ja33afa96e7751381@mail.gmail.com>
	 <20090601165457.a1cc1025.akpm@linux-foundation.org>
	 <20090601200821.62b04e43@mycelium.queued.net>
	 <4A24965C.2020901@cosmicpenguin.net>
Date: Tue, 2 Jun 2009 10:14:45 +0200
X-Google-Sender-Auth: c486ddf2d798700c
Message-ID: <17be05570906020114k7f2a3096h48335d509951cf90@mail.gmail.com>
Subject: Re: [PATCH v2 001/001] gpio: AMD CS5535/CS5536 GPIO driver
From: =?UTF-8?Q?Tobias_M=C3=BCller?= <Tobias_Mueller@twam.info>
To: jordan@cosmicpenguin.net
Cc: Andres Salomon <dilinger@collabora.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>, david-b@pacbell.net,
       gardner.ben@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/2 Jordan Crouse <jordan@cosmicpenguin.net>:
> Andres Salomon wrote:
>> As far as Tobias's driver, one major difference between our drivers is
>> that mine doesn't grab the entire PCI device.  This is because other
>> drivers (ie, the MFGPT driver) will want to share the PCI device.
>
> Also SMBUS. In fact, they *must* share the PCI device if they all want to
> play well together, so that alone would probably push us toward Andre's
> patch, once it gets clean.

I had SMBUS and my driver tested in parallel and there I didn't found any
problems. But I would be fine if we would use Andre's patch. I haven't know
about, so that's why I tried my own. :)

I see some other problem's on Andre's patch:
- He allows the use of PIN 23 which is reserved
- No special handling is done for 28, which is a GPIO, but
  serves as Power Button as well
- OUT_AUX1/OUT_AUX2 should be disabled by default
  if pin is configured as in output
- IN_AUX should be disabled by default is pin is
  configured as in input

And, if I request a GPIO by userspace via sysfs, on my system it's an
input pin by default. So my driver initializes a GPIO as an input by default.
But I don't know if this is default or system specific. I didn't found anything
about this in the gpio docs.

So maybe we should decide whether we take Andre's or my approach
and then adjust it.

Tobias
