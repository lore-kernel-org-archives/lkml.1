Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbYCCOEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbYCCOEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 09:04:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbYCCOEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 09:04:22 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:8155 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbYCCOET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 09:04:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type;
        b=RoQC8j6lc6FzaXXs8RJOpA2Lhdp7TT3N/EnO9CBpXbA2wZF+gsOzOmOdQtzaYFtChybdTQ6RgTi5d/gMLLroaCcosFGHPyM0SpGNw9R2wJaXyZK1E3M3mAcn9J8pOWDZakoIDuyOT5ME1JbXUGVTllKHfzsTZLKlwu+C8jGHfD8=
Message-ID: <47CC055C.5090001@gmail.com>
Date: Mon, 03 Mar 2008 15:04:12 +0100
From: Jiri Olsa <olsajiri@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nadia Derbey <Nadia.Derbey@bull.net>, peifferp@gmail.com
Subject: Re: [BUG] soft lockup detected with ipcs
References: <47C7E280.4010805@gmail.com> <Pine.LNX.4.64.0802291241080.7699@twin.jikos.cz> <47CAE7D5.5040907@gmail.com> <20080302120236.61e0ec74.akpm@linux-foundation.org> <Pine.LNX.4.64.0803022214190.15209@jikos.suse.cz> <Pine.LNX.4.64.0803022223360.15209@jikos.suse.cz> <47CBE871.4090309@gmail.com> <Pine.LNX.4.64.0803031305090.15209@jikos.suse.cz> <47CBECB8.7040605@gmail.com> <Pine.LNX.4.64.0803031324200.15209@jikos.suse.cz> <47CBF12C.2070506@gmail.com>
In-Reply-To: <47CBF12C.2070506@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------020907030103060706030500"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020907030103060706030500
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jiri Olsa wrote:
> Jiri Kosina wrote:
>> On Mon, 3 Mar 2008, Jiri Olsa wrote:
>>
>>> ipcs.kernel.out.1 is the kernel log from the time strace ipcs was done.
>>> ipcs.kernel.out.2 is from the next run of ipcs that stuck,
>>> there's no overlay between those logs.
>>> When the kernel freeze I'm getting logs with the spinlock lockup.. and it's repeating.
>> Thanks. Have you tried turning lockdep off, if that still triggers?
>>
>> Aparently the first BUG leaves the spin lock locked, and all subsequent 
>> accessess to it lock the machine hard. We'll need to see what goes wrong 
>> inside lockdep.
>>
>> Could you please run
>>
>> 	addr2line -e vmlinux c0133034
>>
>> (passing the path to the vmlinux binary of the crashing kernel to the -e 
>> parameter).
>>
> 
> I've rebuilt the kernel meanwhile, so dont know how accurate this output is:
> 
> /home/jirka/xxx/kernel/linux-2.6-stable/include/asm/atomic_32.h:97
> 
> Anyway, I'll run the test again with your patch, and then we can run the addrline again...
> I'll try to turn the lockdep off as well.

I applied you diff and ran the test again..


your patch with LOCKDEP enabled:

ipcs.strace.1		- strace of ipcs from the first run
ipcs.kernel.out.1 	- kernel logs from 1st strace ipcs run
ipcs.kernel.out.2 	- kernel logs from 2nd strace ipcs run - system freezed


your patch with LOCKDEP disabled:

ipcs.kernel.out-NO_LOCKDEP.1 - kernel logs from 1st strace ipcs run - system freezed


maybe I overlooked smth, but following is the only way I found 
how to disable LOCKDEP, hope it is fine... let me know:

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 80b7ba4..2bfd8dc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -43,7 +43,7 @@ config GENERIC_CLOCKEVENTS_BROADCAST
 
 config LOCKDEP_SUPPORT
        bool
-       default y
+       default n
 
 config STACKTRACE_SUPPORT
        bool


--------------020907030103060706030500
Content-Type: text/plain;
 name="ipcs.kernel.out.1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipcs.kernel.out.1"

[   45.744724] out: d97b3c78
[   45.745104] out: d97b3c78
[   45.745681] out: d97b3c78
[   45.745952] out: d97b3c78
[   45.746212] out: d97b3c78
[   45.746804] out: d97b3d10
[   45.747050] out: d97b3d10
[   45.747474] out: d97b3d10
[   45.747738] out: d97b3d10
[   45.747997] out: d97b3d10
[   45.748759] out: d97b3130
[   45.749141] out: d97b3130
[   45.749565] out: d97b3130
[   45.749809] out: d97b3130
[   45.750084] out: d97b3130
[   45.750899] out: de579f70
[   45.751164] out: de579f70
[   45.751661] out: de579f70
[   45.751927] out: de579f70
[   45.752185] out: de579f70
[   45.752816] out: d97b3b48
[   45.753096] out: d97b3b48
[   45.755114] out: d97b3b48
[   45.755383] out: d97b3b48
[   45.755642] out: d97b3b48
[   45.756370] out: d97b3ab0
[   45.756635] out: d97b3ab0
[   45.757561] out: d97b3ab0
[   45.757826] out: d97b3ab0
[   45.758084] out: d97b3ab0
[   45.817231] out: d97b3ab0
[   45.817557] out: d97b3ab0
[   45.818096] out: d97b3ab0
[   45.818362] out: d97b3ab0
[   45.818621] out: d97b3ab0
[   45.819209] out: d97b3b48
[   45.819474] out: d97b3b48
[   45.819892] out: d97b3b48
[   45.820156] out: d97b3b48
[   45.820414] out: d97b3b48
[   45.821168] out: de579f70
[   45.821432] out: de579f70
[   45.821841] out: de579f70
[   45.822104] out: de579f70
[   45.822362] out: de579f70
[   45.823293] out: d97b3130
[   45.823560] out: d97b3130
[   45.824052] out: d97b3130
[   45.824317] out: d97b3130
[   45.824575] out: d97b3130
[   45.825203] out: d97b3d10
[   45.825467] out: d97b3d10
[   45.827467] out: d97b3d10
[   45.827716] out: d97b3d10
[   45.827977] out: d97b3d10
[   45.828697] out: d97b3c78
[   45.828962] out: d97b3c78
[   45.843613] out: d97b3c78
[   45.843912] out: d97b3c78
[   45.844176] out: d97b3c78
[   46.006633] out: d97b3130
[   46.007022] out: d97b3130
[   46.008177] out: d97b3130
[   46.008446] out: d97b3130
[   46.008764] out: d97b3130
[   46.009266] out: de579f70
[   46.009538] out: de579f70
[   46.009948] out: de579f70
[   46.010211] out: de579f70
[   46.010469] out: de579f70
[   46.011001] out: d97b3b48
[   46.011316] out: d97b3b48
[   46.011724] out: d97b3b48
[   46.011969] out: d97b3b48
[   46.012228] out: d97b3b48
[   46.013137] out: d97b3ab0
[   46.013412] out: d97b3ab0
[   46.013829] out: d97b3ab0
[   46.014092] out: d97b3ab0
[   46.014349] out: d97b3ab0
[   46.014978] out: d97b3098
[   46.015231] out: d97b3098
[   46.015702] out: d97b3098
[   46.015966] out: d97b3098
[   46.016207] out: d97b3098
[   46.016713] out: d97b3d10
[   46.017252] out: d97b3d10
[   46.017664] out: d97b3d10
[   46.017926] out: d97b3d10
[   46.018184] out: d97b3d10
[   46.018692] out: d97b3a18
[   46.018963] out: d97b3a18
[   46.019366] out: d97b3a18
[   46.019628] out: d97b3a18
[   46.019888] out: d97b3a18
[   46.020783] out: df2e6558
[   46.021057] out: df2e6558
[   46.021474] out: df2e6558
[   46.021718] out: df2e6558
[   46.021996] out: df2e6558
[   46.022455] out: d97b3e40
[   46.022707] out: d97b3e40
[   46.023112] out: d97b3e40
[   46.023375] out: d97b3e40
[   46.023634] out: d97b3e40
[   46.024141] out: d97b31c8
[   46.024411] out: d97b31c8
[   46.024840] out: d97b31c8
[   46.025103] out: d97b31c8
[   46.025362] out: d97b31c8
[   46.107621] out: df2e6558
[   46.108076] out: df2e6558
[   46.108514] out: df2e6558
[   46.108784] out: df2e6558
[   46.109045] out: df2e6558
[   46.109527] out: d97b3a18
[   46.109795] out: d97b3a18
[   46.110207] out: d97b3a18
[   46.110473] out: d97b3a18
[   46.110731] out: d97b3a18
[   46.111328] out: d97b31c8
[   46.111595] out: d97b31c8
[   46.112017] out: d97b31c8
[   46.112280] out: d97b31c8
[   46.112538] out: d97b31c8
[   46.113994] out: d97b3e40
[   46.114277] out: d97b3e40
[   46.114717] out: d97b3e40
[   46.114981] out: d97b3e40
[   46.115239] out: d97b3e40
[   46.116056] out: d97b3d10
[   46.116329] out: d97b3d10
[   46.117262] out: d97b3d10
[   46.117528] out: d97b3d10
[   46.117787] out: d97b3d10
[   46.118436] out: d97b3098
[   46.118711] out: d97b3098
[   46.119126] out: d97b3098
[   46.119389] out: d97b3098
[   46.119646] out: d97b3098
[   46.120241] out: df2e6558
[   46.120507] out: df2e6558
[   46.120910] out: df2e6558
[   46.121173] out: df2e6558
[   46.121431] out: df2e6558
[   46.122847] out: d97b3ab0
[   46.123103] out: d97b3ab0
[   46.123560] out: d97b3ab0
[   46.123973] out: d97b3ab0
[   46.124239] out: d97b3ab0
[   46.124718] out: d97b3b48
[   46.124985] out: d97b3b48
[   46.125389] out: d97b3b48
[   46.125653] out: d97b3b48
[   46.125910] out: d97b3b48
[   46.126451] out: de579f70
[   46.126719] out: de579f70
[   46.127122] out: de579f70
[   46.127384] out: de579f70
[   46.127641] out: de579f70
[   48.703005] out: d97b3b48
[   48.703375] out: d97b3b48
[   48.703960] out: d97b3b48
[   48.704229] out: d97b3b48
[   48.704488] out: d97b3b48
[   48.705159] out: d97b3ab0
[   48.705424] out: d97b3ab0
[   48.705849] out: d97b3ab0
[   48.706112] out: d97b3ab0
[   48.706351] out: d97b3ab0
[   48.706915] out: df2e6558
[   48.707179] out: df2e6558
[   48.707593] out: df2e6558
[   48.707855] out: df2e6558
[   48.708112] out: df2e6558
[   48.709208] out: d97b3098
[   48.709475] out: d97b3098
[   48.709907] out: d97b3098
[   48.710170] out: d97b3098
[   48.710427] out: d97b3098
[   48.711413] out: d97b3d10
[   48.711678] out: d97b3d10
[   48.712176] out: d97b3d10
[   48.712441] out: d97b3d10
[   48.712699] out: d97b3d10
[   48.713347] out: d97b3e40
[   48.713611] out: d97b3e40
[   48.715999] out: d97b3e40
[   48.716268] out: d97b3e40
[   48.716527] out: d97b3e40
[   48.717272] out: d97b3ab0
[   48.717537] out: d97b3ab0
[   48.718592] out: d97b3ab0
[   48.718837] out: d97b3ab0
[   48.719098] out: d97b3ab0
[   48.934400] out: d97b3ab0
[   48.934761] out: d97b3ab0
[   48.935345] out: d97b3ab0
[   48.935593] out: d97b3ab0
[   48.935869] out: d97b3ab0
[   48.936523] out: d97b3e40
[   48.936804] out: d97b3e40
[   48.937227] out: d97b3e40
[   48.937491] out: d97b3e40
[   48.937748] out: d97b3e40
[   48.938310] out: d97b3d10
[   48.938573] out: d97b3d10
[   48.938986] out: d97b3d10
[   48.939251] out: d97b3d10
[   48.939509] out: d97b3d10
[   48.940544] out: d97b3098
[   48.940921] out: d97b3098
[   48.941358] out: d97b3098
[   48.941621] out: d97b3098
[   48.941880] out: d97b3098
[   48.942864] out: df2e6558
[   48.943128] out: df2e6558
[   48.943626] out: df2e6558
[   48.943891] out: df2e6558
[   48.944150] out: df2e6558
[   48.944799] out: d97b3b48
[   48.945064] out: d97b3b48
[   48.947440] out: d97b3b48
[   48.947709] out: d97b3b48
[   48.947968] out: d97b3b48
[   48.948710] out: d97b31c8
[   48.948991] out: d97b31c8
[   48.950106] out: d97b31c8
[   48.950372] out: d97b31c8
[   48.950662] out: d97b31c8
[   49.465371] info: dee9fca4
[   49.465397] BUG: unable to handle kernel NULL pointer dereference at virtual address 000000bf
[   49.465411] printing eip: c0133034 *pde = 00000000 
[   49.465432] Oops: 0002 [#1] 
[   49.465445] Modules linked in: netconsole i915 drm configfs e1000 snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd snd_page_alloc
[   49.465534] 
[   49.465542] Pid: 4763, comm: ipcs Not tainted (2.6.24.3test-dirty #22)
[   49.465550] EIP: 0060:[<c0133034>] EFLAGS: 00010086 CPU: 0
[   49.465568] EIP is at __lock_acquire+0x319/0xc20
[   49.465575] EAX: 00000002 EBX: 00000246 ECX: dee9fcb4 EDX: 00000002
[   49.465583] ESI: ffffffff EDI: 00000000 EBP: d8c9fe74 ESP: d8c9fe18
[   49.465591]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   49.465599] Process ipcs (pid: 4763, ti=d8c9e000 task=d8d181b0 task.ti=d8c9e000)
[   49.465606] Stack: 00000012 c0456032 d8c9fea4 00000246 d8c9fe66 c03875bc 00000002 00000000 
[   49.465667]        00000000 dee9fcb4 845dad28 d8d181b0 00000031 00000000 000001e1 00000246 
[   49.465731]        00000021 845dad28 1bbd0328 373c0000 00000246 00000000 00000000 d8c9fe9c 
[   49.465792] Call Trace:
[   49.465803]  [<c0103e9f>] show_trace_log_lvl+0x1a/0x2f
[   49.465820]  [<c0103f51>] show_stack_log_lvl+0x9d/0xa5
[   49.465841]  [<c0104006>] show_registers+0xad/0x17c
[   49.465859]  [<c01041cc>] die+0xf7/0x1c8
[   49.465872]  [<c0110e31>] do_page_fault+0x464/0x54b
[   49.465886]  [<c030108a>] error_code+0x6a/0x70
[   49.465904]  [<c01339b3>] lock_acquire+0x78/0x91
[   49.465918]  [<c0300a55>] _spin_lock+0x2e/0x58
[   49.465931]  [<c01b8e91>] sys_shmctl+0x70b/0x78a
[   49.465947]  [<c0106d33>] sys_ipc+0x19f/0x1b5
[   49.465964]  [<c0102fa6>] syscall_call+0x7/0xb
[   49.465977]  =======================
[   49.465984] Code: 00 85 c0 0f 84 1d 09 00 00 83 3d 00 bf 6f c0 00 0f 85 10 09 00 00 c7 44 24 0c c8 8b 30 c0 c7 44 24 08 26 03 00 00 e9 8b 07 00 00 <ff> 86 c0 00 00 00 8b 45 d0 8b 80 54 06 00 00 83 f8 1d 89 45 cc 
[   49.466387] EIP: [<c0133034>] __lock_acquire+0x319/0xc20 SS:ESP 0068:d8c9fe18
[   49.466415] ---[ end trace 952d67b8119a426f ]---

--------------020907030103060706030500
Content-Type: text/plain;
 name="ipcs.kernel.out.2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipcs.kernel.out.2"

[   56.366081] info: dee9fca4
[   67.820203] BUG: soft lockup - CPU#0 stuck for 11s! [ipcs:4769]
[   67.820212] 
[   67.820221] Pid: 4769, comm: ipcs Tainted: G      D (2.6.24.3test-dirty #22)
[   67.820229] EIP: 0060:[<c01cef62>] EFLAGS: 00000246 CPU: 0
[   67.820242] EIP is at delay_tsc+0xe/0x17
[   67.820249] EAX: 43d68683 EBX: 00000001 ECX: 43d68650 EDX: 00000019
[   67.820257] ESI: 0990224e EDI: 00000001 EBP: d8d69e68 ESP: d8d69e64
[   67.820265]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   67.820273] CR0: 8005003b CR2: 08053c30 CR3: 1f1e5000 CR4: 000006d0
[   67.820281] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   67.820288] DR6: ffff0ff0 DR7: 00000400
[   67.820296]  [<c0103e9f>] show_trace_log_lvl+0x1a/0x2f
[   67.820312]  [<c0104784>] show_trace+0x12/0x14
[   67.820326]  [<c010163e>] show_regs+0x1c/0x1f
[   67.820340]  [<c013b9f8>] softlockup_tick+0xce/0xe7
[   67.820354]  [<c01202a7>] run_local_timers+0x12/0x14
[   67.820372]  [<c01204b6>] update_process_times+0x1b/0x3f
[   67.820386]  [<c012f3a3>] tick_periodic+0x65/0x71
[   67.820402]  [<c012f3c1>] tick_handle_periodic+0x12/0x61
[   67.820417]  [<c0105d27>] timer_interrupt+0x37/0x3e
[   67.820431]  [<c013bcae>] handle_IRQ_event+0x1a/0x46
[   67.820445]  [<c013d0e3>] handle_level_irq+0x6f/0xb8
[   67.820459]  [<c010517a>] do_IRQ+0x78/0x8f
[   67.820476]  [<c01039b6>] common_interrupt+0x2e/0x34
[   67.820492]  [<c01cef39>] __delay+0x9/0xb
[   67.820505]  [<c01dc709>] _raw_spin_lock+0x7f/0xd8
[   67.820521]  [<c0300a71>] _spin_lock+0x4a/0x58
[   67.820541]  [<c01b8e91>] sys_shmctl+0x70b/0x78a
[   67.820557]  [<c0106d33>] sys_ipc+0x19f/0x1b5
[   67.820571]  [<c0102fa6>] syscall_call+0x7/0xb
[   67.820589]  =======================
[   79.618857] BUG: soft lockup - CPU#0 stuck for 11s! [ipcs:4769]
[   79.618865] 
[   79.618872] Pid: 4769, comm: ipcs Tainted: G      D (2.6.24.3test-dirty #22)
[   79.618880] EIP: 0060:[<c01cef64>] EFLAGS: 00000206 CPU: 0
[   79.618888] EIP is at delay_tsc+0x10/0x17
[   79.618895] EAX: 00000033 EBX: 00000001 ECX: a90b9a87 EDX: 0000001d
[   79.618903] ESI: 1369e317 EDI: 00000001 EBP: d8d69e68 ESP: d8d69e64
[   79.618910]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   79.618918] CR0: 8005003b CR2: 08053c30 CR3: 1f1e5000 CR4: 000006d0
[   79.618926] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   79.618933] DR6: ffff0ff0 DR7: 00000400
[   79.618940]  [<c0103e9f>] show_trace_log_lvl+0x1a/0x2f
[   79.618954]  [<c0104784>] show_trace+0x12/0x14
[   79.618967]  [<c010163e>] show_regs+0x1c/0x1f
[   79.618980]  [<c013b9f8>] softlockup_tick+0xce/0xe7
[   79.618993]  [<c01202a7>] run_local_timers+0x12/0x14
[   79.619008]  [<c01204b6>] update_process_times+0x1b/0x3f
[   79.619022]  [<c012f3a3>] tick_periodic+0x65/0x71
[   79.619036]  [<c012f3c1>] tick_handle_periodic+0x12/0x61
[   79.619050]  [<c0105d27>] timer_interrupt+0x37/0x3e
[   79.619064]  [<c013bcae>] handle_IRQ_event+0x1a/0x46
[   79.619077]  [<c013d0e3>] handle_level_irq+0x6f/0xb8
[   79.619090]  [<c010517a>] do_IRQ+0x78/0x8f
[   79.619103]  [<c01039b6>] common_interrupt+0x2e/0x34
[   79.619118]  [<c01cef39>] __delay+0x9/0xb
[   79.619131]  [<c01dc709>] _raw_spin_lock+0x7f/0xd8
[   79.619145]  [<c0300a71>] _spin_lock+0x4a/0x58
[   79.619158]  [<c01b8e91>] sys_shmctl+0x70b/0x78a
[   79.619172]  [<c0106d33>] sys_ipc+0x19f/0x1b5
[   79.619184]  [<c0102fa6>] syscall_call+0x7/0xb
[   79.619198]  =======================
[   91.421508] BUG: soft lockup - CPU#0 stuck for 11s! [ipcs:4769]
[   91.421515] 
[   91.421523] Pid: 4769, comm: ipcs Tainted: G      D (2.6.24.3test-dirty #22)
[   91.421531] EIP: 0060:[<c01cef5e>] EFLAGS: 00000246 CPU: 0
[   91.421539] EIP is at delay_tsc+0xa/0x17
[   91.421546] EAX: 0ea242e8 EBX: 00000001 ECX: 0ea242e8 EDX: 00000022
[   91.421554] ESI: 1d4480eb EDI: 00000001 EBP: d8d69e68 ESP: d8d69e64
[   91.421561]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   91.421569] CR0: 8005003b CR2: 08053c30 CR3: 1f1e5000 CR4: 000006d0
[   91.421576] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   91.421584] DR6: ffff0ff0 DR7: 00000400
[   91.421590]  [<c0103e9f>] show_trace_log_lvl+0x1a/0x2f
[   91.421604]  [<c0104784>] show_trace+0x12/0x14
[   91.421618]  [<c010163e>] show_regs+0x1c/0x1f
[   91.421631]  [<c013b9f8>] softlockup_tick+0xce/0xe7
[   91.421644]  [<c01202a7>] run_local_timers+0x12/0x14
[   91.421659]  [<c01204b6>] update_process_times+0x1b/0x3f
[   91.421672]  [<c012f3a3>] tick_periodic+0x65/0x71
[   91.421687]  [<c012f3c1>] tick_handle_periodic+0x12/0x61
[   91.421701]  [<c0105d27>] timer_interrupt+0x37/0x3e
[   91.421715]  [<c013bcae>] handle_IRQ_event+0x1a/0x46
[   91.421728]  [<c013d0e3>] handle_level_irq+0x6f/0xb8
[   91.421741]  [<c010517a>] do_IRQ+0x78/0x8f
[   91.421754]  [<c01039b6>] common_interrupt+0x2e/0x34
[   91.421769]  [<c01cef39>] __delay+0x9/0xb
[   91.421782]  [<c01dc709>] _raw_spin_lock+0x7f/0xd8
[   91.421796]  [<c0300a71>] _spin_lock+0x4a/0x58
[   91.421809]  [<c01b8e91>] sys_shmctl+0x70b/0x78a
[   91.421823]  [<c0106d33>] sys_ipc+0x19f/0x1b5
[   91.421835]  [<c0102fa6>] syscall_call+0x7/0xb
[   91.421849]  =======================
[  103.224159] BUG: soft lockup - CPU#0 stuck for 11s! [ipcs:4769]
[  103.224166] 
[  103.224174] Pid: 4769, comm: ipcs Tainted: G      D (2.6.24.3test-dirty #22)
[  103.224181] EIP: 0060:[<c01cef5c>] EFLAGS: 00000246 CPU: 0
[  103.224190] EIP is at delay_tsc+0x8/0x17
[  103.224197] EAX: 7438eb52 EBX: 00000001 ECX: 7438eae0 EDX: 00000026
[  103.224205] ESI: 271f24ee EDI: 00000001 EBP: d8d69e68 ESP: d8d69e64
[  103.224212]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  103.224220] CR0: 8005003b CR2: 08053c30 CR3: 1f1e5000 CR4: 000006d0
[  103.224227] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  103.224235] DR6: ffff0ff0 DR7: 00000400
[  103.224242]  [<c0103e9f>] show_trace_log_lvl+0x1a/0x2f
[  103.224255]  [<c0104784>] show_trace+0x12/0x14
[  103.224269]  [<c010163e>] show_regs+0x1c/0x1f
[  103.224282]  [<c013b9f8>] softlockup_tick+0xce/0xe7
[  103.224295]  [<c01202a7>] run_local_timers+0x12/0x14
[  103.224310]  [<c01204b6>] update_process_times+0x1b/0x3f
[  103.224323]  [<c012f3a3>] tick_periodic+0x65/0x71
[  103.224338]  [<c012f3c1>] tick_handle_periodic+0x12/0x61
[  103.224352]  [<c0105d27>] timer_interrupt+0x37/0x3e
[  103.224366]  [<c013bcae>] handle_IRQ_event+0x1a/0x46
[  103.224379]  [<c013d0e3>] handle_level_irq+0x6f/0xb8
[  103.224392]  [<c010517a>] do_IRQ+0x78/0x8f
[  103.224405]  [<c01039b6>] common_interrupt+0x2e/0x34
[  103.224420]  [<c01cef39>] __delay+0x9/0xb
[  103.224432]  [<c01dc709>] _raw_spin_lock+0x7f/0xd8
[  103.224447]  [<c0300a71>] _spin_lock+0x4a/0x58
[  103.224460]  [<c01b8e91>] sys_shmctl+0x70b/0x78a
[  103.224473]  [<c0106d33>] sys_ipc+0x19f/0x1b5
[  103.224486]  [<c0102fa6>] syscall_call+0x7/0xb
[  103.224499]  =======================
[  115.022813] BUG: soft lockup - CPU#0 stuck for 11s! [ipcs:4769]
[  115.022820] 
[  115.022828] Pid: 4769, comm: ipcs Tainted: G      D (2.6.24.3test-dirty #22)
[  115.022835] EIP: 0060:[<c01cef64>] EFLAGS: 00000206 CPU: 0
[  115.022844] EIP is at delay_tsc+0x10/0x17
[  115.022851] EAX: 00000033 EBX: 00000001 ECX: d96dff39 EDX: 0000002a
[  115.022858] ESI: 30f8e7fe EDI: 00000001 EBP: d8d69e68 ESP: d8d69e64
[  115.022866]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  115.022873] CR0: 8005003b CR2: 08053c30 CR3: 1f1e5000 CR4: 000006d0
[  115.022881] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  115.022888] DR6: ffff0ff0 DR7: 00000400
[  115.022895]  [<c0103e9f>] show_trace_log_lvl+0x1a/0x2f
[  115.022909]  [<c0104784>] show_trace+0x12/0x14
[  115.022922]  [<c010163e>] show_regs+0x1c/0x1f
[  115.022935]  [<c013b9f8>] softlockup_tick+0xce/0xe7
[  115.022949]  [<c01202a7>] run_local_timers+0x12/0x14
[  115.022963]  [<c01204b6>] update_process_times+0x1b/0x3f
[  115.022978]  [<c012f3a3>] tick_periodic+0x65/0x71
[  115.022991]  [<c012f3c1>] tick_handle_periodic+0x12/0x61
[  115.023005]  [<c0105d27>] timer_interrupt+0x37/0x3e
[  115.023018]  [<c013bcae>] handle_IRQ_event+0x1a/0x46
[  115.023032]  [<c013d0e3>] handle_level_irq+0x6f/0xb8
[  115.023045]  [<c010517a>] do_IRQ+0x78/0x8f
[  115.023059]  [<c01039b6>] common_interrupt+0x2e/0x34
[  115.023072]  [<c01cef39>] __delay+0x9/0xb
[  115.023085]  [<c01dc709>] _raw_spin_lock+0x7f/0xd8
[  115.023099]  [<c0300a71>] _spin_lock+0x4a/0x58
[  115.023112]  [<c01b8e91>] sys_shmctl+0x70b/0x78a
[  115.023125]  [<c0106d33>] sys_ipc+0x19f/0x1b5
[  115.023138]  [<c0102fa6>] syscall_call+0x7/0xb
[  115.023151]  =======================
[  126.825464] BUG: soft lockup - CPU#0 stuck for 11s! [ipcs:4769]
[  126.825471] 
[  126.825479] Pid: 4769, comm: ipcs Tainted: G      D (2.6.24.3test-dirty #22)
[  126.825486] EIP: 0060:[<c01cef62>] EFLAGS: 00000246 CPU: 0
[  126.825494] EIP is at delay_tsc+0xe/0x17
[  126.825502] EAX: 3f04a7e8 EBX: 00000001 ECX: 3f04a7b5 EDX: 0000002f
[  126.825509] ESI: 3ad3830e EDI: 00000001 EBP: d8d69e68 ESP: d8d69e64
[  126.825517]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  126.825525] CR0: 8005003b CR2: 08053c30 CR3: 1f1e5000 CR4: 000006d0
[  126.825532] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  126.825539] DR6: ffff0ff0 DR7: 00000400
[  126.825546]  [<c0103e9f>] show_trace_log_lvl+0x1a/0x2f
[  126.825560]  [<c0104784>] show_trace+0x12/0x14
[  126.825573]  [<c010163e>] show_regs+0x1c/0x1f
[  126.825587]  [<c013b9f8>] softlockup_tick+0xce/0xe7
[  126.825600]  [<c01202a7>] run_local_timers+0x12/0x14
[  126.825614]  [<c01204b6>] update_process_times+0x1b/0x3f
[  126.825629]  [<c012f3a3>] tick_periodic+0x65/0x71
[  126.825643]  [<c012f3c1>] tick_handle_periodic+0x12/0x61
[  126.825656]  [<c0105d27>] timer_interrupt+0x37/0x3e
[  126.825670]  [<c013bcae>] handle_IRQ_event+0x1a/0x46
[  126.825683]  [<c013d0e3>] handle_level_irq+0x6f/0xb8
[  126.825696]  [<c010517a>] do_IRQ+0x78/0x8f
[  126.825710]  [<c01039b6>] common_interrupt+0x2e/0x34
[  126.825724]  [<c01cef39>] __delay+0x9/0xb
[  126.825737]  [<c01dc709>] _raw_spin_lock+0x7f/0xd8
[  126.825751]  [<c0300a71>] _spin_lock+0x4a/0x58
[  126.825764]  [<c01b8e91>] sys_shmctl+0x70b/0x78a
[  126.825778]  [<c0106d33>] sys_ipc+0x19f/0x1b5
[  126.825791]  [<c0102fa6>] syscall_call+0x7/0xb
[  126.825804]  =======================

--------------020907030103060706030500
Content-Type: text/plain;
 name="ipcs.kernel.out-NO_LOCKDEP.1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="ipcs.kernel.out-NO_LOCKDEP.1"

[   43.652795] info: dedcd6dc
[   43.652815] BUG: spinlock bad magic on CPU#0, ipcs/4753
[   43.652823]  lock: dedcd6dc, .magic: 00000000, .owner: ”ÙÜÞ”ÙÜÞ/0, .owner_cpu: 0
[   43.652832] Pid: 4753, comm: ipcs Not tainted 2.6.24.3test-dirty #23
[   43.652840]  [<c0103ddb>] show_trace_log_lvl+0x1a/0x2f
[   43.652860]  [<c01046c0>] show_trace+0x12/0x14
[   43.652873]  [<c0104f82>] dump_stack+0x6a/0x70
[   43.652886]  [<c01d2bde>] spin_bug+0x90/0xd7
[   43.652900]  [<c01d2ce8>] _raw_spin_lock+0x1e/0xd8
[   43.652914]  [<c02f436e>] _spin_lock+0x8/0xa
[   43.652930]  [<c01b0af5>] sys_shmctl+0x66b/0x6ea
[   43.652947]  [<c0106bd7>] sys_ipc+0x19f/0x1b5
[   43.653007]  [<c0102f62>] syscall_call+0x7/0xb
[   43.653019]  =======================
[   54.912593] BUG: soft lockup - CPU#0 stuck for 11s! [ipcs:4753]
[   54.912601] 
[   54.912607] Pid: 4753, comm: ipcs Not tainted (2.6.24.3test-dirty #23)
[   54.912615] EIP: 0060:[<c01c6974>] EFLAGS: 00000206 CPU: 0
[   54.912625] EIP is at delay_tsc+0x10/0x17
[   54.912632] EAX: 00000033 EBX: 00000001 ECX: 74df5b8a EDX: 00000014
[   54.912639] ESI: 0967b975 EDI: 00000001 EBP: d97dfe7c ESP: d97dfe78
[   54.912646]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   54.912653] CR0: 8005003b CR2: 08053c30 CR3: 1f37c000 CR4: 000006d0
[   54.912661] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   54.912667] DR6: ffff0ff0 DR7: 00000400
[   54.912674]  [<c0103ddb>] show_trace_log_lvl+0x1a/0x2f
[   54.912687]  [<c01046c0>] show_trace+0x12/0x14
[   54.912699]  [<c010164d>] show_regs+0x1c/0x1f
[   54.912712]  [<c01357e8>] softlockup_tick+0xce/0xe7
[   54.912726]  [<c011f9e7>] run_local_timers+0x12/0x14
[   54.912741]  [<c011fbf6>] update_process_times+0x1b/0x3f
[   54.912759]  [<c012e10f>] tick_periodic+0x65/0x71
[   54.912775]  [<c012e12d>] tick_handle_periodic+0x12/0x61
[   54.912787]  [<c0105ee1>] timer_interrupt+0x37/0x3e
[   54.912805]  [<c0135a72>] handle_IRQ_event+0x21/0x48
[   54.912817]  [<c0136e5b>] handle_level_irq+0x6f/0xb8
[   54.912831]  [<c0105062>] do_IRQ+0x78/0x8f
[   54.912843]  [<c010390b>] common_interrupt+0x23/0x28
[   54.912863]  [<c01c6949>] __delay+0x9/0xb
[   54.912884]  [<c01d2d49>] _raw_spin_lock+0x7f/0xd8
[   54.912896]  [<c02f436e>] _spin_lock+0x8/0xa
[   54.912914]  [<c01b0af5>] sys_shmctl+0x66b/0x6ea
[   54.912926]  [<c0106bd7>] sys_ipc+0x19f/0x1b5
[   54.912938]  [<c0102f62>] syscall_call+0x7/0xb
[   54.912950]  =======================
[   66.711247] BUG: soft lockup - CPU#0 stuck for 11s! [ipcs:4753]
[   66.711254] 
[   66.711260] Pid: 4753, comm: ipcs Not tainted (2.6.24.3test-dirty #23)
[   66.711267] EIP: 0060:[<c01c696c>] EFLAGS: 00000246 CPU: 0
[   66.711276] EIP is at delay_tsc+0x8/0x17
[   66.711282] EAX: da14701b EBX: 00000001 ECX: da146fa9 EDX: 00000018
[   66.711289] ESI: 1342a3c5 EDI: 00000001 EBP: d97dfe7c ESP: d97dfe78
[   66.711297]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   66.711304] CR0: 8005003b CR2: 08053c30 CR3: 1f37c000 CR4: 000006d0
[   66.711311] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   66.711317] DR6: ffff0ff0 DR7: 00000400
[   66.711324]  [<c0103ddb>] show_trace_log_lvl+0x1a/0x2f
[   66.711337]  [<c01046c0>] show_trace+0x12/0x14
[   66.711349]  [<c010164d>] show_regs+0x1c/0x1f
[   66.711361]  [<c01357e8>] softlockup_tick+0xce/0xe7
[   66.711373]  [<c011f9e7>] run_local_timers+0x12/0x14
[   66.711386]  [<c011fbf6>] update_process_times+0x1b/0x3f
[   66.711399]  [<c012e10f>] tick_periodic+0x65/0x71
[   66.711412]  [<c012e12d>] tick_handle_periodic+0x12/0x61
[   66.711425]  [<c0105ee1>] timer_interrupt+0x37/0x3e
[   66.711437]  [<c0135a72>] handle_IRQ_event+0x21/0x48
[   66.711450]  [<c0136e5b>] handle_level_irq+0x6f/0xb8
[   66.711462]  [<c0105062>] do_IRQ+0x78/0x8f
[   66.711475]  [<c010390b>] common_interrupt+0x23/0x28
[   66.711487]  [<c01c6949>] __delay+0x9/0xb
[   66.711500]  [<c01d2d49>] _raw_spin_lock+0x7f/0xd8
[   66.711513]  [<c02f436e>] _spin_lock+0x8/0xa
[   66.711525]  [<c01b0af5>] sys_shmctl+0x66b/0x6ea
[   66.711537]  [<c0106bd7>] sys_ipc+0x19f/0x1b5
[   66.711549]  [<c0102f62>] syscall_call+0x7/0xb
[   66.711561]  =======================
[   78.513898] BUG: soft lockup - CPU#0 stuck for 11s! [ipcs:4753]
[   78.513905] 
[   78.513911] Pid: 4753, comm: ipcs Not tainted (2.6.24.3test-dirty #23)
[   78.513918] EIP: 0060:[<c01c6974>] EFLAGS: 00000206 CPU: 0
[   78.513926] EIP is at delay_tsc+0x10/0x17
[   78.513933] EAX: 00000033 EBX: 00000001 ECX: 3fab1809 EDX: 0000001d
[   78.513940] ESI: 1d1e7dc9 EDI: 00000001 EBP: d97dfe7c ESP: d97dfe78
[   78.513947]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   78.513954] CR0: 8005003b CR2: 08053c30 CR3: 1f37c000 CR4: 000006d0
[   78.513961] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   78.513968] DR6: ffff0ff0 DR7: 00000400
[   78.513974]  [<c0103ddb>] show_trace_log_lvl+0x1a/0x2f
[   78.513987]  [<c01046c0>] show_trace+0x12/0x14
[   78.513999]  [<c010164d>] show_regs+0x1c/0x1f
[   78.514011]  [<c01357e8>] softlockup_tick+0xce/0xe7
[   78.514024]  [<c011f9e7>] run_local_timers+0x12/0x14
[   78.514036]  [<c011fbf6>] update_process_times+0x1b/0x3f
[   78.514050]  [<c012e10f>] tick_periodic+0x65/0x71
[   78.514063]  [<c012e12d>] tick_handle_periodic+0x12/0x61
[   78.514076]  [<c0105ee1>] timer_interrupt+0x37/0x3e
[   78.514088]  [<c0135a72>] handle_IRQ_event+0x21/0x48
[   78.514101]  [<c0136e5b>] handle_level_irq+0x6f/0xb8
[   78.514113]  [<c0105062>] do_IRQ+0x78/0x8f
[   78.514125]  [<c010390b>] common_interrupt+0x23/0x28
[   78.514138]  [<c01c6949>] __delay+0x9/0xb
[   78.514151]  [<c01d2d49>] _raw_spin_lock+0x7f/0xd8
[   78.514164]  [<c02f436e>] _spin_lock+0x8/0xa
[   78.514176]  [<c01b0af5>] sys_shmctl+0x66b/0x6ea
[   78.514188]  [<c0106bd7>] sys_ipc+0x19f/0x1b5
[   78.514200]  [<c0102f62>] syscall_call+0x7/0xb
[   78.514212]  =======================
[   90.312552] BUG: soft lockup - CPU#0 stuck for 11s! [ipcs:4753]
[   90.312559] 
[   90.312565] Pid: 4753, comm: ipcs Not tainted (2.6.24.3test-dirty #23)
[   90.312572] EIP: 0060:[<c01c696c>] EFLAGS: 00000246 CPU: 0
[   90.312580] EIP is at delay_tsc+0x8/0x17
[   90.312587] EAX: a4e02c74 EBX: 00000001 ECX: a4e02c02 EDX: 00000021
[   90.312594] ESI: 26f98073 EDI: 00000001 EBP: d97dfe7c ESP: d97dfe78
[   90.312601]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   90.312608] CR0: 8005003b CR2: 08053c30 CR3: 1f37c000 CR4: 000006d0
[   90.312615] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   90.312622] DR6: ffff0ff0 DR7: 00000400
[   90.312628]  [<c0103ddb>] show_trace_log_lvl+0x1a/0x2f
[   90.312641]  [<c01046c0>] show_trace+0x12/0x14
[   90.312653]  [<c010164d>] show_regs+0x1c/0x1f
[   90.312665]  [<c01357e8>] softlockup_tick+0xce/0xe7
[   90.312678]  [<c011f9e7>] run_local_timers+0x12/0x14
[   90.312691]  [<c011fbf6>] update_process_times+0x1b/0x3f
[   90.312704]  [<c012e10f>] tick_periodic+0x65/0x71
[   90.312717]  [<c012e12d>] tick_handle_periodic+0x12/0x61
[   90.312730]  [<c0105ee1>] timer_interrupt+0x37/0x3e
[   90.312742]  [<c0135a72>] handle_IRQ_event+0x21/0x48
[   90.312755]  [<c0136e5b>] handle_level_irq+0x6f/0xb8
[   90.312767]  [<c0105062>] do_IRQ+0x78/0x8f
[   90.312779]  [<c010390b>] common_interrupt+0x23/0x28
[   90.312792]  [<c01c6949>] __delay+0x9/0xb
[   90.312805]  [<c01d2d49>] _raw_spin_lock+0x7f/0xd8
[   90.312817]  [<c02f436e>] _spin_lock+0x8/0xa
[   90.312830]  [<c01b0af5>] sys_shmctl+0x66b/0x6ea
[   90.312842]  [<c0106bd7>] sys_ipc+0x19f/0x1b5
[   90.312853]  [<c0102f62>] syscall_call+0x7/0xb
[   90.312865]  =======================
[  102.115203] BUG: soft lockup - CPU#0 stuck for 11s! [ipcs:4753]
[  102.115210] 
[  102.115216] Pid: 4753, comm: ipcs Not tainted (2.6.24.3test-dirty #23)
[  102.115223] EIP: 0060:[<c01c696c>] EFLAGS: 00000246 CPU: 0
[  102.115231] EIP is at delay_tsc+0x8/0x17
[  102.115238] EAX: 0a76d4d4 EBX: 00000001 ECX: 0a76d462 EDX: 00000026
[  102.115245] ESI: 30d5546f EDI: 00000001 EBP: d97dfe7c ESP: d97dfe78
[  102.115252]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  102.115260] CR0: 8005003b CR2: 08053c30 CR3: 1f37c000 CR4: 000006d0
[  102.115267] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  102.115273] DR6: ffff0ff0 DR7: 00000400
[  102.115279]  [<c0103ddb>] show_trace_log_lvl+0x1a/0x2f
[  102.115292]  [<c01046c0>] show_trace+0x12/0x14
[  102.115305]  [<c010164d>] show_regs+0x1c/0x1f
[  102.115317]  [<c01357e8>] softlockup_tick+0xce/0xe7
[  102.115329]  [<c011f9e7>] run_local_timers+0x12/0x14
[  102.115342]  [<c011fbf6>] update_process_times+0x1b/0x3f
[  102.115355]  [<c012e10f>] tick_periodic+0x65/0x71
[  102.115368]  [<c012e12d>] tick_handle_periodic+0x12/0x61
[  102.115381]  [<c0105ee1>] timer_interrupt+0x37/0x3e
[  102.115393]  [<c0135a72>] handle_IRQ_event+0x21/0x48
[  102.115406]  [<c0136e5b>] handle_level_irq+0x6f/0xb8
[  102.115418]  [<c0105062>] do_IRQ+0x78/0x8f
[  102.115430]  [<c010390b>] common_interrupt+0x23/0x28
[  102.115443]  [<c01c6949>] __delay+0x9/0xb
[  102.115455]  [<c01d2d49>] _raw_spin_lock+0x7f/0xd8
[  102.115468]  [<c02f436e>] _spin_lock+0x8/0xa
[  102.115481]  [<c01b0af5>] sys_shmctl+0x66b/0x6ea
[  102.115493]  [<c0106bd7>] sys_ipc+0x19f/0x1b5
[  102.115504]  [<c0102f62>] syscall_call+0x7/0xb
[  102.115516]  =======================
[  113.917854] BUG: soft lockup - CPU#0 stuck for 11s! [ipcs:4753]
[  113.917861] 
[  113.917867] Pid: 4753, comm: ipcs Not tainted (2.6.24.3test-dirty #23)
[  113.917874] EIP: 0060:[<c01c6972>] EFLAGS: 00000246 CPU: 0
[  113.917882] EIP is at delay_tsc+0xe/0x17
[  113.917889] EAX: 700d7d3d EBX: 00000001 ECX: 700d7d0a EDX: 0000002a
[  113.917896] ESI: 3ab128c3 EDI: 00000001 EBP: d97dfe7c ESP: d97dfe78
[  113.917903]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  113.917910] CR0: 8005003b CR2: 08053c30 CR3: 1f37c000 CR4: 000006d0
[  113.917917] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  113.917924] DR6: ffff0ff0 DR7: 00000400
[  113.917930]  [<c0103ddb>] show_trace_log_lvl+0x1a/0x2f
[  113.917943]  [<c01046c0>] show_trace+0x12/0x14
[  113.917955]  [<c010164d>] show_regs+0x1c/0x1f
[  113.917967]  [<c01357e8>] softlockup_tick+0xce/0xe7
[  113.917980]  [<c011f9e7>] run_local_timers+0x12/0x14
[  113.917993]  [<c011fbf6>] update_process_times+0x1b/0x3f
[  113.918006]  [<c012e10f>] tick_periodic+0x65/0x71
[  113.918019]  [<c012e12d>] tick_handle_periodic+0x12/0x61
[  113.918031]  [<c0105ee1>] timer_interrupt+0x37/0x3e
[  113.918044]  [<c0135a72>] handle_IRQ_event+0x21/0x48
[  113.918057]  [<c0136e5b>] handle_level_irq+0x6f/0xb8
[  113.918069]  [<c0105062>] do_IRQ+0x78/0x8f
[  113.918081]  [<c010390b>] common_interrupt+0x23/0x28
[  113.918094]  [<c01c6949>] __delay+0x9/0xb
[  113.918107]  [<c01d2d49>] _raw_spin_lock+0x7f/0xd8
[  113.918119]  [<c02f436e>] _spin_lock+0x8/0xa
[  113.918132]  [<c01b0af5>] sys_shmctl+0x66b/0x6ea
[  113.918144]  [<c0106bd7>] sys_ipc+0x19f/0x1b5
[  113.918155]  [<c0102f62>] syscall_call+0x7/0xb
[  113.918167]  =======================
[  125.716508] BUG: soft lockup - CPU#0 stuck for 11s! [ipcs:4753]
[  125.716515] 
[  125.716521] Pid: 4753, comm: ipcs Not tainted (2.6.24.3test-dirty #23)
[  125.716528] EIP: 0060:[<c01c696c>] EFLAGS: 00000246 CPU: 0
[  125.716536] EIP is at delay_tsc+0x8/0x17
[  125.716543] EAX: d542911a EBX: 00000001 ECX: d54290a8 EDX: 0000002e
[  125.716550] ESI: 448c25dd EDI: 00000001 EBP: d97dfe7c ESP: d97dfe78
[  125.716557]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  125.716564] CR0: 8005003b CR2: 08053c30 CR3: 1f37c000 CR4: 000006d0
[  125.716571] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  125.716578] DR6: ffff0ff0 DR7: 00000400
[  125.716584]  [<c0103ddb>] show_trace_log_lvl+0x1a/0x2f
[  125.716597]  [<c01046c0>] show_trace+0x12/0x14
[  125.716609]  [<c010164d>] show_regs+0x1c/0x1f
[  125.716621]  [<c01357e8>] softlockup_tick+0xce/0xe7
[  125.716634]  [<c011f9e7>] run_local_timers+0x12/0x14
[  125.716647]  [<c011fbf6>] update_process_times+0x1b/0x3f
[  125.716660]  [<c012e10f>] tick_periodic+0x65/0x71
[  125.716673]  [<c012e12d>] tick_handle_periodic+0x12/0x61
[  125.716685]  [<c0105ee1>] timer_interrupt+0x37/0x3e
[  125.716698]  [<c0135a72>] handle_IRQ_event+0x21/0x48
[  125.716711]  [<c0136e5b>] handle_level_irq+0x6f/0xb8
[  125.716723]  [<c0105062>] do_IRQ+0x78/0x8f
[  125.716735]  [<c010390b>] common_interrupt+0x23/0x28
[  125.716748]  [<c01c6949>] __delay+0x9/0xb
[  125.716761]  [<c01d2d49>] _raw_spin_lock+0x7f/0xd8
[  125.716773]  [<c02f436e>] _spin_lock+0x8/0xa
[  125.716786]  [<c01b0af5>] sys_shmctl+0x66b/0x6ea
[  125.716798]  [<c0106bd7>] sys_ipc+0x19f/0x1b5
[  125.716809]  [<c0102f62>] syscall_call+0x7/0xb
[  125.716821]  =======================

--------------020907030103060706030500
Content-Type: text/plain;
 name="ipcs.strace.1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipcs.strace.1"

execve("/usr/bin/ipcs", ["ipcs"], [/* 37 vars */]) = 0
brk(0)                                  = 0x804e000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=60196, ...}) = 0
mmap2(NULL, 60196, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7faf000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0@e\1\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1261852, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7fae000
mmap2(NULL, 1267248, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xb7e78000
mmap2(0xb7fa8000, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x130) = 0xb7fa8000
mmap2(0xb7fab000, 9776, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7fab000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7e77000
set_thread_area({entry_number:-1 -> 6, base_addr:0xb7e776c0, limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0, useable:1}) = 0
mprotect(0xb7fa8000, 8192, PROT_READ)   = 0
mprotect(0x804c000, 4096, PROT_READ)    = 0
mprotect(0xb7fd9000, 4096, PROT_READ)   = 0
munmap(0xb7faf000, 60196)               = 0
brk(0)                                  = 0x804e000
brk(0x806f000)                          = 0x806f000
fstat64(1, {st_mode=S_IFCHR|0622, st_rdev=makedev(136, 1), ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7fbd000
write(1, "\n", 1)                       = 1
shmctl(0, IPC_64|SHM_INFO, 0xbfcadda0 <unfinished ...>
+++ killed by SIGSEGV +++

--------------020907030103060706030500--
