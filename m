Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbYKKMaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbYKKMaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 07:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbYKKMaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 07:30:08 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:54303 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080AbYKKMaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 07:30:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ncWVS2DfQxYzMYRvLRvSI6YtWui6zu8CV2kc8AB+OshXkhfb7IV8SD49KjHclnBmdq
         BhXlfHF7J6ykbW2j5sulX15qGpyud68YNzDjUqQS+j/1eXvI3I5GUottfS/6RW/A67pl
         CfcXNnZiOQ12yJ5NjimqKEBuNZaRy9jsgTlpo=
Date: Tue, 11 Nov 2008 15:33:27 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
Message-ID: <20081111123327.GA12167@x200.localdomain>
References: <20081107003021.GA18666@google.com> <20081107004824.GA28780@x200.localdomain> <20081107074147.GA26607@elte.hu> <20081107075925.GA1825@elte.hu> <20081107082003.GA15800@x200.localdomain> <20081107083249.GD4435@elte.hu> <20081107084943.GA16147@x200.localdomain> <20081107085352.GA27245@elte.hu> <20081107090304.GA30540@elte.hu> <20081111122531.GA5836@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111122531.GA5836@joi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 01:25:36PM +0100, Marcin Slusarz wrote:
> On Fri, Nov 07, 2008 at 10:03:04AM +0100, Ingo Molnar wrote:
> > 
> > btw., the feature works beautifully:
> > 
> > task sleeping/blocked:
> > 
> >  # cat /proc/1/stack
> >  [<ffffffff802bfe75>] do_select+0x51a/0x582
> >  [<ffffffff802c0059>] core_sys_select+0x17c/0x218
> >  [<ffffffff802c0344>] sys_select+0x99/0xc1
> >  [<ffffffff8020c23b>] system_call_fastpath+0x16/0x1b
> >  [<ffffffffffffffff>] 0xffffffffffffffff
> > 
> > task running on this CPU:
> > 
> >  # cat /proc/self/stack
> >  [<ffffffff80216f79>] save_stack_trace_tsk+0x26/0x44
> >  [<ffffffff802f59a5>] proc_pid_stack+0x6e/0xd3
> >  [<ffffffff802f6da3>] proc_info_read+0x68/0xba
> >  [<ffffffff802b2f17>] vfs_read+0xa9/0xe3
> >  [<ffffffff802b301f>] sys_read+0x4c/0x73
> >  [<ffffffff8020c23b>] system_call_fastpath+0x16/0x1b
> >  [<ffffffffffffffff>] 0xffffffffffffffff
> > 
> > task running on another CPU in user-space:
> > 
> >  # cat /proc/18579/stack
> >  [<ffffffffffffffff>] 0xffffffffffffffff
> 
> so this file provides view of _kernel_ stack only?

Of course!

> shouldn't it be named kernel-stack then?
> 
> > task running on another CPU in kernel-space:
> > 
> >  # cat /proc/18579/stack
> >  [<ffffffff8026f111>] audit_syscall_exit+0x9c/0xed
> >  [<ffffffff80214b49>] syscall_trace_leave+0x94/0xbb
> >  [<ffffffffffffffff>] 0xffffffffffffffff
