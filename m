Return-Path: <linux-kernel-owner+w=401wt.eu-S1763745AbXK2SEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763745AbXK2SEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762165AbXK2SEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:04:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60031 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761877AbXK2SEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:04:10 -0500
Message-ID: <474EFDF8.8090506@zytor.com>
Date: Thu, 29 Nov 2007 09:59:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH x86/mm 08/11] x86 ia32 ptrace getreg/putreg merge
References: <20071129115711.9FC8526F8E7@magilla.localdomain> <20071129120031.F0F4F26F989@magilla.localdomain> <20071129173734.GA556@infradead.org>
In-Reply-To: <20071129173734.GA556@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, Nov 29, 2007 at 04:00:31AM -0800, Roland McGrath wrote:
>> +#define R32(l,q)							\
>> +	case offsetof(struct user32, regs.l):				\
>> +		regs->q = value; break
>> +
>> +#define SEG32(rs)							\
>> +	case offsetof(struct user32, regs.rs):				\
>> +		return set_segment_reg(child,				\
>> +				       offsetof(struct user_regs_struct, rs), \
>> +				       value);				\
>> +		break
> 
> The code would be a lot more readable if you just opencoded this in the
> caller instead of these obsfucated macros.
> 

For better or worse, though, that is style of existing code.  I 
personally found it easy to deal with when I went through the code recently.

	-hpa
