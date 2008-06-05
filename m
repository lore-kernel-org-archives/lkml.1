Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbYFEHI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbYFEHI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 03:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYFEHIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 03:08:48 -0400
Received: from main.gmane.org ([80.91.229.2]:42314 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbYFEHIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 03:08:47 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference (drm_getunique)
Date: Thu, 05 Jun 2008 08:08:34 +0100
Message-ID: <g283dg$esd$1@ger.gmane.org>
References: <g276vj$7f0$2@ger.gmane.org> <873ansbwcq.fsf@saeurebad.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Johannes Weiner wrote:

> Sitsofe Wheeler <sitsofe@yahoo.com> writes:
> 
>> [ 4305.767503] Pid: 8373, comm: unix2_chkpwd Tainted: G        W
>> [ (2.6.26-rc4-next-20080604skw #177)
> 
> There was a warning before that oops already, could you post that too?

The warning is:
[   42.949862] ------------[ cut here ]------------
[   42.949873] WARNING: at kernel/lockdep.c:2680 check_flags+0x8a/0x12d()
[   42.949880] Modules linked in:
[   42.949887] Pid: 5, comm: watchdog/0 Not tainted 2.6.26-rc4-next-20080604skw #178
[   42.949898]  [<c01226f0>] warn_on_slowpath+0x41/0x6a
[   42.949917]  [<c013c584>] ? trace_hardirqs_off+0xb/0xd
[   42.949935]  [<c013e3b4>] ? trace_hardirqs_on+0xb/0xd
[   42.951740]  [<c013e36d>] ? trace_hardirqs_on_caller+0xe8/0x124
[   42.951759]  [<c013e3b4>] ? trace_hardirqs_on+0xb/0xd
[   42.951778]  [<c011c8f7>] ? hrtick_set+0xce/0xd6
[   42.951799]  [<c013c1d2>] check_flags+0x8a/0x12d
[   42.951816]  [<c013f2f8>] lock_acquire+0x3b/0x89
[   42.951830]  [<c0370c0a>] _read_lock+0x1c/0x49
[   42.951848]  [<c01531fe>] ? watchdog+0x97/0x1a9
[   42.951867]  [<c0153167>] ? watchdog+0x0/0x1a9
[   42.951883]  [<c01531fe>] watchdog+0x97/0x1a9
[   42.951900]  [<c0153167>] ? watchdog+0x0/0x1a9
[   42.951916]  [<c01329a0>] kthread+0x3b/0x63
[   42.951933]  [<c0132965>] ? kthread+0x0/0x63
[   42.951952]  [<c01038ab>] kernel_thread_helper+0x7/0x10
[   42.951969]  =======================
[   42.951976] ---[ end trace 199a1fe68fc13dfd ]---
[   42.951983] possible reason: unannotated irqs-on.
[   42.951991] irq event stamp: 18
[   42.951998] hardirqs last  enabled at (17): [<c013e3b4>] trace_hardirqs_on+0xb/0xd
[   42.952018] hardirqs last disabled at (18): [<c013c584>] trace_hardirqs_off+0xb/0xd
[   42.952043] softirqs last  enabled at (0): [<c0120e1b>] copy_process+0x2dd/0xf9a
[   42.952062] softirqs last disabled at (0): [<00000000>] 0x0

I've mentioned it before ( http://lkml.org/lkml/2008/5/29/502 ) and even 
bisected it ( http://lkml.org/lkml/2008/6/4/313 ). I guess the problem
is that everyone is busy and it's hard to tell if people didn't see it,
if it's just not important. Perhaps there needs to be a rule that
lockdep warnings always go into bugzilla (or that if you are willing
to chase an issue for a minimum of six months it should be bugzillad...).

Thanks for your work looking at the real bug though!

-- 
Sitsofe | http://sucs.org/~sits/

