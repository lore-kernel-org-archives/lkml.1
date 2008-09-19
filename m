Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbYISOHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbYISOHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 10:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbYISOGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 10:06:55 -0400
Received: from xsmtp1.ethz.ch ([82.130.70.13]:6557 "EHLO xsmtp1.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbYISOGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 10:06:55 -0400
Message-ID: <48D3B1FD.6020008@debian.org>
Date: Fri, 19 Sep 2008 16:06:53 +0200
From: "Giacomo A. Catenazzi" <cate@debian.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Peter Oruba <peter.oruba@amd.com>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 05/11] [PATCH 05/11] x86: Moved microcode.c to microcode_intel.c.
References: <20080728164411.490752571@amd.com>	 <20080728164448.492961653@amd.com>	 <20080907120823.59f8fa47@infradead.org> <48CA586C.2010104@amd.com>	 <20080912063517.783b7f85@infradead.org> <48D3942B.1050901@amd.com> <b647ffbd0809190537w18cc4d5fo4ce1a9c0390405d9@mail.gmail.com> <48D3A1FD.7010309@debian.org> <48D3A338.5070400@amd.com>
In-Reply-To: <48D3A338.5070400@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Sep 2008 14:06:53.0221 (UTC) FILETIME=[F7BB7550:01C91A60]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Oruba wrote:
> Giacomo A. Catenazzi schrieb:
>> Dmitry Adamushko wrote:
>>> 2008/9/19 Peter Oruba <peter.oruba@amd.com>:
>>>> Some additonal words regarding the current user space issues:
>>>>
>>>> IMHO the most convenient way to update microcode is through the
>>>> firmware loading
>>>> interface instead of microcode_ctl. This reduces user-space
>>>> responsibilities to
>>>> loading the correct module at boot time and to place the microcode
>>>> patch file at
>>>> the right location via package installation. The problems mentioned
>>>> in this
>>>> thread would then probably disappear as well. What do you guys think?
>>> It'd still require changes for all the setups that currently rely on
>>> the 'microcode_ctl' interface. Moreover, Arjan's setup failed not due
>>> to the 'microcode_ctl' per se but due to the altered kernel module
>>> name. After all, we can't break the established interface this way.
>>>
>>> We can either reserve 'microcode' as a legacy name for intel cpus (==
>>> microcode_intel), or maybe we can use request_module() from
>>> microcode.ko to load a proper arch-specific module (I guess, it's not
>>> ok for !KMOD-enabled kernels).
>> I agree. A wrapper "microcode.ko" module would be nice, in order
>> to allow independent kernel and user space upgrades.
>>
>> The module name is important also on udev method: only a module
>> load triggers the microcode request in udev, thus also the
>> new method should have stable kernel module name.
>>
>> ciao
>>     cate
>>
> 
> That sounds like a single-module solution would be the best way to go. All
> dependencies would then be handled inside the module.

Single module probably is more difficult to maintain.

I was thinking about a very simple additional module:
It checks the cpu: load the relevant module, and wrapper the
calls to the relevant module.

So every vendor could develop easier the own driver. Only the interface
should be stable.

Eventually we could solve it in the distribution scripts (using module
aliases), but it would be kernel version dependent, and it would works
only on the new method (or a new microcode_ctl version, but people
upgrade more often kernel than packages).

ciao
	cate
