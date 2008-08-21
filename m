Return-Path: <linux-kernel-owner+w=401wt.eu-S1759442AbYHUSyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442AbYHUSyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYHUSyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:54:43 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:49221 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753893AbYHUSyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:54:41 -0400
Message-ID: <48ADB9E8.7060906@linux.vnet.ibm.com>
Date: Fri, 22 Aug 2008 00:24:32 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080724)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: jay kumar <jaykumarks@gmail.com>, David Howells <dhowells@redhat.com>,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: Bug: "bad unlock balance detected" 2.6.27-rc3-next-20080820
References: <6f31812b0808210004i63b3273ehf65ce9eb139256f0@mail.gmail.com> <19f34abd0808210110s4dd2ec12r6d3044e45a21d67@mail.gmail.com>
In-Reply-To: <19f34abd0808210110s4dd2ec12r6d3044e45a21d67@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> On Thu, Aug 21, 2008 at 9:04 AM, jay kumar <jaykumarks@gmail.com> wrote:
>> While testing 2.6.27-rc3-next-20080820 ,  i observed this    "BUG:bad
>> unlock balance detected" during boot time
>>
>> commit 765d4840cc9cca98c0cc4ff4764608780c3265f6
>> Author: Stephen Rothwell <sfr@canb.auug.org.au>
>> Date:   Wed Aug 20 18:59:47 2008 +1000
>>
>>
>> Bug info:
>>
>> [    0.140173] =====================================
>> [    0.145977] [ BUG: bad unlock balance detected! ]
>> [    0.145977] -------------------------------------
>> [    0.145977] khelper/12 is trying to release lock (&p->cred_exec_mutex) at:
>> [    0.146977] [<c05c624f>] mutex_unlock+0xd/0xf
>> [    0.146977] but there are no more locks to release!
>> [    0.146977]
>> [    0.146977] other info that might help us debug this:
>> [    0.146977] no locks held by khelper/12.
>> [    0.146977]
>> [    0.146977] stack backtrace:
>> [    0.146977] Pid: 12, comm: khelper Not tainted 2.6.27-rc3-next-20080820 #13
>> [    0.146977]  [<c05c624f>] ? mutex_unlock+0xd/0xf
>> [    0.146977]  [<c0242944>] print_unlock_inbalance_bug+0xa5/0xb2
>> [    0.146977]  [<c05c624f>] ? mutex_unlock+0xd/0xf
>> [    0.146977]  [<c0245cd7>] lock_release+0x8f/0x186
>> [    0.146977]  [<c05c61f0>] __mutex_unlock_slowpath+0x9b/0xed
>> [    0.146977]  [<c05c624f>] mutex_unlock+0xd/0xf
>> [    0.146977]  [<c029506f>] free_bprm+0x24/0x39
>> [    0.146977]  [<c029644e>] do_execve+0x1e5/0x1fb
>> [    0.146977]  [<c0202156>] sys_execve+0x2e/0x51
>> [    0.146977]  [<c0203a72>] syscall_call+0x7/0xb
>> [    0.146977]  [<c0206654>] ? kernel_execve+0x1c/0x21
>> [    0.146977]  [<c023383c>] ? ____call_usermodehelper+0x0/0x129
>> [    0.146977]  [<c023395b>] ? ____call_usermodehelper+0x11f/0x129
>> [    0.146977]  [<c023383c>] ? ____call_usermodehelper+0x0/0x129
>> [    0.146977]  [<c020466b>] ? kernel_thread_helper+0x7/0x10
>> [    0.146977]  =======================
> 
> (config clipped)
> 
> Hi,
> 
> Thanks for the report. The error comes from
> 
> commit d9a939fb80ef390b78b3c801f668bd1e35ebc970
> Author: David Howells <dhowells@redhat.com>
> Date:   Thu Aug 7 20:02:20 2008 +1000
> 
>     CRED: Make execve() take advantage of copy-on-write credentials
> 
> (Added to Cc. I guess it's also nice to Cc linux-next on errors in -next code.)
> 
> I couldn't reproduce your original failure, but I've attempted to fix
> it by reordering the mutex unlock and bprm free and removing the
> extraneous unlock (see attached patch; it boots for me without
> errors).
> 
> 
> Vegard
> 
Hi,

Thanks, the patch fixes the "bad unlock balance" warning I was hitting
with the next-20080821 patchset.

Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
