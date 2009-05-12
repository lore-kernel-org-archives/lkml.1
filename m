Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbZELV3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbZELV3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 17:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbZELV3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 17:29:06 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:37393 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbZELV3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 17:29:04 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: linux-kernel@vger.kernel.org, openipmi-developer@lists.sourceforge.net
Subject: modprobe ipmi_si hangs under 2.6.30-rc5
Date: Tue, 12 May 2009 23:28:59 +0200
Message-ID: <87tz3qnh7o.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On a Dell PowerEdge 2650 2.6.30-rc5 can't load the ipmi_si module.
2.6.29 has no such problems:

[   46.292160] IPMI System Interface driver.
[   46.300321] ipmi_si: Trying SMBIOS-specified smic state machine at i/o address 0xecf4, slave address 0x20, irq 0
[   46.408212] ipmi: Found new BMC (man_id: 0x0002a2,  prod_id: 0x0000, dev_id: 0x00)
[   46.423454] IPMI smic interface initialized

But under 2.6.30-rc5:

# modprobe ipmi_si bt_debug=7 smic_debug=7 kcs_debug=7

[  867.851694] IPMI System Interface driver.
[  867.859771] ipmi_si: Trying SMBIOS-specified smic state machine at i/o address 0xecf4, slave address 0x20, irq 0
[  867.880250] start_smic_transaction - 18 01
[  867.880263] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.880271] smic_event - state = 1, flags = 0x4c, status = 0xc0
[  867.880278] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.884133] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.884142] smic_event - state = 2, flags = 0x4c, status = 0xc0
[  867.884150] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.888117] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.888125] smic_event - state = 3, flags = 0x4c, status = 0xc1
[  867.888133] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.892229] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.892245] smic_event - state = 5, flags = 0x0c, status = 0xc3
[  867.892256] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.892270] smic_event - state = 6, flags = 0x0c, status = 0xc3
[  867.896996] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.897008] smic_event - state = 6, flags = 0xcc, status = 0xc3
[  867.897020] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.904022] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.904031] smic_event - state = 7, flags = 0xcc, status = 0xc4
[  867.904038] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.908101] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.908109] smic_event - state = 8, flags = 0xcc, status = 0xc5
[  867.908117] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.912129] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.912137] smic_event - state = 8, flags = 0xcc, status = 0xc5
[  867.912145] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.916104] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.916112] smic_event - state = 8, flags = 0xcc, status = 0xc5
[  867.916120] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.920106] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.920114] smic_event - state = 8, flags = 0xcc, status = 0xc5
[  867.920121] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.924100] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.924108] smic_event - state = 8, flags = 0xcc, status = 0xc5
[  867.924115] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.928115] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.928123] smic_event - state = 8, flags = 0xcc, status = 0xc5
[  867.928130] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.932102] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.932110] smic_event - state = 8, flags = 0xcc, status = 0xc5
[  867.932118] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.936111] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.936119] smic_event - state = 8, flags = 0xcc, status = 0xc5
[  867.936127] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.940110] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.940118] smic_event - state = 8, flags = 0xcc, status = 0xc5
[  867.940127] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.944123] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.944131] smic_event - state = 8, flags = 0xcc, status = 0xc5
[  867.944139] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.948194] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.948205] smic_event - state = 8, flags = 0xcc, status = 0xc5
[  867.948215] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.952111] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.952119] smic_event - state = 8, flags = 0xcc, status = 0xc5
[  867.952127] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.956114] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.956121] smic_event - state = 8, flags = 0xcc, status = 0xc6
[  867.956129] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.960112] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.960120] smic_event - state = 9, flags = 0x4c, status = 0xc0
[  867.960126] smic_get result - 1c 01 00 00 00 03 38 01 3f a2 02 00 00 00
[  867.960155] start_smic_transaction - 18 2f
[  867.960164] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.960172] smic_event - state = 1, flags = 0x4c, status = 0xc0
[  867.960179] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.964196] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.964204] smic_event - state = 2, flags = 0x4c, status = 0xc0
[  867.964211] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.968106] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.968114] smic_event - state = 3, flags = 0x4c, status = 0xc1
[  867.968122] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.972110] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.972118] smic_event - state = 5, flags = 0xcc, status = 0xc3
[  867.972124] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.972130] smic_event - state = 6, flags = 0xcc, status = 0xc3
[  867.972137] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.976133] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.976144] smic_event - state = 7, flags = 0xcc, status = 0xc4
[  867.976155] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.981016] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.981024] smic_event - state = 8, flags = 0xcc, status = 0xc5
[  867.981032] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.985138] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.985145] smic_event - state = 8, flags = 0xcc, status = 0xc5
[  867.985153] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.989106] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.989114] smic_event - state = 8, flags = 0xcc, status = 0xc6
[  867.989121] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.993115] smic_event - smic->smic_timeout = 2000000, time = 100
[  867.993123] smic_event - state = 9, flags = 0x4c, status = 0xc0
[  867.993129] smic_get result - 1c 2f 00 2c
[  867.993141] start_smic_transaction - 18 30 08
[  867.993351] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.993360] smic_event - state = 1, flags = 0x4c, status = 0xc0
[  867.993367] smic_event - smic->smic_timeout = 2000000, time = 0
[...]
[  867.996183] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.996190] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.996197] smic_event - state = 9, flags = 0x4c, status = 0xc0
[  867.996203] smic_get result - 1c 30 00
[  867.996215] smic_event - state = 0, flags = 0x4c, status = 0xc0
[  867.996220] start_smic_transaction - 18 31
[  867.996229] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.996236] smic_event - state = 1, flags = 0x4c, status = 0xc0
[  867.996243] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.996250] smic_event - smic->smic_timeout = 2000000, time = 0
[  867.996256] smic_event - smic->smic_timeout = 2000000, time = 0
[...]


This goes on through megabytes.  The modprobe process didn't terminate
for 10 minutes, and there was some output like this (cleaned from
smic_events all around the place by hand):

INFO: task modprobe:6414 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
modprobe      D f6805780 0  6414   4077
 f48dfe68 00000082 00000000 f6805780
 f48dfe48 f90271cf c046acc0 f64f6a0c
 2002132c f6da1300 f6da14b4 c182acc0
 00000002 f64f6a0c 186f5ef2 000000ca
 f48dfe30 c0123c40 00000000 f64f69e0
 f48dfe30 00000282 00000001 c032456c
Call Trace:
 [<f90271cf>] ? i_ipmi_request+0x8f5/0x916 [ipmi_msghandler]
 [<c0123c40>] ? check_preempt_wakeup+0x146/0x180
 [<c01292c3>] ? try_to_wake_up+0x1f3/0x1fd
 [<c011c70a>] ? default_spin_lock_flags+0x8/0xe
 [<c031b81a>] schedule+0x8/0x17
 [<f9028745>] ipmi_register_smi+0x3ca/0xba1 [ipmi_msghandler]
 [<c028681c>] ? put_device+0xf/0x11
 [<c028782a>] ? device_add+0x497/0x516
 [<c013f2e7>] ? autoremove_wake_function+0x0/0x33
 [<fc2d939c>] try_smi_init+0x58f/0x726 [ipmi_si]
 [<fc2dc3e5>] init_ipmi_si+0x3e2/0x748 [ipmi_si]
 [<c010304f>] do_one_initcall+0x4a/0x115
 [<fc2dc003>] ? init_ipmi_si+0x0/0x748 [ipmi_si]
 [<c0142c0b>] ? __blocking_notifier_call_chain+0x40/0x4c
 [<c014ff97>] sys_init_module+0x87/0x18b
 [<c0107c94>] sysenter_do_call+0x12/0x28


lspci -x of Class ff00:

00:04.0 Class ff00: Dell Embedded Remote Access or ERA/O
00: 28 10 0c 00 17 01 90 02 00 00 00 ff 10 20 80 00
10: 08 00 b8 fe f9 ec 00 00 e9 ec 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 0c 00
30: 00 00 00 fe 48 00 00 00 00 00 00 00 0b 01 00 00

00:04.1 Class ff00: Dell Remote Access Card III
00: 28 10 08 00 03 01 90 02 00 00 00 ff 10 20 80 00
10: 00 20 10 fe 81 ec 00 00 08 00 b0 fe 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 08 00
30: 00 00 00 00 48 00 00 00 00 00 00 00 0a 02 00 00

00:04.2 Class ff00: Dell Embedded Remote Access: BMC/SMIC device
00: 28 10 0d 00 03 01 90 02 00 00 00 ff 10 20 80 00
10: f5 ec 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 0d 00
30: 00 00 00 00 48 00 00 00 00 00 00 00 07 03 00 00


lspci -nv of the same:

00:04.0 ff00: 1028:000c
	Subsystem: 1028:000c
	Flags: bus master, medium devsel, latency 32, IRQ 11
	Memory at feb80000 (32-bit, prefetchable) [size=4K]
	I/O ports at ecf8 [size=8]
	I/O ports at ece8 [size=8]
	Expansion ROM at fe000000 [disabled] [size=64K]
	Capabilities: [48] Power Management version 2

00:04.1 ff00: 1028:0008
	Subsystem: 1028:0008
	Flags: medium devsel, IRQ 23
	Memory at fe102000 (32-bit, non-prefetchable) [size=4K]
	I/O ports at ec80 [size=64]
	Memory at feb00000 (32-bit, prefetchable) [size=512K]
	Capabilities: [48] Power Management version 2
	Kernel driver in use: serial

00:04.2 ff00: 1028:000d
	Subsystem: 1028:000d
	Flags: medium devsel, IRQ 7
	I/O ports at ecf4 [size=4]
	Capabilities: [48] Power Management version 2
-- 
Regards,
Feri.
