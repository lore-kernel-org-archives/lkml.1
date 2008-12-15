Return-Path: <linux-kernel-owner+w=401wt.eu-S1752064AbYLOIUC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbYLOIUC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 03:20:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbYLOITx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 03:19:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:43977 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbYLOITx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 03:19:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,223,1228118400"; 
   d="scan'208";a="370912755"
From: "Shi, Alex" <alex.shi@intel.com>
To: Arjan van de Ven <arjan@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 15 Dec 2008 16:19:37 +0800
Subject: RE: is it a timer bug?
Thread-Topic: is it a timer bug?
Thread-Index: AclejD+ZMqzggnPpS66HEQxCCjAMoAAAMfkg
Message-ID: <F7C8A4D3A9905B45A80E4C194793FA6501C51D1352@PDSMSX501.ccr.corp.intel.com>
References: <F7C8A4D3A9905B45A80E4C194793FA6501C51D1271@PDSMSX501.ccr.corp.intel.com>
 <20081215090925.7a8f5c6d@infradead.org>
In-Reply-To: <20081215090925.7a8f5c6d@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id mBF8K8i3010379

OK, but my machine is not a production machine. 
A, 2.6.28-rc8 with tickles and highres
     PowerTOP version 1.9       (C) 2007 Intel Corporation

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        (65.1%)
C1                0.0ms ( 0.0%)
C2              105.8ms (34.9%)



Wakeups-from-idle per second :  3.8     interval: 5.0s
no ACPI power usage estimate available
B, 2.6.28-rc8 with tickless only 
     PowerTOP version 1.9       (C) 2007 Intel Corporation

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        (14.0%)
C1                0.0ms ( 0.0%)
C2                3.4ms (86.0%)



Wakeups-from-idle per second : 255.6    interval: 5.0s
no ACPI power usage estimate available

Top causes for wakeups:
  87.9% (267.6)       <interrupt> : extra timer interrupt
C, 2.6.27 with tickless only: 
    PowerTOP version 1.9       (C) 2007 Intel Corporation

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        (53.8%)         2.53 Ghz     0.0%
C1                0.0ms ( 0.0%)         2.53 Ghz    87.5%
C2              243.0ms (46.2%)         2.40 Ghz     0.0%
                                        1.60 Ghz    12.5%


Wakeups-from-idle per second :  2.2     interval: 30.0s
no ACPI power usage estimate available
I have checked the /proc/interrupts, the interrupt 0 is really triggered too much times. 
Brgs 
Alex 

>-----Original Message-----
>From: Arjan van de Ven [mailto:arjan@infradead.org]
>Sent: 2008Äê12ÔÂ15ÈÕ 16:09
>To: Shi, Alex
>Cc: linux-kernel@vger.kernel.org
>Subject: Re: is it a timer bug?
>
>On Mon, 15 Dec 2008 15:07:17 +0800
>"Shi, Alex" <alex.shi@intel.com> wrote:
>
>> I notice the timer interrupts is quit high on the 2.6.28-rc8 kernel
>> in my Nehalem machine. A, 180+/second timer interrupts in my Nehalem
>> machine with tickless enable. B, the timer interrupts reduce to
>> 10-/second with tickless and highres enable. On 2.6.27 kernel, the
>> timer interrupts can keep low with tickless kernel whenever the
>> highres feature is enable or not. So it is timer bug on my machine?
>>
>
>Hi,
>
>can you give us the powertop output of these production Core i7
>machines? That is the most likely way to get a clue about what is going
>on...
>
>Greetings,
>   Arjan van de Ven
>
>--
>Arjan van de Ven 	Intel Open Source Technology Centre
>For development, discussion and tips for power savings,
>visit http://www.lesswatts.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
