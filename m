Return-Path: <linux-kernel-owner+w=401wt.eu-S1752323AbZIKK6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbZIKK6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 06:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbZIKK6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 06:58:46 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:50215 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbZIKK6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 06:58:45 -0400
To: catalin.marinas@arm.com
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [2.6.31] Memory leak in load_module()?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200909111638.IDC17135.FOHJOtFFMQSVLO@I-love.SAKURA.ne.jp>
	<tnxhbv97rt6.fsf@pc1117.cambridge.arm.com>
In-Reply-To: <tnxhbv97rt6.fsf@pc1117.cambridge.arm.com>
Message-Id: <200909111958.HFG60925.OOQLHFFVtSJOMF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 11 Sep 2009 19:58:46 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Catalin Marinas wrote:
> It could be but isn't stack tracing enabled on your system? The
> backtrace doesn't seem very useful.

Since the kernel hangs after printing

[    0.000999]  memory used by lock dependency info: 3743 kB
[    0.000999]  per task-struct memory footprint: 1920 bytes

if I enable almost all debug options and change
CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE to 2000,
I disabled almost all debug options.

OK. Here is the output with CONFIG_FRAME_POINTER=y .
Do I need to enable some other debug options?

unreferenced object 0xdd7c1718 (size 32):
  comm "insmod", pid 2859, jiffies 4294757534
  backtrace:
    [<c048a210>] create_object+0x135/0x202
    [<c048a302>] kmemleak_alloc+0x25/0x49
    [<c04865bd>] kmemleak_alloc_recursive+0x1c/0x22
    [<c0486e27>] __kmalloc_track_caller+0x66/0xb3
    [<c0473980>] kstrdup+0x2c/0x4e
    [<c044716a>] setup_modinfo_srcversion+0x12/0x1b
    [<c0448725>] load_module+0x866/0x124a
    [<c0449180>] sys_init_module+0x49/0x1b9
    [<c0402a24>] sysenter_do_call+0x12/0x22
    [<ffffffff>] 0xffffffff

Regards.
