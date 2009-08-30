Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbZH3UCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbZH3UCx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 16:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbZH3UCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 16:02:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35387 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbZH3UCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 16:02:52 -0400
Message-ID: <4A9ADAC3.3020004@zytor.com>
Date: Sun, 30 Aug 2009 13:02:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@googlemail.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH 3/3] x86, AMD: Disable wrongly set X86_FEATURE_LAHF_LM
 CPUID bit
References: <1251633031-2244-1-git-send-email-petkovbb@gmail.com> <1251633031-2244-3-git-send-email-petkovbb@gmail.com> <4A9AD17A.6060507@zytor.com> <20090830193039.GB22234@liondog.tnic>
In-Reply-To: <20090830193039.GB22234@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2009 12:30 PM, Borislav Petkov wrote:
> On Sun, Aug 30, 2009 at 12:22:34PM -0700, H. Peter Anvin wrote:
>> On 08/30/2009 04:50 AM, Borislav Petkov wrote:
>>>  			clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
>>> +			if (!rdmsrl_amd_safe(0xc001100d, &val)) {
>>> +				val &= ~(1ULL << 32);
>>> +				wrmsr_amd_safe(0xc001100d, (u32) val,
>>> +							   (u32)(val >> 32));
>>> +			}
>>> +		}
>> We presumably want/need wrmsrl_amd_safe() here!
> 
> Actually, it is wrmsr_amd_safe() because we need the magic value in
> %edi. wrmsr_amd_safe() calls the _regs variant with the array argument.
> And we don't have a wrmsrl_amd_safe-one which gets a 64bit msr value as
> an argument similar to the rdmsrl one.
> 

That's exactly the point.  We shouldn't have rdmsrl_amd_safe() on one
hand and wrmsr_asm_safe() on the other.  I have already fixed this up in
my tree, but this kind of asymmetry should have been a big red flashing
light.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

