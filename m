Return-Path: <linux-kernel-owner+w=401wt.eu-S1760871AbYEHCRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871AbYEHCRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 22:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbYEHCR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 22:17:27 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:54812 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065AbYEHCR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 22:17:26 -0400
Message-ID: <482262C7.9020307@keyaccess.nl>
Date: Thu, 08 May 2008 04:17:43 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] x86: introduce a new Linux defined feature flag for PAT
 support
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl> <482233F0.7040000@zytor.com> <48224318.8020209@keyaccess.nl> <48224361.5080102@zytor.com> <48224507.8010102@keyaccess.nl> <alpine.LFD.1.10.0805071716060.3024@woody.linux-foundation.org> <48224930.9030901@keyaccess.nl> <48225DEC.2030502@keyaccess.nl> <alpine.LFD.1.10.0805071857430.3024@woody.linux-foundation.org> <4822614B.6080706@zytor.com>
In-Reply-To: <4822614B.6080706@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08-05-08 04:11, H. Peter Anvin wrote:

> Indeed it wasn't, and at least I have no interest of maintaining what is 
> in effect an in-kernel version of x86info(1).
> 
> *Certainly* I don't want anything like this crap:
> 
>> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
>> index 277446c..6ee3efb 100644
>> --- a/arch/x86/mm/pat.c
>> +++ b/arch/x86/mm/pat.c
>> @@ -43,7 +43,7 @@ static int pat_known_cpu(void)
>>     if (!pat_wc_enabled)
>>         return 0;
>>
>> -    if (cpu_has_pat)
>> +    if (cpu_has_pat && cpu_has_pat_good)
>>         return 1;

if (cpu_has_pat_good) would have been the exact same as now. Feel free
to drop the cpu_has_pat one but it's not crap. That whitelist thing
checks nothing -- and things like CONSTANT_TSC also don't, so I didn't
make the feature itself conditional. It has but one call site anyway.

Rene.
