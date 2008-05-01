Return-Path: <linux-kernel-owner+w=401wt.eu-S1762463AbYEAVtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762463AbYEAVtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763388AbYEAVtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:49:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38301 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761216AbYEAVte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:49:34 -0400
Message-ID: <481A3AD6.1040905@zytor.com>
Date: Thu, 01 May 2008 14:49:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>,
       Mika Fischer <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete
 - auto detect v2
References: <200804272337.40130.yhlu.kernel@gmail.com>	 <200805010100.34751.yhlu.kernel@gmail.com>	 <200805011157.00693.yhlu.kernel@gmail.com>	 <481A1D3A.5040202@zytor.com>	 <86802c440805011402h1e452b57ma27ffa6ad7b50238@mail.gmail.com>	 <481A31E2.2020800@zytor.com>	 <86802c440805011420g78a6abberaae6b765663ed33b@mail.gmail.com>	 <481A356C.5090502@zytor.com>	 <86802c440805011431i88dec8aiadcb143b5f7648b@mail.gmail.com>	 <481A372C.5080808@zytor.com> <86802c440805011444i56611b1ave44a714da7988fa@mail.gmail.com>
In-Reply-To: <86802c440805011444i56611b1ave44a714da7988fa@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>>
>>  That's not the point.  I understand you want to flatten the layout.  The
>> point is: why do you need manual tunables for the algorithm to do the right
>> thing?
> 
> optimal result is not losing covering for ranges that is originally
> covered, and still keep as many of spare mtrr entries for X server
> driver.
> we only have 8 mtrrs, could lose some covering because of run out of mtrr regs.
> So we need to search it according to chunk/gran with ram ranges that
> is defined by old mtrr layout.

Yes.  You have a search space of less than 1000 possible combinations 
(64..20 bits), so it hardly is any reason to not search the entire 
universe of possibilities, even if by exhaustive search.

Now, if even that searching can't come up with the optimal solution (if 
one exists) in all cases, then the algorithm is broken.

> and if we can not find the optimal setting, user could select one
> setting (chunk/gran size) to boot next time, but he will lose some
> covering.
> for some regions. later trim_mtrr will remove those range from e820 map

Right, now we're talking policy, which obviously has to be entered by 
the user.

	-hpa

