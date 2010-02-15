Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab0BOSHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 13:07:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42395 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755773Ab0BOSHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 13:07:31 -0500
Message-ID: <4B798D2F.7010701@zytor.com>
Date: Mon, 15 Feb 2010 10:06:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: x86: get rid of the insane TIF_ABI_PENDING bit
References: <20100215161752.GA19962@redhat.com> <4B7974F7.1030105@zytor.com> <20100215165012.GA20447@redhat.com>
In-Reply-To: <20100215165012.GA20447@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2010 08:50 AM, Oleg Nesterov wrote:
> 
> Could you please point me where do we check TS_COMPAT during return
> to user-mode?
> 

Sorry, I was thinking about TIF_IA32, which is examined on line 415 of
entry_64.S.

>>> If a 64bit task execs a 32bit app, can't this TS_COMPAT break, say,
>>> syscall_get_arguments() ?
>>
>> At that point (this is after the exec!) we don't get arguments anyway.
> 
> I meant /proc/pid/syscall, but even if I am right this probably
> doesn't matter.

What does getting the arguments from a process which has never done a
system call yet even mean?  Presumably we get some kind of "null answer"
which depends on the default register set; in that case the compat null
answer is the correct one.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

