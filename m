Return-Path: <linux-kernel-owner+w=401wt.eu-S1752174AbXLLVTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbXLLVTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 16:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbXLLVTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 16:19:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47619 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbXLLVTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 16:19:00 -0500
Message-ID: <47604C6F.1090409@zytor.com>
Date: Wed, 12 Dec 2007 13:02:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: =?ISO-8859-15?Q?Alejandro_Riveira_Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl>	<20071212004316.079e3a05@Varda>	<475F227D.7050203@keyaccess.nl> <20071212010928.3c763ccd@Varda> <475F2846.1010402@keyaccess.nl>
In-Reply-To: <475F2846.1010402@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 12-12-07 01:09, Alejandro Riveira Fernández wrote:
> 
>>>>  On my AMD 3800 X2 (2000MHz) ULi M1697 2.6.24-rc5 i get:
>>>>
>>>>  cycles: out 1844674407370808, in 1844674407369087
>>>>  
>>>> It is not constant but variations are not significant afaics
>>> Eh, oh, I guess you need to compile as a 32-bit binary...
>>  
>>  I tried without -O2 as Nigel Cunningham...
>>
>>  cycles: out 1562, in 865
>>  cycles: out 1562, in 866
>>  cycles: out 1555, in 858
>>  cycles: out 1562, in 866
>>  
>>  With -m32 -O2
>>  cycles: out 1566, in 876
>>  cycles: out 1555, in 865
>>  cycles: out 1594, in 931
>>  cycles: out 1559, in 874
> 
> Great, thanks much for reporting. Sort of interesting in itself that 
> without -O2 you do still get correct results on 64-bit but for some 
> other time.
> 
> You're the first one to go significantly below 1 us it seems.

Make sure the CPU is actually running at full frequency.

It probably would have been better to have used gettimeofday() around a 
sufficiently big loop, so that we would have gotten wall time rather 
than cycles.

	-hpa
