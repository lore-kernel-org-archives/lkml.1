Return-Path: <linux-kernel-owner+w=401wt.eu-S1759951AbZKLCNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759951AbZKLCNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 21:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759911AbZKLCNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 21:13:20 -0500
Received: from mga14.intel.com ([143.182.124.37]:50662 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759909AbZKLCNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 21:13:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,726,1249282800"; 
   d="scan'208";a="210524093"
From: "Ma, Ling" <ling.ma@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 12 Nov 2009 10:12:14 +0800
Subject: RE: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
 fast string.
Thread-Topic: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
 fast string.
Thread-Index: AcpjJbUIZjA1fJ8aQnK49eKCvasZtwAEkiXw
Message-ID: <8FED46E8A9CA574792FC7AACAC38FE7714FE8306B3@PDSMSX501.ccr.corp.intel.com>
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com>
 <4AF457E0.4040107@zytor.com> <4AF4784C.5090800@zytor.com>
 <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com>
 <4AF7C66C.6000009@zytor.com> <20091109080830.GI453@elte.hu>
 <8FED46E8A9CA574792FC7AACAC38FE7714FE830398@PDSMSX501.ccr.corp.intel.com>
 <20091111071832.GA3156@elte.hu>
 <8FED46E8A9CA574792FC7AACAC38FE7714FE830400@PDSMSX501.ccr.corp.intel.com>
 <4AFB46F6.9050902@zytor.com>
In-Reply-To: <4AFB46F6.9050902@zytor.com>
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
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nAC2Dd16013630

>-----Original Message-----
>From: H. Peter Anvin [mailto:hpa@zytor.com]
>Sent: 2009Äê11ÔÂ12ÈÕ 7:21
>To: Ma, Ling
>Cc: Ingo Molnar; Ingo Molnar; Thomas Gleixner; linux-kernel
>Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by fast
>string.
>
>On 11/10/2009 11:57 PM, Ma, Ling wrote:
>> Hi Ingo
>>
>> This program is for 64bit version, so please use 'cc -o memcpy  memcpy.c -O2
>-m64'
>>
>
>I did some measurements with this program; I added power-of-two
>measurements from 1-512 bytes, plus some different alignments, and found
>some very interesting results:
>
>Nehalem:
>	memcpy_new is a win for 1024+ bytes, but *also* a win for 2-32
>	bytes, where the old code apparently performs appallingly bad.
>
>	memcpy_new loses in the 64-512 byte range, so the 1024
>	threshold is probably justified.
>
>Core2:
>	memcpy_new is a win for <= 512 bytes, but a lose for larger
>	copies (possibly a win again for 16K+ copies, but those are
>	very rare in the Linux kernel.)  Surprise...
>
>	However, the difference is very small.
>
>However, I had overlooked something much more fundamental about your
>patch.  On Nehalem, at least *it will never get executed* (except during
>very early startup), because we replace the memcpy code with a jmp to
>memcpy_c on any CPU which has X86_FEATURE_REP_GOOD, which includes Nehalem.
>
>So the patch is a no-op on Nehalem, and any other modern CPU.

[Ma Ling]
It is good for modern CPU, our original intention is also to introduce movsq for Nehalem, above method is more smart.

>Am I guessing that the perf numbers you posted originally were all from
>your user space test program?

[Ma Ling] 
Yes, they are all from this program, and I'm confused about measurement values will be different for only one case after multiple tests.
(3 times at least on my core2 platform).

Thanks
Ling
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
