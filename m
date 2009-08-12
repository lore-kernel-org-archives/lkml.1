Return-Path: <linux-kernel-owner+w=401wt.eu-S932159AbZHLAPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbZHLAPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 20:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbZHLAPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 20:15:54 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:53371 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbZHLAPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 20:15:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=FakzgYnoumWA+oJRKY/uB9M0Uoz+xb8aiwGJ7RIUvitTl6tQqyVl6Xwcke2Iqp2Goo
         eW7Fh4/rOHCqBhm9/xcgYd6afvM5nZZ9wvoWvr4aKjPJjnr6LkYpciKV4fX9+HdW+iRJ
         VUOsDcN/85nuGk3P/c1bbklJdAQvG5EoPVIQg=
Message-ID: <4A8209B6.8050306@gmail.com>
Date: Tue, 11 Aug 2009 21:15:50 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090725)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Mikael Pettersson <mikpe@it.uu.se>,
       Borislav Petkov <petkovbb@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] x86: clear incorrectly forced X86_FEATURE_LAHF_LM
 flag
References: <4A7D673A.1090401@gmail.com> <20090808152016.GB25374@liondog.tnic> <4A7E0797.7060504@gmail.com> <20090810131219.GD21879@aftab> <4A80A5AD.2000209@gmail.com> <19073.33348.459260.456740@pilspetsen.it.uu.se> <20090811155106.GB16173@aftab> <d1af83620908110855x75b1e5aeq6d814ca90c49ec22@mail.gmail.com> <20090811160116.GD16173@aftab>
In-Reply-To: <20090811160116.GD16173@aftab>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> On Tue, Aug 11, 2009 at 12:55:03PM -0300, Kevin Winchester wrote:
>> 2009/8/11 Borislav Petkov <borislav.petkov@amd.com>:
>>> On Tue, Aug 11, 2009 at 04:37:56PM +0200, Mikael Pettersson wrote:
>>>> Since the BIOS apparently wrote some MSR to get LAHF_LM incorrectly
>>>> reported by CPUID, would it be possible to also correct that MSR so
>>>> that applications that execute CPUID get the correct feature flags?
>>> That's a good catch, actually. We have to turn off that bit in the cpuid
>>> leaf too if the CPU doesn't support the instructions so that cpuid info
>>> is consistent. LAHF/SAHF support in 64bit mode has to be cpuid-checked
>>> prior to using them so that info has to be correct.
>>>
>>> @Kevin: willing to try a patch or two?
>>>
>> Sure, I'll give it a try this evening.  I assume that since Erratum 110 says:
>>
>> --------------------------
>> Suggested Workaround
>> For processors which support the feature (as determined by the
>> processor revision ID), BIOS should
>> write a one to:
>> • MSR C001_100Dh, bit 32 for revision D silicon.
>> • MSR C001_1005h, bit 32 for revision E and later silicon.
>> This will cause the extended feature flag in ECX[0] to be set.
>> --------------------------
>>
>> That writing a zero to those same MSRs would clear the feature flag?
> 
> Yep :). Patch coming up...
> 

I have been attempting to read those MSRs through the /dev/cpu/0/msr device
file, without any success.  Is it possible that my CPU will not have those
MSRs?  And if so, then maybe my original assumption about the BIOS forcing
on the LAHF_LM feature is wrong.

In any case, clearing the feature flag (and thus fixing /proc/cpuinfo) is
still the right thing to do.

Do you have any other suggestions for how I would affect that CPUID flag?

-- 
Kevin Winchester

