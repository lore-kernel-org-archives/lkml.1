Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab0BTPPB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 10:15:01 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:56131 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab0BTPPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 10:15:00 -0500
Subject: Re: sysfs lockdep complaint
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20100220150327.GG3000@hack>
References: <1266485543.6539.4.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200126x22b262b3r8b9b58e3cee34077@mail.gmail.com>
	 <1266664814.11514.5.camel@jlt3.sipsolutions.net>
	 <20100220135122.GB3000@hack>
	 <1266674493.18465.9.camel@jlt3.sipsolutions.net>
	 <20100220150327.GG3000@hack>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Feb 2010 16:14:58 +0100
Message-ID: <1266678898.17363.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-20 at 23:03 +0800, Américo Wang wrote:

> This should be fixed by the following patch, it is based on the
> 4 patches from Eric.

Thanks, one down.

[    1.556276] windfarm: initializing for dual-core desktop G5
[    1.822554] BUG: key 6b6b6b6b6b6b6b6b not in .data!
[    1.827044] ------------[ cut here ]------------
[    1.831498] Badness at kernel/lockdep.c:2706
[    1.836013] NIP: c0000000000b6a3c LR: c0000000000b6a20 CTR: 0000000000000000
[    1.840721] REGS: c0000002161976a0 TRAP: 0700   Not tainted  (2.6.33-rc8-00140-g4ec62b2-dirty)
[    1.845620] MSR: 9000000000029032 <EE,ME,CE,IR,DR>  CR: 24000022  XER: 000fffff
[    1.850679] TASK = c000000216198000[1] 'swapper' THREAD: c000000216194000 CPU: 1
[    1.850884] GPR00: 0000000000000000 c000000216197920 c000000000b10328 0000000000000001 
[    1.856050] GPR04: 0000000000000001 c000000000070d0c 0000000000000000 0000000000000002 
[    1.861327] GPR08: 0000000000000000 c0000000014320f0 0000000000000001 c000000000b27638 
[    1.866640] GPR12: 0000000024000044 c000000000b21680 0000000000000056 0000000001400000 
[    1.871978] GPR16: 0000000000240ee0 c000000000718923 c0000000007ff6ec 000000000000005e 
[    1.877351] GPR20: c0000000007e6118 c000000002b74a58 c000000216194080 c000000002b74a70 
[    1.882770] GPR24: 0000000000000000 0000000000000000 fffffffffffffff4 c00000021643ee40 
[    1.888249] GPR28: 6b6b6b6b6b6b6b6b c00000021644b188 c000000000a77780 c000000216197920 
[    1.899228] NIP [c0000000000b6a3c] .lockdep_init_map+0x148/0x66c
[    1.904944] LR [c0000000000b6a20] .lockdep_init_map+0x12c/0x66c
[    1.910740] Call Trace:
[    1.916549] [c000000216197920] [c0000000000b6a08] .lockdep_init_map+0x114/0x66c (unreliable)
[    1.922686] [c000000216197a20] [c0000000001efd58] .sysfs_add_file_mode+0x90/0x124
[    1.928883] [c000000216197ae0] [c0000000001efe28] .sysfs_add_file+0x3c/0x50
[    1.935088] [c000000216197b80] [c0000000001eff84] .sysfs_create_file+0x5c/0x74
[    1.941348] [c000000216197c20] [c000000000429284] .device_create_file+0x40/0x5c
[    1.941356] [c000000216197cc0] [c000000000440fec] .wf_register_sensor+0x108/0x178
[    1.941363] [c000000216197d70] [c0000000007e6368] .smu_sensors_init+0x3b8/0x690
[    1.941369] [c000000216197e40] [c0000000000084e4] .do_one_initcall+0xac/0x204
[    1.941374] [c000000216197ef0] [c0000000007b84b8] .kernel_init+0x1f0/0x270
[    1.941380] [c000000216197f90] [c000000000028f8c] .kernel_thread+0x54/0x70
[    1.941383] Instruction dump:
[    1.941385] e93e81c8 80090000 2f800000 409e04f4 482fa5e5 60000000 2fa30000 419e04e4 
[    1.941395] e93e81d0 80090000 2f800000 409e04d4 <0fe00000> 480004cc fb9d0000 e93e8018 


I think I get the point ... I'll go through myself.

johannes

