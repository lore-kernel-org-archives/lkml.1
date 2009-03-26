Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbZCZE2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbZCZE2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 00:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbZCZE2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 00:28:09 -0400
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:45942 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbZCZE2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 00:28:08 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: current->mm == NULL in security_vm_enough_memory(). 
To: James Morris <jmorris@namei.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, alan@redhat.com,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <alpine.LRH.2.00.0903261236580.30336@tundra.namei.org>
References: <200903260130.n2Q1U9EJ040448@www262.sakura.ne.jp> <alpine.LRH.2.00.0903261236580.30336@tundra.namei.org>
Date: Thu, 26 Mar 2009 13:26:43 +0900
Message-ID: <7142.1238041603@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


James Morris:
> On Thu, 26 Mar 2009, Tetsuo Handa wrote:
> 
> > [   28.765817] ------------[ cut here ]------------
> > [   28.768916] WARNING: at security/security.c:217 security_vm_enough_memory+0xa0/0xb0()
> > [   28.772484] Hardware name: VMware Virtual Platform
> > [   28.774099] Modules linked in: pcnet32 crc32
> > [   28.776920] Pid: 3286, comm: khelper Not tainted 2.6.29-next-20090324-dirty #3
> > [   28.780317] Call Trace:
> > [   28.781323]  [<c0159200>] ? have_callable_console+0x30/0x50
> > [   28.784171]  [<c0158497>] warn_slowpath+0x97/0xf0
> > [   28.785739]  [<c0190f7c>] ? validate_chain+0x3fc/0x540
> > [   28.788402]  [<c0190f7c>] ? validate_chain+0x3fc/0x540
> > [   28.790103]  [<c0192dfc>] ? __lock_acquire+0x29c/0x8a0
> > [   28.792809]  [<c0194859>] ? __lock_acquired+0x109/0x1c0
> > [   28.794539]  [<c0338ea0>] security_vm_enough_memory+0xa0/0xb0
> > [   28.797391]  [<c0202117>] acct_stack_growth+0xd7/0x160
> > [   28.798842]  [<c02022b9>] expand_downwards+0x119/0x150
> > [   28.801709]  [<c020230d>] expand_stack+0xd/0x10
	:::
> > May I ignore this warning?
> 
> khelper is a kernel thread, so it should not have an ->mm, but I wonder 
> why this hasn't shown up before.  Odd...

The patch was merged in 2.6.28. See this url in detail.
http://marc.info/?t=122460314500001&r=1&w=2
Subject: __vm_enough_memory(), OVERCOMMIT_NEVER, current->mm, kernel thread

With this discussion, a new function security_vm_enough_memory_kern()
was introduced. All kernel thread should call this new one instead of
security_vm_enough_memory(). The added WARN_ON() worked exactly as Alan
Cox expected.
But I am not sure this is the case. When expand_stack() is called in the
user context, to call ..._kern() may be a bad idea.


J. R. Okajima
