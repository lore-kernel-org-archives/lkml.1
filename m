Return-Path: <linux-kernel-owner+w=401wt.eu-S1758533AbZFOIko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533AbZFOIko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbZFOIkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:40:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54354 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZFOIkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:40:36 -0400
Message-ID: <4A3608F9.20203@jp.fujitsu.com>
Date: Mon, 15 Jun 2009 17:40:25 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: huang ying <huang.ying.caritas@gmail.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@linux.intel.com>, Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH 02/16] x86, mce: call-in should be after updating 	global_nwo
References: <4A3601BF.2000201@jp.fujitsu.com> <4A36041C.9050202@jp.fujitsu.com> <851fc09e0906150126x4bb003flbf099aff0eed2a66@mail.gmail.com>
In-Reply-To: <851fc09e0906150126x4bb003flbf099aff0eed2a66@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

huang ying wrote:
> 2009/6/15 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>:
>> At the beginning of Monarch synchronization, processors wait until
>> all of them have entered the exception handler and then check the
>> global_nwo to determine if any of them saw a fatal event.
>>
>> However since current code does call-in before updating global_nwo,
>> it might happen that the global_nwo does not reflect some of local
>> nwo at the time.  This might break printing corrected errors not
>> handled yet on panic.
> 
> This is almost same as the patch that I just posted. I think this is
> because it trigger a failure in mce-test suite, and we both find the
> failure.

That's right.

> But your patch lacks memory barrier between mce_callin and global_nwo
> updating/reading. Atomic operations does not imply memory barrier.

You are right.  I agree that your patch is better fix.

It seems my patch includes cleanup for mce_start(), so I'll extract it
and make another patch soon.


Thanks,
H.Seto

