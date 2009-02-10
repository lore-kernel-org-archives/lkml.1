Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbZBJKem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbZBJKem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 05:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbZBJKec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 05:34:32 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:27901 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZBJKeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 05:34:31 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <49915832.1090501@tremplin-utc.net>
Date: Tue, 10 Feb 2009 11:34:26 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Palatis Tseng <palatis@gmail.com>,
       Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
References: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com> <498D9F02.9000107@tremplin-utc.net> <498E46F2.1020401@gmail.com> <4990BE23.8080301@tremplin-utc.net> <4990DEFD.4010700@gmail.com>
In-Reply-To: <4990DEFD.4010700@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(putting back the cc's, please keep them when answering)

Palatis Tseng schreef:
> Éric Piel 提到:
>> No problem, the patch from Giuseppe will get the axex fine :-)
>>
>> However, could you let use know if you too, on your laptop, have huge
>> fluctuations even when the laptop is not moving? Could you give an idea
>> of the minimum and maximum values of each axis when the laptop is set
>> normally on the desk without touching it?
>>
>> Thanks,
>> Eric
> I took a look at the patch but my axis on dv5 is Y_inverted (instead of
> X_inverted.) i patched my lis3lv02d.c and added:
> 
> === cut here ===
>    AXIS_DMI_MATCH("HPDV5", "HP Pavilion dv5", y_inverted),
> === cut here ===
> 
> and neverball worked just correct with it so i'm kinda sure my patch
> about the axis should be correct.
> 
> i've also tested with x_inverted, but whenever i evaluate the left side
> of my notebook the ball goes to the left side too which is not real-world
> behavier.
> 
> mine is a HP Pavilion dv5 1003ax with AMD PUMA platform.
> `dmidecode | grep "Product Name" says:
> (under "System Information"...)
>    Product Name: HP Pavilion dv5 Notebook PC
Giuseppe,
Palatis mentions that on his laptop the sensor is actually y_inverted.
Could you check your laptop? In particular it would be nice if you could
 describe the values for the four positions defined in the documentation
file. BTW, what is the exact version of your laptop? Is it the same as
Palatis?

Palatis, could you let us know if you also have a lot of "noise" in the
values. That is, if when using jstest /dev/input/js0 you see big changes
in the values. Is it like on Giuseppe's laptop of around 8000?

Moreover I'm wondering if this could be an error on LSB/MSB ordering.
Maybe looking at the raw values (cat
/sys/devices/platform/lis3lv02d/position) would give more insight...

See you,
Eric
