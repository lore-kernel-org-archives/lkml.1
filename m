Return-Path: <linux-kernel-owner+w=401wt.eu-S1752021AbYLHIEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbYLHIEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 03:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbYLHIEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 03:04:35 -0500
Received: from mail-gx0-f18.google.com ([209.85.217.18]:54896 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbYLHIEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 03:04:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=w5f0lTH8ihZj8JS7x3acgSMAMLGoK2UyP/B8F5eMMDRHFIPlca2qik//uQkp+RCmQ2
         JY/L4RQSlX3WN96JDFcwlOaJ+/F+SoQ8VO8f0loMhPaXPxj2WyeBnuouuzzmTy7z+aTV
         iHpEx+/3WhWZy/JRlO4bBCGlMhpvknUEs3wH4=
Message-ID: <12bfabe40812080004p7438744eqeb884b42673bd73c@mail.gmail.com>
Date: Mon, 8 Dec 2008 09:04:32 +0100
From: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
To: "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       "Andi Kleen" <ak@linux.intel.com>
In-Reply-To: <493CCFE4.2080802@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>
	 <493AE770.5030507@shaw.ca>
	 <12bfabe40812061343j400f55d8r43571c8bd514adde@mail.gmail.com>
	 <493AF2EA.4030601@shaw.ca>
	 <12bfabe40812061416u1b6f800dn7261beae5ce36b2f@mail.gmail.com>
	 <493B4242.1040202@shaw.ca>
	 <12bfabe40812071355r65c13e52g5f3d94d3b060c939@mail.gmail.com>
	 <20081207141337.588aede5@infradead.org>
	 <12bfabe40812072248n3c931ce0hf030b3ac758026d4@mail.gmail.com>
	 <493CCFE4.2080802@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2008 at 8:42 AM, Hidetoshi Seto
<seto.hidetoshi@jp.fujitsu.com> wrote:
> Giangiacomo Mariotti wrote:
>> I noticed something else, which though may be due to my inexperience
>> with mce messages. In my directory /sys/devices/system/machinecheck
>> there are machinecheck0-7(one for each logical cpu of my system I
>> presume). Having received the MCE log always for cpu 0, I went to look
>> inside dir machinecheck0 and I found bank0-5ctl. So now my question
>> is, why do I receive MCE logs about bank 6, if my cpus don't have a
>> bank 6? Does that count start from 1? Or am I missing something else?
>
> Answer would be in the following commit:
>
>> commit 8edc5cc5ec880c96de8e6686fb0d7a5231e91c05
>> Author: Venki Pallipadi <venkatesh.pallipadi@intel.com>
>> Date:   Mon May 12 15:43:34 2008 +0200
>>
>>     x86: remove 6 bank limitation in 64 bit MCE reporting code
> (snip)
>>     The patch below does not create sysfs control (bankNctl) for banks
>>     higher than 6 as well. That needs some pre-cleanup in /sysfs mce layout,
>>     removal of per cpu /sysfs entries for bankctl as they are really global
>>     system level control today. That change will follow. This basic change
>>     is critical to report the detailed errors on banks higher than 6.
>
> So there are 6 sysfs control(bank0-5ctl) even if your cpu have more banks.
>
> Old kernel with bank limitation will say:
> "MCE: warning: using only %d banks\n"
> And it seems that old kernel will ignore records in banks higher than 6.
>
> Thanks,
> H.Seto
>
>
I see, thanks for the info.
I still don't quite understand the logic behind this exception. It
happens always only once per boot, right after booting always at [
301.7320xx], which clearly means that it's always triggered by the
same instruction/s. It's about a "Generic CACHE Level-2 Data-Write
Error", yet after that moment it never happens again until the next
boot at the same relative time. The cache has an hardware problem, the
process context is corrupted, but still after that single message I
don't have any problem, my system works normally, even under very high
pressure on cpu and memory. Is this normal? Should I try to limit the
number of cpu used to only 1(cpu0) on bios and disable hyperthreading?
That way I'd have a single physical and logical cpu, so probably if it
has an hardware problem on the cache, the heaven will fall?
