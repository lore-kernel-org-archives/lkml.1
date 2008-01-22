Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbYAVQZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbYAVQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 11:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYAVQZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 11:25:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41540 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbYAVQZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 11:25:19 -0500
Message-ID: <4796189E.4010404@zytor.com>
Date: Tue, 22 Jan 2008 08:23:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, Ian Campbell <ijc@hellion.org.uk>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1200758937-22386-1-git-send-email-ijc@hellion.org.uk> <1200758937-22386-2-git-send-email-ijc@hellion.org.uk> <87prvxct42.fsf@basil.nowhere.org> <1200847490.26633.62.camel@cthulhu.hellion.org.uk> <20080120173938.GA27247@one.firstfloor.org> <47939787.3050707@zytor.com> <20080122100509.GC5722@elte.hu>
In-Reply-To: <20080122100509.GC5722@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> I was thinking about this yesterday, and it seems to me that there are 
>> two cleaner options here...
>>
>> - either we should put in the full machinery to be able to run C code 
>> compiled with -fPIC/-fPIE before paging is enabled.  Unfortunately gcc 
>> generates R_386_GOT32 relocations for external references even with 
>> -fPIE, so we'll have to put in some code to adjust the GOT (easy 
>> enough to do.)
> 
> i'd _love_ to have this approach instead of the assembly routines. While 
> 'constructing pagetables' might not look like a big deal in isolation - 
> C is still 10 times more programmable than assembly. Pushing more of the 
> early boot code into a sane, non-assembly environment will have positive 
> long-term effects all across.
> 

Yes, but that doesn't mean that this particular task is the right thing 
for that job.  In particular, the GOT adjustment wll be almost the same 
size as the whole task.

On the other hand, there is a whole bunch of post-paging code in 
head_32.S which doesn't need to be there.

	-hpa
