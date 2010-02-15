Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab0BOQX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 11:23:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35886 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159Ab0BOQX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 11:23:57 -0500
Message-ID: <4B7974F7.1030105@zytor.com>
Date: Mon, 15 Feb 2010 08:23:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: x86: get rid of the insane TIF_ABI_PENDING bit
References: <20100215161752.GA19962@redhat.com>
In-Reply-To: <20100215161752.GA19962@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2010 08:17 AM, Oleg Nesterov wrote:
> 
>> +void set_personality_ia32(void)
>> +{
>> +	/* inherit personality from parent */
>> +
>> +	/* Make sure to be in 32bit mode */
>> +	set_thread_flag(TIF_IA32);
>> +
>> +	/* Prepare the first "return" to user space */
>> +	current_thread_info()->status |= TS_COMPAT;
> 
> Can't understand why we need TS_COMPAT. I assume this is correct,
> this was copied from flush_thread().
> 
> What TS_COMPAT actually means? I thought it just means "the task
> is inside 32-bit syscall".

Yes.  In this case, though, it was a 64-bit syscall when the process did
the exec, but it needs to "return" as if it came from a 32-bit syscall;
that's why we set the TS_COMPAT bit.

> If a 64bit task execs a 32bit app, can't this TS_COMPAT break, say,
> syscall_get_arguments() ?
> 

At that point (this is after the exec!) we don't get arguments anyway.

> Just curious, I don't really understand COMPAT issues anyway.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

