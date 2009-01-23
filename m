Return-Path: <linux-kernel-owner+w=401wt.eu-S1760184AbZAWAOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184AbZAWAOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 19:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756162AbZAWAON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 19:14:13 -0500
Received: from gw.goop.org ([64.81.55.164]:45293 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756390AbZAWAON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 19:14:13 -0500
Message-ID: <49790BCC.1040807@goop.org>
Date: Thu, 22 Jan 2009 16:14:04 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "jeremy@xensource.com" <jeremy@xensource.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
References: <20090120110542.GE19505@wotan.suse.de>	 <20090120112634.GA20858@elte.hu> <20090120140324.GA26424@elte.hu>	 <49763806.5090009@goop.org> <20090120205653.GA19710@elte.hu>	 <20090121072718.GN24891@wotan.suse.de>  <4977A051.8050203@goop.org>	 <1232663311.16317.176.camel@bodhitayantram.eng.vmware.com>	 <4978F6C6.3090003@goop.org> <1232664907.16317.182.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1232664907.16317.182.camel@bodhitayantram.eng.vmware.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> What about removing the identity functions entirely.  They are useless,
> really.  All that is needed is a patch site filled with nops for Xen to
> overwrite, just stuffing the value into the proper registers.  For
> 64-bit, it can be a simple mov to satisfy the constraints.
>   

I think it comes to the same thing really.  Both end up generating a 
series of nops with values entering and leaving in well-defined 
registers.  The x86-64 calling convention is a bit awkward because the 
first arg is in rdi and the ret is rax, so it can't quite be pure nops, 
or we use a non-standard calling-convention with appropriate thunks to 
call into C code.  I think a mov is a better performance-complexity 
tradeoff.

>> Also, I just posted patches to get rid of all pvops calls when fetching 
>> or setting flags in a pte, which I hope will help.
>>     
>
> Sounds like it will help.
>   

...but apparently not.

    J
