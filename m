Return-Path: <linux-kernel-owner+w=401wt.eu-S1762406AbZE0HuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762406AbZE0HuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbZE0HuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:50:11 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:48166 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758567AbZE0HuK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:50:10 -0400
MIME-Version: 1.0
In-Reply-To: <1243373914.8400.29.camel@gaiman.anholt.net>
References: <b2cdc9f30905260520m6d779cdof202dabe511ed49b@mail.gmail.com>
	 <1243373914.8400.29.camel@gaiman.anholt.net>
Date: Wed, 27 May 2009 08:50:11 +0100
X-Google-Sender-Auth: 35fd9e73653dc3d6
Message-ID: <b2cdc9f30905270050s63a355f8u51644cb076cf7be6@mail.gmail.com>
Subject: Re: i915_gem_retire_requests oops on 2.6.30-rc7
From: Alex Bennee <kernel-hacker@bennee.com>
To: Eric Anholt <eric@anholt.net>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/26 Eric Anholt <eric@anholt.net>:
> On Tue, 2009-05-26 at 13:20 +0100, Alex Bennee wrote:
>> Hi,
>>
>> I've just had X crash on me with an attendant oops in the kernel as it did so:
>
> That's not an oops, that's a WARN_ON.  The hardware wasn't caught up by
> the time we gave up when shutting down the harwdare for VT switching.
> That's bad.  But we don't know how long we should wait, since the GPU
> may be hung, and waiting forever would be bad.  So we warn that
> Something Bad may have happened.

I can restart X afterwards so it can't be that hung. Would you like a
reg dump next the problem occurs?

>
> It's gone with KMS since we never shut down the GPU.
>

Although I'm not switching to KMS yet due to the other issues I'm
seeing (see xorg mails). But with KMS enabled we still see some things
like:

[  660.644103] [drm] TMDS-8: set mode  2f
[  960.272242] INFO: task events/0:9 blocked for more than 120 seconds.
[  960.272245] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  960.272248] events/0      D ffff8800b70a58c0     0     9      2
[  960.272254]  ffff8800b70b5de0 0000000000000046 ffff8800b103dc41
ffff880001028980
[  960.272260]  0000000000004000 0000000000010dc0 000000000000ca38
ffff8800b0d31678
[  960.272265]  ffff8800b70b5d60 ffff8800b70a58c0 ffffffff80648350
ffff8800b70a5c48
[  960.272270] Call Trace:
[  960.272280]  [<ffffffff804bfce6>] ? thread_return+0x3e/0xaa
[  960.272285]  [<ffffffff804c0589>] __mutex_lock_slowpath+0xdf/0x129
[  960.272290]  [<ffffffff804c092d>] mutex_lock+0x23/0x3b
[  960.272295]  [<ffffffff803cecd3>] i915_gem_retire_work_handler+0x2d/0x6b
[  960.272301]  [<ffffffff80247666>] worker_thread+0x176/0x20f
[  960.272306]  [<ffffffff803ceca6>] ? i915_gem_retire_work_handler+0x0/0x6b
[  960.272311]  [<ffffffff8024b463>] ? autoremove_wake_function+0x0/0x3d
[  960.272315]  [<ffffffff802474f0>] ? worker_thread+0x0/0x20f
[  960.272319]  [<ffffffff802474f0>] ? worker_thread+0x0/0x20f
[  960.272323]  [<ffffffff8024b061>] kthread+0x5b/0x88
[  960.272329]  [<ffffffff8020c0ba>] child_rip+0xa/0x20
[  960.272333]  [<ffffffff8024b006>] ? kthread+0x0/0x88
[  960.272337]  [<ffffffff8020c0b0>] ? child_rip+0x0/0x20

So are you sure this is a !KMS related thing?

-- 
Alex, homepage: http://www.bennee.com/~alex/
CV: http://www.bennee.com/~alex/cv.php
