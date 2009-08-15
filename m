Return-Path: <linux-kernel-owner+w=401wt.eu-S1752639AbZHOGVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbZHOGVg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 02:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbZHOGVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 02:21:35 -0400
Received: from smtp.nokia.com ([192.100.122.230]:43409 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbZHOGVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 02:21:34 -0400
Message-ID: <4A8653DC.3050102@gmail.com>
Date: Sat, 15 Aug 2009 09:21:16 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Zan Lynx <zlynx@acm.org>
CC: Linus Walleij <linus.ml.walleij@gmail.com>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tim Bird <tim.bird@am.sony.com>, kernel@pengutronix.de
Subject: Re: New fast(?)-boot results on ARM
References: <20090814170228.GM13320@pengutronix.de> <4A85AAC4.7050505@acm.org>	 <20090814185731.GN13320@pengutronix.de> <63386a3d0908141401t6050f39ey8d85213aeccf748a@mail.gmail.com> <4A85D89F.8080900@acm.org>
In-Reply-To: <4A85D89F.8080900@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 15 Aug 2009 06:21:18.0686 (UTC) FILETIME=[99C52FE0:01CA1D70]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2009 12:35 AM, Zan Lynx wrote:
> Linus Walleij wrote:
>> 2009/8/14 Robert Schwebel <r.schwebel@pengutronix.de>:
>>> On Fri, Aug 14, 2009 at 12:19:48PM -0600, Zan Lynx wrote:
>>
>>>>> That's factor 70 away from the 110 ms boot time Tim has talked about
>>>>> some days ago (and he measured on an ARM cpu which had almost half
>>>>> the speed of this one), and I'm wondering what we can do to improve
>>>>> the boot time.
>>>> 2.4s in uncompression? That seems like an obvious target for
>>>> improvement.
>>> Indeed, we'll check that.
>>
>> We got rid of uncompression on a flash-based system vastly improving
>> boot time. The reason is that compressed kernels are faster only when
>> the throughput to the persistent storage is lower than the decompression
>> throughput, and on typical embedded systems with DMA the throughput to
>> memory outperforms the CPU-based decompression.
>
> I thought of another thing to check related to slow decompression. If
> the kernel, bootloader or hardware is in charge of setting CPU power and
> speed scaling, then you should check that it boots with the CPU set at
> maximum speed instead of slowest.

zlib is slow on decompression, and lzo is much faster. So if you implement
lzo compression, you'll probably speed things up a little as well. I saw
some discussions about this on lkml. Having no compression at all may also
be a good thing to try.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
