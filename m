Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbZKEGrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbZKEGrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 01:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbZKEGrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 01:47:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:20923 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756025AbZKEGrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 01:47:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,684,1249282800"; 
   d="scan'208";a="566715594"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Gleb Natapov <gleb@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 5 Nov 2009 14:44:51 +0800
Subject: RE: [PATCH 02/11] Add "handle page fault" PV helper.
Thread-Topic: [PATCH 02/11] Add "handle page fault" PV helper.
Thread-Index: AcpcQlVUfBflC1Y3SQey9svSowWv1ABoB5bw
Message-ID: <0A882F4D99BBF6449D58E61AAFD7EDD6339E7098@pdsmsx502.ccr.corp.intel.com>
References: <1257076590-29559-1-git-send-email-gleb@redhat.com>
 <1257076590-29559-3-git-send-email-gleb@redhat.com>
 <20091102092214.GB8933@elte.hu> <4AEF2D0A.4070807@redhat.com>
 <4AEF3419.1050200@redhat.com> <4AEF6CC3.4000508@redhat.com>
 <4AEFB823.4040607@redhat.com>
In-Reply-To: <4AEFB823.4040607@redhat.com>
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
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nA56lU16000510

>From: Avi Kivity
>Sent: 2009Äê11ÔÂ3ÈÕ 12:57
>
>On 11/03/2009 01:35 AM, Rik van Riel wrote:
>>> We can't add an exception vector since all the existing 
>ones are either
>>> taken or reserved.
>>
>>
>> I believe some are reserved for operating system use.
>
>Table 6-1 says:
>
>   9 |  | Coprocessor Segment Overrun (reserved)  |  Fault |  No  | 
>Floating-point instruction.2
>   15 |  ¡ª |  (Intel reserved. Do not use.) |   | No |
>   20-31 |  ¡ª | Intel reserved. Do not use.  |
>   32-255 |  ¡ª  | User Defined (Non-reserved) Interrupts |  Interrupt  
>|   | External interrupt or INT n instruction.
>
>So we can only use 32-255, but these are not fault-like 
>exceptions that 
>can be delivered with interrupts disabled.
>

would you really want to inject a fault-like exception here? Fault
is architurally synchronous event while here apf is more like an 
asynchronous interrupt as it's not caused by guest itself. If 
guest is with interrupt disabled, preemption won't happen and 
apf path just ends up "wait for page" hypercall to waste cycles.

Thanks,
Kevinÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
