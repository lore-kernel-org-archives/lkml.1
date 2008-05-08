Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbYEHC3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbYEHC3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 22:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbYEHC33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 22:29:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43375 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbYEHC31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 22:29:27 -0400
Message-ID: <48226569.7010906@zytor.com>
Date: Wed, 07 May 2008 19:28:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Rene Herman <rene.herman@keyaccess.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] x86: introduce a new Linux defined feature flag for PAT
 support
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl> <482233F0.7040000@zytor.com> <48224318.8020209@keyaccess.nl> <48224361.5080102@zytor.com> <48224507.8010102@keyaccess.nl> <alpine.LFD.1.10.0805071716060.3024@woody.linux-foundation.org> <48224930.9030901@keyaccess.nl> <48225DEC.2030502@keyaccess.nl> <alpine.LFD.1.10.0805071857430.3024@woody.linux-foundation.org> <4822614B.6080706@zytor.com> <alpine.LFD.1.10.0805071923030.3024@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805071923030.3024@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
>> *Certainly* I don't want anything like this crap:
>>
>>> -    if (cpu_has_pat)
>>> +    if (cpu_has_pat && cpu_has_pat_good)
> 
> This in fact is likely the best part of it.
> 
> Because that at least guarantees that we never say we have a good PAT when 
> the hardware doesn't even report it.
> 
> As it is, we seem to just blindly override hardware. It may be correct for 
> all the models we override, but still..
> 

Yah, this is not good.  We should mask out the bit, but never, ever, set 
it if it was clear to begin with (unless we have it on really, *really*, 
good authority.)

I'm embarrassed to have let that slink by.

	-hpa
