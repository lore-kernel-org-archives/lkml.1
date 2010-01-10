Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319Ab0AJDLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab0AJDLF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 22:11:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519Ab0AJDLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 22:11:03 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:63103 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab0AJDLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 22:11:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=INTFdSaloArvHfaF1Uo4bgMVMsbbujhWZwlaiGqMHc2qtn4oIUuSTqggZzpYtW9Om4
         n4N8c1n5riKYq614gujWhRR+D6n/ikSFSg4meonOBpCVQlDCBES5SyM8ZGJg1wngO8Va
         9oclsFxTIBGeWVmPKoyocw2l5cRy/JK6Zq+vY=
Date: Sun, 10 Jan 2010 04:10:57 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: prasad@linux.vnet.ibm.com, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] ksym_tracer: Fix to make the tracer work
Message-ID: <20100110031056.GA15195@nowhere>
References: <4B3AF19E.1010201@cn.fujitsu.com> <20091230150530.GA3401@in.ibm.com> <4B3C3C9B.7090605@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B3C3C9B.7090605@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 01:54:35PM +0800, Li Zefan wrote:
> K.Prasad wrote:
> > Frederic must have used for_each_possible_cpu() to account for CPUs that
> > are offline at the time of registration, but may eventually turn online.
> > Since register_wide_hw_breakpoint() interface is designed to deliver
> > system-wide breakpoints, the debug registers of a new online CPU will
> > should have the breakpoints populated to comprehensively notify all
> > memory accesses over target address.
> > 
> > I'd rather wait to hear from Frederic to know why
> > perf_event_create_kernel_counter() returns an error when run for an
> > offline cpu and how it can be solved.
> > 
> 
> See the comment in find_get_context() in kernel/perf_event.c:
> 
>                 /*
>                  * We could be clever and allow to attach a event to an
>                  * offline CPU and activate it when the CPU comes up, but
>                  * that's for later.
>                  */
>                 if (!cpu_online(cpu))
>                         return ERR_PTR(-ENODEV);
> 
> So I think we can use for_each_possible_cpu() in the future, but not now.
> 


Ah, right I indeed missed that.

