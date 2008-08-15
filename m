Return-Path: <linux-kernel-owner+w=401wt.eu-S1761595AbYHOUhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761595AbYHOUhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 16:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYHOUgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 16:36:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46388 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYHOUgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 16:36:52 -0400
Message-ID: <48A5E8BC.6060601@zytor.com>
Date: Fri, 15 Aug 2008 13:36:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, michael@free-electrons.com
Subject: Re: [PATCH 1/1] [x86] Configuration options to compile out x86 CPU
 support code
References: <1217929519-10527-1-git-send-email-thomas.petazzoni@free-electrons.com> <20080815141855.GB12954@elte.hu>
In-Reply-To: <20080815141855.GB12954@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Thomas Petazzoni <thomas.petazzoni@free-electrons.com> wrote:
> 
>> This patch adds some configuration options that allow to compile out 
>> CPU vendor-specific code in x86 kernels (in arch/x86/kernel/cpu). The 
>> new configuration options are only visible when CONFIG_EMBEDDED is 
>> selected, as they are mostly interesting for space savings reasons.
>>
>> An example of size saving, on x86 with only Intel CPU support:
>>
>>    text	   data	    bss	    dec	    hex	filename
>> 1125479	 118760	 212992	1457231	 163c4f	vmlinux.old
>> 1121355	 116536	 212992	1450883	 162383	vmlinux
>>   -4124   -2224       0   -6348   -18CC +/-
>>
>> However, I'm not exactly sure that the Kconfig wording is correct with 
>> regard to !64BIT / 64BIT.
> 
> applied to tip/x86/cpu, thanks Thomas. (I've done a trivial cleanup: 
> converted the macro to an inline.)
> 
> Peter, do you like this version of the patch or would you like further 
> improvements?
> 

I'm fine with it.

I think there might still be cross-dependencies, but it doesn't break 
anything old, so we can deal with that via bug reports.

The other thing that probably should be done is breaking out the 
Intel-specific versus generic parts of intel_cacheinfo.c.

	-hpa
