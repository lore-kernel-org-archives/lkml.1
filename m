Return-Path: <linux-kernel-owner+w=401wt.eu-S965213AbXIKTHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965213AbXIKTHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965033AbXIKTCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:02:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63252 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933616AbXIKTCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:02:52 -0400
Message-ID: <46E6E657.2050201@anagramm.de>
Date: Tue, 11 Sep 2007 21:02:47 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Dag-Erling_Sm=F8rgrav?= <des@linpro.no>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC+PATCH] RTC calibration
References: <ujrmyvt2tyy.fsf@false.linpro.no> <46E6A737.6080805@anagramm.de>	<ujrabrt2qkt.fsf@false.linpro.no> <46E6B617.7030106@anagramm.de> <ujr1wd52npl.fsf@false.linpro.no>
In-Reply-To: <ujr1wd52npl.fsf@false.linpro.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX18qNva7XtFHKvz5m/M4NoUCfSBGHlCyxA0MiAk
 CNJWxS30EaHrX73BLXQXvx2jRkTATj07M5y5ntz/l7+ihrBeSG
 dl+BVexPCFaSU1zxhj4fA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dag-Erling Smørgrav schrieb:
 > Clemens Koller <clemens.koller@anagramm.de> writes:
 >> I am talking about _how_ the calibration register is addressed from
 >> userspace. It's a simple register, some bits at address 7 and I would
 >> expect to read/modify/write registers to do all the things you want
 >> to do. Register access in userspace doesn't put any limitation
 >> to applications.
 >
 > It requires the application to know the hardware intimately.

That's right... there is no need to put that into the kernel and
hide this trivial functionality from userspace.

 > Calibration of the M41T11 is implemented using the lower 6 bits of
 > register 7; this is not necessarily the case for other existing or
 > future chips.

I've read the datasheet.
Your driver is specific for the M41T11 chip as mentioned in your
first mail, isn't it? If any future driver comes up with 8 bits
you wouldn't need to change a generic interface to read/modify/write
these 8 bits, right?

 > Let's say I normalize this to [-128;127];

Why do any normalization in the driver? That's what userspace can do
in any way it might be necessary to do.

 >> Having only incs and decs without getting the actual value back seems
 >> to be an absolutely unnecessary limitation here.
 >> You cannot get the current value back to see if it's i.e. in saturation in
 >> a way that it doesn't make sense to inc/decrement it further or in bigger steps
 >> or reset it to zero...
 >
 > The driver will return EINVAL if you try to increment or decrement the
 > calibration register beyond its limits.

That behaviour seems also odd to me...
I can increment/decrement by an unknown number and then I get an EINVAL.
And I cannot reset it to some default value easily.
I still don't see any reason to implement relative changes to an otherwise
unknown value if it's possible to give absolute values to work with.

Well, that's my opinion, my five cents... I don't want to get into a lenghtly
discussion... I just used common sense how a interface to a register might
look like and your way of a relative manipulation just looks very uncommon
to me, having seen lot's of drivers.

Best regards,

Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com

