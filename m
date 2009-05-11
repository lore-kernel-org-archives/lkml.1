Return-Path: <linux-kernel-owner+w=401wt.eu-S1757811AbZEKTCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbZEKTCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbZEKTCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:02:44 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:50157
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754202AbZEKTCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:02:43 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 May 2009 15:02:43 EDT
X-BigFish: VPS-36(z34a4jz146fK1432R62a3L98dR936eQ1805Mzz1202hzzz32i6bh43j)
X-FB-SS: 5,
X-WSS-ID: 0KJHTJ0-01-L9H-01
Date: Mon, 11 May 2009 20:47:28 +0200
From: Robert Richter <robert.richter@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@kernel.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: Addition of cpufeatures to friendly
	access miscellaneous MSRs
Message-ID: <20090511184727.GF10722@erda.amd.com>
References: <1242058494.5139.7.camel@ht.satnam> <4A086B58.30607@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4A086B58.30607@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 11 May 2009 18:47:29.0338 (UTC) FILETIME=[EF8089A0:01C9D268]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.05.09 11:15:52, H. Peter Anvin wrote:
> Jaswinder Singh Rajput wrote:
>> Jaswinder Singh Rajput (15):
>>       x86: Add cpufeature for Processor Name
>>       x86: Add cpufeatures for Advanced Power Management
>>       x86: Add cpufeature for Microcode update
>>       x86: Add cpufeature for Cache MSRs
>>       x86: Add cpufeature for Hard and Soft Poweron configuration
>>       x86: Add cpufeature for Scaleable bus speed
>>       x86: Add cpufeature for Miscellaneous Features
>>       x86: Add cpufeature for Platform feature
>>       x86: Add cpufeature for Hardware configuration
>>       x86: Add cpufeature for System configuration
>>       x86: Add cpufeature for System management mode (SMM)
>>       x86: Add cpufeature for MM configuration
>>       x86: Add cpufeature for Bus configuration
>>       x86: Add cpufeature for performance frequency APERF/MPERF
>>       x86: Add cpufeature for ancient performance monitoring
>
> Overall, I'm rather confused what the point of this is supposed to be. 
> There is value to centralizing CPU knowledge, but some of these flags are 
> only used in one place, and as far as I can see in several of your patches 
> they aren't used *at all*.
>
> If there is no in-kernel user there is absolutely no point to this.

>From the pull request subject

 x86: Addition of cpufeatures to friendly access miscellaneous MSRs

I assume this is mainly done for dumping msrs for debugging
purposes. I don't want to start the discussion again if this really
should be done in kernel space. I would rather parse and decode msr
registers in userspace. MSR tables could be easily implemented there.

Anyway, I think this was already decided. So, maybe for debugging we
should simply read the msrs with rdmsr_safe() and use the exception
handler to check if the msr is implemented. This would avoid most of
the otherwise unused cpufeature flags above.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

