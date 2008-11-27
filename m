Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbYK0OXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbYK0OXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYK0OWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:22:33 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:22734 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbYK0OWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:22:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=MljktpRJBY9/bGuF+AA9wSiO3p/W+5j0baQAkJlQ1x+e2aNE5ejdluARp9rvQq9iPh
         fNHBGcLch/Fvy2oEcFq0+z+eJb/SFVTRZeYuk5CQAIpxu4umJJwoGIHxQCLQ6YRFjW1L
         7JlnL8Rmq2JeprNcRRbBVp07bz9ZwqCLMbjTc=
Message-ID: <7c86c4470811270622s540a17d8r73462dfa93d1bc6d@mail.gmail.com>
Date: Thu, 27 Nov 2008 15:22:29 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch 20/24] perfmon: system calls interface
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, x86@kernel.org,
       andi@firstfloor.org, sfr@canb.auug.org.au,
       "Roland McGrath" <roland@redhat.com>, "Oleg Nesterov" <oleg@redhat.com>
In-Reply-To: <20081126140027.GC6562@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0c0b.170e660a.15ba.ffffdabf@mx.google.com>
	 <20081126140027.GC6562@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

On Wed, Nov 26, 2008 at 3:00 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Thirdly, the check for ->exit_state in pfm_task_incompatible() is not
> needed: we've just passed ptrace_check_attach() so we know we just
> transitioned the task to task->state == TASK_TRACED.
>
> If you _ever_ see a task exit TASK_TRACED and go zombie or dead from
> there without this code allowing it that means the whole state machine
> with ptrace is borked up by perfmon. For example i dont see where the
> perfmon-control task parents itself as the exclusive debugger (parent)
> of the debuggee-task.
>

Perfmon requires ptrace ONLY to stop the thread you want to operate
on. For instance, to read the counters in a thread via pfm_read(), you
need to have that thread stopped, so perfmon can extract the machine
state safely. But when the monitored thread runs, it does not have to
remain under the control of ptrace. All that is needed  is that the thread
is stopped while we are in the perfmon syscall. I think ptrace allows this
today. We will be able to drop ptrace()  once we switch to utrace in which
case, the kernel will be able to easily stop the thread when entering the
perfmon syscalls. I guess I don't quite understand the meaning of your
last sentence.
