Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab0BTOBk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:01:40 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:55513 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab0BTOBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:01:39 -0500
Subject: Re: sysfs lockdep complaint
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20100220135122.GB3000@hack>
References: <1266485543.6539.4.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200126x22b262b3r8b9b58e3cee34077@mail.gmail.com>
	 <1266664814.11514.5.camel@jlt3.sipsolutions.net>
	 <20100220135122.GB3000@hack>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Feb 2010 15:01:33 +0100
Message-ID: <1266674493.18465.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-20 at 21:51 +0800, Américo Wang wrote:

> Please send us the backtraces you got, we could expect this.

The first one is fun:

[    1.576226] windfarm: initializing for dual-core desktop G5
[    1.577182] BUG: key 6b6b6b6b6b6b6b6b not in .data!
[    1.577190] ------------[ cut here ]------------
[    1.577192] Badness at kernel/lockdep.c:2706
[    1.577196] NIP: c0000000000b6a68 LR: c0000000000b6a4c CTR: c0000000003afedc
[    1.577200] REGS: c000000216197620 TRAP: 0700   Not tainted  (2.6.33-rc8-wl-64022-gcdee415-dirty)
[    1.577203] MSR: 9000000000029032 <EE,ME,CE,IR,DR>  CR: 28000082  XER: 200fffff
[    1.577214] TASK = c000000216198000[1] 'swapper' THREAD: c000000216194000 CPU: 2
[    1.577217] GPR00: 0000000000000000 c0000002161978a0 c000000000b10328 0000000000000001 
[    1.577223] GPR04: 0000000000000001 c000000000071638 0000000000000000 0000000000000002 
[    1.577229] GPR08: 0000000000000000 c0000000014320f0 0000000000000001 c000000000b27638 
[    1.577235] GPR12: 0000000000000041 c000000000b21880 0000000000000056 0000000001400000 
[    1.577241] GPR16: 0000000000240ee0 c000000000718923 c0000000007ff6ec 000000000000005e 
[    1.577247] GPR20: 00000000ffb30f40 c0000000007188b9 0000000000000000 0000000000240ed0 
[    1.577253] GPR24: 0000000000000108 0000000000000000 fffffffffffffff4 c00000021488b000 
[    1.577259] GPR28: 6b6b6b6b6b6b6b6b c00000021488bcc8 c000000000a77780 c0000002161978a0 
[    1.577271] NIP [c0000000000b6a68] .lockdep_init_map+0x148/0x66c
[    1.577276] LR [c0000000000b6a4c] .lockdep_init_map+0x12c/0x66c
[    1.577278] Call Trace:
[    1.577282] [c0000002161978a0] [c0000000000b6a34] .lockdep_init_map+0x114/0x66c (unreliable)
[    1.577289] [c0000002161979a0] [c0000000001efd88] .sysfs_add_file_mode+0x90/0x124
[    1.577294] [c000000216197a60] [c0000000001efe58] .sysfs_add_file+0x3c/0x50
[    1.577299] [c000000216197b00] [c0000000001effb4] .sysfs_create_file+0x5c/0x74
[    1.577305] [c000000216197ba0] [c0000000004292b0] .device_create_file+0x40/0x5c
[    1.577311] [c000000216197c40] [c000000000441178] .wf_register_control+0x108/0x178
[    1.577316] [c000000216197cf0] [c0000000004440a4] .smu_fan_create+0x548/0x598
[    1.577323] [c000000216197da0] [c0000000007e5e6c] .smu_controls_init+0xb0/0x1f4
[    1.577329] [c000000216197e40] [c0000000000084e4] .do_one_initcall+0xac/0x204
[    1.577335] [c000000216197ef0] [c0000000007b84b8] .kernel_init+0x1f0/0x270
[    1.577340] [c000000216197f90] [c000000000028f8c] .kernel_thread+0x54/0x70
[    1.577343] Instruction dump:
[    1.577346] e93e81c8 80090000 2f800000 409e04f4 482fa5e9 60000000 2fa30000 419e04e4 
[    1.577355] e93e81d0 80090000 2f800000 409e04d4 <0fe00000> 480004cc fb9d0000 e93e8018 
[    1.577375] BUG: key 6b6b6b6b6b6b6b6b not in .data!
[    1.577385] BUG: key 6b6b6b6b6b6b6b6b not in .data!
[    1.577397] BUG: key 6b6b6b6b6b6b6b6b not in .data!
[    1.577413] BUG: key 6b6b6b6b6b6b6b6b not in .data!
[    1.577423] BUG: key 6b6b6b6b6b6b6b6b not in .data!
[    1.577435] BUG: key 6b6b6b6b6b6b6b6b not in .data!
[    1.577446] BUG: key 6b6b6b6b6b6b6b6b not in .data!
[    1.839465] BUG: key 6b6b6b6b6b6b6b6b not in .data!

key pointing to something freed? wtf?

johannes

