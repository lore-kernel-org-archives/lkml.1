Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbYLOL1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbYLOL1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 06:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbYLOL12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 06:27:28 -0500
Received: from mail.gmx.net ([213.165.64.20]:36763 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753116AbYLOL12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 06:27:28 -0500
X-Authenticated: #34473864
X-Provags-ID: V01U2FsdGVkX18x9Rd5YBMxXVqUoUREsDsDM2MFm4roc2viUL24yf
	7XsjzSUmq9RIjV
Message-ID: <49463F1C.1070401@gmx.de>
Date: Mon, 15 Dec 2008 12:27:24 +0100
From: Philipp Kohlbecher <xt28@gmx.de>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: documentation fix regarding boot protocol
References: <49454749.2030901@gmx.de> <1229332954.25349.78.camel@zakaz.uk.xensource.com>
In-Reply-To: <1229332954.25349.78.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> On Sun, 2008-12-14 at 18:50 +0100, Philipp Kohlbecher wrote:
>> Documentation/x86/boot.txt describes payload_offset as the offset
>> from the end of the real-mode code. In fact, it is more accurately
>> described as the offset from the beginning of the protected-mode
>> code, as (a) this is how it is actually calculated and (b) the padding
>> after the real-mode code is not included in the offset.
>>
>> Signed-off-by: Philipp Kohlbecher <xt28@gmx.de>
> 
> Acked-by: Ian Campbell <ijc@hellion.org.uk>
> 
> The padding after the real-mode code which you mention is just the
> implicit padding because the size of the real-mode code is specified in
> sectors (and hence is rounded up), isn't it?

Yes, it is. You can certainly view the padding as an implicit part of 
the real-mode code, which is why the current statement isn't wrong -- 
there is simply room for improvement.

> Is it worth saying that the payload_offset is relative to (setup_sectors
> +1) * 512?

The fact that the protected-mode code starts at that address is already 
mentioned under the heading "LOADING THE REST OF THE KERNEL" (where 
protected mode is for some reason referred to as "non-real-mode").
(Please note that the header field is called "setup_sects", not 
"setup_sectors".)

>> ---
>>
>>   Documentation/x86/boot.txt |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
>> index 83c0033..414b6fb 100644
>> --- a/Documentation/x86/boot.txt
>> +++ b/Documentation/x86/boot.txt
>> @@ -537,8 +537,8 @@ Type:		read
>>   Offset/size:	0x248/4
>>   Protocol:	2.08+
>>
>> -  If non-zero then this field contains the offset from the end of the
>> -  real-mode code to the payload.
>> +  If non-zero then this field contains the offset from the beginning
>> +  of the protected-mode code to the payload.
>>
>>     The payload may be compressed. The format of both the compressed and
>>     uncompressed data should be determined using the standard magic
>>

