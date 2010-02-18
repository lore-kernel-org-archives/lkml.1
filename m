Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab0BRU0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 15:26:22 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43892 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993Ab0BRU0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 15:26:20 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: roel kluin <roel.kluin@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
       "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Thu, 18 Feb 2010 14:25:56 -0600
Subject: RE: [PATCH] video_device: don't free_irq() an element past array
 	vpif_obj.dev[] and fix test
Thread-Topic: [PATCH] video_device: don't free_irq() an element past array
 	vpif_obj.dev[] and fix test
Thread-Index: Acqw1VPjb5RciSatQOCIsbikCmIJ/wAAmKzg
Message-ID: <A69FA2915331DC488A831521EAE36FE40169C5CBD8@dlee06.ent.ti.com>
References: <4B714E15.4020909@gmail.com>
 <A69FA2915331DC488A831521EAE36FE40169C5C9B5@dlee06.ent.ti.com>
 <25e057c01002181202v346f488bk571d099f679fea83@mail.gmail.com>
In-Reply-To: <25e057c01002181202v346f488bk571d099f679fea83@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o1IKR5mE010947



>>>- Â  Â  Â if (!std_info)
>>>+ Â  Â  Â if (!std_info->stdid)
>>> Â  Â  Â  Â  Â  Â  Â  return -1;
>>>
>> This is a NACK. We shouldn't check for stdid since the function is
>supposed
>> to update std_info. So just remove
>>
>> if (!std_info)
>> Â  Â  Â  Â return -1;
>
>I don't see how std_info could get updated. consider the loop in case
>std_info->stdid equals 0:

Ok. You are right! The ch_params[] is a table for keeping the information
about different standards supported. For a given stdid in std_info, the function matches the stdid with that in the table and get the corresponding entry.


>> I am okay with the below change. So please re-submit the patch with the
>> above change and my ACK.
>>
>> Thanks
>>
>> Murali
>>
>
>>>+ Â  Â  Â if (k == VPIF_DISPLAY_MAX_DEVICES)
>>>+ Â  Â  Â  Â  Â  Â  Â k = VPIF_DISPLAY_MAX_DEVICES - 1;
>
>actually I think this is still not right. shouldn't it be be
>
>k = VPIF_DISPLAY_MAX_DEVICES - 1;

What you mean here? What you suggest here is same as in your patch, right?

Murali
>
>> are you using this driver in your project?
>
>No, I just found this in the code.
>
>Thanks, Roel
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
