Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbYL3PiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbYL3PiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 10:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYL3Ph4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 10:37:56 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:59020 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbYL3Phz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 10:37:55 -0500
Date: Tue, 30 Dec 2008 21:00:12 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: kgdb-bugreport@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, mel@csn.ul.ie,
       jason.wessel@windriver.com
Subject: [BUG] 2.6.28-git2 - powerpc - kernel expection with KGDB -
	"kgdbts:RUN sw breakpoint test"
Message-ID: <20081230153012.GA18636@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

	2.6.28-git2 kernel panic's with "Recursive entry to debugger", while running 
"kgdbts:RUN sw breakpoint test" on bootup on a powerpc box. The kernel was compiled 
with following KGDB options

CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
CONFIG_KGDB_TESTS=y
CONFIG_KGDB_TESTS_ON_BOOT=y
CONFIG_KGDB_TESTS_BOOT_STRING="V1F100"

[    2.610592] kgdb: Registered I/O driver kgdbts.
[    2.610602] kgdbts:RUN plant and detach test
[    2.610675] kgdbts:RUN sw breakpoint test
[    2.610889] KGDB: re-enter exception: ALL breakpoints killed
[    2.610898] Call Trace:
[    2.610907] [c0000004fe05a840] [c0000000000185b0] .show_stack+0x190/0x2c0 (unreliable)
[    2.610924] [c0000004fe05a910] [c000000000018708] .dump_stack+0x28/0x40
[    2.610938] [c0000004fe05a990] [c00000000012e2a0] .kgdb_handle_exception+0x860/0x8b0
[    2.610953] [c0000004fe05aaa0] [c0000000000429e4] .kgdb_handle_breakpoint+0x74/0x120
[    2.610968] [c0000004fe05ab30] [c00000000003c3d0] .program_check_exception+0x370/0xb00
[    2.610982] [c0000004fe05abf0] [c000000000004b04] program_check_common+0x104/0x180
[    2.610998] --- Exception: 700 at .gdb_regs_to_pt_regs+0xf0/0x120
[    2.611001]     LR = .gdb_regs_to_pt_regs+0x30/0x120
[    2.611015] [c0000004fe05af70] [c00000000055f9d0] .check_and_rewind_pc+0x70/0x170
[    2.611029] [c0000004fe05b010] [c00000000055d168] .validate_simple_test+0x88/0x220
[    2.611044] [c0000004fe05b0a0] [c00000000055e080] .run_simple_test+0x3c0/0x490
[    2.611058] [c0000004fe05b140] [c00000000055d0b8] .kgdbts_put_char+0x88/0xb0
[    2.611071] [c0000004fe05b1d0] [c00000000012a314] .put_packet+0x164/0x340
[    2.611085] [c0000004fe05b2b0] [c00000000012cb6c] .gdb_serial_stub+0x6ec/0x1380
[    2.611100] [c0000004fe05b3e0] [c00000000012e0a4] .kgdb_handle_exception+0x664/0x8b0
[    2.611114] [c0000004fe05b4f0] [c0000000000429e4] .kgdb_handle_breakpoint+0x74/0x120
[    2.611129] [c0000004fe05b580] [c00000000003c3d0] .program_check_exception+0x370/0xb00
[    2.611143] [c0000004fe05b640] [c000000000004b04] program_check_common+0x104/0x180
[    2.611159] --- Exception: 700 at .kgdb_breakpoint+0x34/0x60
[    2.611162]     LR = .kgdb_breakpoint+0x20/0x60
[    2.611174] [c0000004fe05b9b0] [c00000000055e9d8] .run_breakpoint_test+0xe8/0x190
[    2.611189] [c0000004fe05ba50] [c00000000055eeec] .configure_kgdbts+0x2bc/0xb40
[    2.611204] [c0000004fe05bb40] [c000000000c35544] .init_kgdbts+0x64/0x80
[    2.611217] [c0000004fe05bbc0] [c0000000000090d0] .do_one_initcall+0xd0/0x320
[    2.611231] [c0000004fe05bec0] [c000000000bed32c] .kernel_init+0x2cc/0x480
[    2.611245] [c0000004fe05bf90] [c00000000003fd60] .kernel_thread+0x54/0x70
[    2.611257] Kernel panic - not syncing: Recursive entry to debugger
[    2.611282] Call Trace:
[    2.611290] [c0000004fe059f90] [c0000000000185b0] .show_stack+0x190/0x2c0 (unreliable)
[    2.611307] [c0000004fe05a060] [c000000000018708] .dump_stack+0x28/0x40
[    2.611320] [c0000004fe05a0e0] [c00000000012df14] .kgdb_handle_exception+0x4d4/0x8b0
[    2.611335] [c0000004fe05a1f0] [c0000000000429e4] .kgdb_handle_breakpoint+0x74/0x120
[    2.611350] [c0000004fe05a280] [c00000000003c3d0] .program_check_exception+0x370/0xb00
[    2.611364] [c0000004fe05a340] [c000000000004b04] program_check_common+0x104/0x180
[    2.611380] --- Exception: 700 at .smp_call_function_mask+0x78/0x3f0
[    2.611383]     LR = .smp_call_function_mask+0x58/0x3f0
[    2.611397] [c0000004fe05a7c0] [c000000000102f18] .smp_call_function+0x58/0x80
[    2.611411] [c0000004fe05a860] [c000000000044bf4] .smp_send_stop+0x34/0x50
[    2.611425] [c0000004fe05a8e0] [c0000000000a0b44] .panic+0xa4/0x210
[    2.611438] [c0000004fe05a990] [c00000000012e2ac] .kgdb_handle_exception+0x86c/0x8b0
[    2.611453] [c0000004fe05aaa0] [c0000000000429e4] .kgdb_handle_breakpoint+0x74/0x120
[    2.611467] [c0000004fe05ab30] [c00000000003c3d0] .program_check_exception+0x370/0xb00
[    2.611482] [c0000004fe05abf0] [c000000000004b04] program_check_common+0x104/0x180
[    2.611497] --- Exception: 700 at .gdb_regs_to_pt_regs+0xf0/0x120
[    2.611500]     LR = .gdb_regs_to_pt_regs+0x30/0x120
[    2.611513] [c0000004fe05af70] [c00000000055f9d0] .check_and_rewind_pc+0x70/0x170
[    2.611528] [c0000004fe05b010] [c00000000055d168] .validate_simple_test+0x88/0x220
[    2.611542] [c0000004fe05b0a0] [c00000000055e080] .run_simple_test+0x3c0/0x490
[    2.611556] [c0000004fe05b140] [c00000000055d0b8] .kgdbts_put_char+0x88/0xb0
[    2.611570] [c0000004fe05b1d0] [c00000000012a314] .put_packet+0x164/0x340
[    2.611583] [c0000004fe05b2b0] [c00000000012cb6c] .gdb_serial_stub+0x6ec/0x1380
[    2.611598] [c0000004fe05b3e0] [c00000000012e0a4] .kgdb_handle_exception+0x664/0x8b0
[    2.611612] [c0000004fe05b4f0] [c0000000000429e4] .kgdb_handle_breakpoint+0x74/0x120
[    2.611627] [c0000004fe05b580] [c00000000003c3d0] .program_check_exception+0x370/0xb00
[    2.611641] [c0000004fe05b640] [c000000000004b04] program_check_common+0x104/0x180
[    2.611657] --- Exception: 700 at .kgdb_breakpoint+0x34/0x60
[    2.611660]     LR = .kgdb_breakpoint+0x20/0x60
[    2.611672] [c0000004fe05b9b0] [c00000000055e9d8] .run_breakpoint_test+0xe8/0x190
[    2.611687] [c0000004fe05ba50] [c00000000055eeec] .configure_kgdbts+0x2bc/0xb40
[    2.611701] [c0000004fe05bb40] [c000000000c35544] .init_kgdbts+0x64/0x80
[    2.611714] [c0000004fe05bbc0] [c0000000000090d0] .do_one_initcall+0xd0/0x320
[    2.611728] [c0000004fe05bec0] [c000000000bed32c] .kernel_init+0x2cc/0x480
[    2.611742] [c0000004fe05bf90] [c00000000003fd60] .kernel_thread+0x54/0x70
[    2.611754] Kernel panic - not syncing: Recursive entry to debugger
[    2.611777] Call Trace:
[    2.611785] [c0000004fe0596e0] [c0000000000185b0] .show_stack+0x190/0x2c0 (unreliable)
[    2.611802] [c0000004fe0597b0] [c000000000018708] .dump_stack+0x28/0x40
[    2.611816] [c0000004fe059830] [c00000000012df14] .kgdb_handle_exception+0x4d4/0x8b0
[    2.611830] [c0000004fe059940] [c0000000000429e4] .kgdb_handle_breakpoint+0x74/0x120
[    2.611845] [c0000004fe0599d0] [c00000000003c3d0] .program_check_exception+0x370/0xb00
[    2.611859] [c0000004fe059a90] [c000000000004b04] program_check_common+0x104/0x180
[    2.611875] --- Exception: 700 at .smp_call_function_mask+0x78/0x3f0
[    2.611879]     LR = .smp_call_function_mask+0x58/0x3f0
[    2.611892] [c0000004fe059f10] [c000000000102f18] .smp_call_function+0x58/0x80
[    2.611906] [c0000004fe059fb0] [c000000000044bf4] .smp_send_stop+0x34/0x50
[    2.611919] [c0000004fe05a030] [c0000000000a0b44] .panic+0xa4/0x210
[    2.611933] [c0000004fe05a0e0] [c00000000012df20] .kgdb_handle_exception+0x4e0/0x8b0
[    2.611947] [c0000004fe05a1f0] [c0000000000429e4] .kgdb_handle_breakpoint+0x74/0x120
[    2.611962] [c0000004fe05a280] [c00000000003c3d0] .program_check_exception+0x370/0xb00
[    2.611976] [c0000004fe05a340] [c000000000004b04] program_check_common+0x104/0x180
[    2.611992] --- Exception: 700 at .smp_call_function_mask+0x78/0x3f0
[    2.611995]     LR = .smp_call_function_mask+0x58/0x3f0
[    2.612009] [c0000004fe05a7c0] [c000000000102f18] .smp_call_function+0x58/0x80
[    2.612022] [c0000004fe05a860] [c000000000044bf4] .smp_send_stop+0x34/0x50
[    2.612036] [c0000004fe05a8e0] [c0000000000a0b44] .panic+0xa4/0x210
[    2.612050] [c0000004fe05a990] [c00000000012e2ac] .kgdb_handle_exception+0x86c/0x8b0
[    2.612064] [c0000004fe05aaa0] [c0000000000429e4] .kgdb_handle_breakpoint+0x74/0x120
[    2.612079] [c0000004fe05ab30] [c00000000003c3d0] .program_check_exception+0x370/0xb00
[    2.612093] [c0000004fe05abf0] [c000000000004b04] program_check_common+0x104/0x180
[    2.612108] --- Exception: 700 at .gdb_regs_to_pt_regs+0xf0/0x120
[    2.612112]     LR = .gdb_regs_to_pt_regs+0x30/0x120
[    2.612125] [c0000004fe05af70] [c00000000055f9d0] .check_and_rewind_pc+0x70/0x170
[    2.612139] [c0000004fe05b010] [c00000000055d168] .validate_simple_test+0x88/0x220
[    2.612153] [c0000004fe05b0a0] [c00000000055e080] .run_simple_test+0x3c0/0x490
[    2.612168] [c0000004fe05b140] [c00000000055d0b8] .kgdbts_put_char+0x88/0xb0
[    2.612181] [c0000004fe05b1d0] [c00000000012a314] .put_packet+0x164/0x340
[    2.612195] [c0000004fe05b2b0] [c00000000012cb6c] .gdb_serial_stub+0x6ec/0x1380
[    2.612209] [c0000004fe05b3e0] [c00000000012e0a4] .kgdb_handle_exception+0x664/0x8b0
[    2.612224] [c0000004fe05b4f0] [c0000000000429e4] .kgdb_handle_breakpoint+0x74/0x120
[    2.612238] [c0000004fe05b580] [c00000000003c3d0] .program_check_exception+0x370/0xb00
[    2.612253] [c0000004fe05b640] [c000000000004b04] program_check_common+0x104/0x180
[    2.612268] --- Exception: 700 at .kgdb_breakpoint+0x34/0x60
[    2.612272]     LR = .kgdb_breakpoint+0x20/0x60
[    2.612284] [c0000004fe05b9b0] [c00000000055e9d8] .run_breakpoint_test+0xe8/0x190
[    2.612299] [c0000004fe05ba50] [c00000000055eeec] .configure_kgdbts+0x2bc/0xb40
[    2.612313] [c0000004fe05bb40] [c000000000c35544] .init_kgdbts+0x64/0x80
[    2.612326] [c0000004fe05bbc0] [c0000000000090d0] .do_one_initcall+0xd0/0x320
[    2.612340] [c0000004fe05bec0] [c000000000bed32c] .kernel_init+0x2cc/0x480
[    2.612353] [c0000004fe05bf90] [c00000000003fd60] .kernel_thread+0x54/0x70
[    2.612366] Kernel panic - not syncing: Recursive entry to debugger
[    2.612389] Call Trace:
[    2.612397] [c0000004fe058e30] [c0000000000185b0] .show_stack+0x190/0x2c0 (unreliable)
[    2.612414] [c0000004fe058f00] [c000000000018708] .dump_stack+0x28/0x40
[    2.612427] [c0000004fe058f80] [c00000000012df14] .kgdb_handle_exception+0x4d4/0x8b0
[    2.612442] [c0000004fe059090] [c0000000000429e4] .kgdb_handle_breakpoint+0x74/0x120
[    2.612456] [c0000004fe059120] [c00000000003c3d0] .program_check_exception+0x370/0xb00
[    2.612471] [c0000004fe0591e0] [c000000000004b04] program_check_common+0x104/0x180
[    2.612486] --- Exception: 700 at .smp_call_function_mask+0x78/0x3f0
[    2.612490]     LR = .smp_call_function_mask+0x58/0x3f0
[    2.612503] [c0000004fe059660] [c000000000102f18] .smp_call_function+0x58/0x80
[    2.612516] [c0000004fe059700] [c000000000044bf4] .smp_send_stop+0x34/0x50
[    2.612530] [c0000004fe059780] [c0000000000a0b44] .panic+0xa4/0x210
[    2.612543] [c0000004fe059830] [c00000000012df20] .kgdb_handle_exception+0x4e0/0x8b0
[    2.612558] [c0000004fe059940] [c0000000000429e4] .kgdb_handle_breakpoint+0x74/0x120
[    2.612572] [c0000004fe0599d0] [c00000000003c3d0] .program_check_exception+0x370/0xb00
[    2.612587] [c0000004fe059a90] [c000000000004b04] program_check_common+0x104/0x180
[    2.612602] --- Exception: 700 at .smp_call_function_mask+0x78/0x3f0
[    2.612606]     LR = .smp_call_function_mask+0x58/0x3f0
[    2.612619] [c0000004fe059f10] [c000000000102f18] .smp_call_function+0x58/0x80
[    2.612633] [c0000004fe059fb0] [c000000000044bf4] .smp_send_stop+0x34/0x50
[    2.612646] [c0000004fe05a030] [c0000000000a0b44] .panic+0xa4/0x210
[    2.612659] [c0000004fe05a0e0] [c00000000012df20] .kgdb_handle_exception+0x4e0/0x8b0
[    2.612674] [c0000004fe05a1f0] [c0000000000429e4] .kgdb_handle_breakpoint+0x74/0x120
[    2.612688] [c0000004fe05a280] [c00000000003c3d0] .program_check_exception+0x370/0xb00
[    2.612703] [c0000004fe05a340] [c000000000004b04] program_check_common+0x104/0x180
[    2.612718] --- Exception: 700 at .smp_call_function_mask+0x78/0x3f0
[    2.612722]     LR = .smp_call_function_mask+0x58/0x3f0
[    2.612735] [c0000004fe05a7c0] [c000000000102f18] .smp_call_function+0x58/0x80
[    2.612749] [c0000004fe05a860] [c000000000044bf4] .smp_send_stop+0x34/0x50
[    2.612762] [c0000004fe05a8e0] [c0000000000a0b44] .panic+0xa4/0x210
[    2.612775] [c0000004fe05a990] [c00000000012e2ac] .kgdb_handle_exception+0x86c/0x8b0
[    2.612790] [c0000004fe05aaa0] [c0000000000429e4] .kgdb_handle_breakpoint+0x74/0x120
[    2.612804] [c0000004fe05ab30] [c00000000003c3d0] .program_check_exception+0x370/0xb00
[    2.612819] [c0000004fe05abf0] [c000000000004b04] program_check_common+0x104/0x180
[    2.612834] --- Exception: 700 at .gdb_regs_to_pt_regs+0xf0/0x120
[    2.612837]     LR = .gdb_regs_to_pt_regs+0x30/0x120
[    2.612850] [c0000004fe05af70] [c00000000055f9d0] .check_and_rewind_pc+0x70/0x170
[    2.612864] [c0000004fe05b010] [c00000000055d168] .validate_simple_test+0x88/0x220
[    2.612879] [c0000004fe05b0a0] [c00000000055e080] .run_simple_test+0x3c0/0x490
[    2.612893] [c0000004fe05b140] [c00000000055d0b8] .kgdbts_put_char+0x88/0xb0
[    2.612906] [c0000004fe05b1d0] [c00000000012a314] .put_packet+0x164/0x340
[    2.612920] [c0000004fe05b2b0] [c00000000012cb6c] .gdb_serial_stub+0x6ec/0x1380
[    2.612934] [c0000004fe05b3e0] [c00000000012e0a4] .kgdb_handle_exception+0x664/0x8b0
[    2.612948] [c0000004fe05b4f0] [c0000000000429e4] .kgdb_handle_breakpoint+0x74/0x120
[    2.612963] [c0000004fe05b580] [c00000000003c3d0] .program_check_exception+0x370/0xb00
[    2.612977] [c0000004fe05b640] [c000000000004b04] program_check_common+0x104/0x180
[    2.612993] --- Exception: 700 at .kgdb_breakpoint+0x34/0x60
[    2.612996]     LR = .kgdb_breakpoint+0x20/0x60
[    2.613008] [c0000004fe05b9b0] [c00000000055e9d8] .run_breakpoint_test+0xe8/0x190
[    2.613023] [c0000004fe05ba50] [c00000000055eeec] .configure_kgdbts+0x2bc/0xb40
[    2.613037] [c0000004fe05bb40] [c000000000c35544] .init_kgdbts+0x64/0x80
[    2.613050] [c0000004fe05bbc0] [c0000000000090d0] .do_one_initcall+0xd0/0x320
[    2.613064] [c0000004fe05bec0] [c000000000bed32c] .kernel_init+0x2cc/0x480
[    2.613077] [c0000004fe05bf90] [c00000000003fd60] .kernel_thread+0x54/0x70
[    2.613089] Kernel panic - not syncing: Recursive entry to debugger
[    2.613113] Call Trace:
[    2.613121] [c0000004fe058580] [c0000000000185b0] .show_stack+0x190/0x2c0 (unreliable)
[    2.613137] [c0000004fe058650] [c000000000018708] .dump_stack+0x28/0x40
[    2.613151] [c0000004fe0586d0] [c00000000012df14] .kgdb_handle_exception+0x4d4/0x8b0
[    2.613165] [c0000004fe0587e0] [c0000000000429e4] .kgdb_handle_breakpoint+0x74/0x120
[    2.613180] [c0000004fe058870] [c00000000003c3d0] .program_check_exception+0x370/0xb00
[    2.613194] [c0000004fe058930] [c000000000004b04] program_check_common+0x104/0x180
[    2.613210] --- Exception: 700 at .smp_call_function_mask+0x78/0x3f0
[    2.613213]     LR = .smp_call_function_mask+0x58/0x3f0
[    2.613226] [c0000004fe058db0] [c000000000102f18] .smp_call_function+0x58/0x80
[    2.613240] [c0000004fe058e50] [c000000000044bf4] .smp_send_stop+0x34/0x50
[    2.613254] [c0000004fe058ed0] [c0000000000a0b44] .panic+0xa4/0x210
[    2.613267] [c0000004fe058f80] [c00000000012df20] .kgdb_handle_exception+0x4e0/0x8b0
[    2.613281] [c0000004fe059090] [c0000000000429e4] .kgdb_handle_breakpoint+0x74/0x120
[    2.613296] [c0000004fe059120] [c00000000003c3d0] .program_check_exception+0x370/0xb00
[    2.613311] [c0000004fe0591e0] [c000000000004b04] program_check_common+0x104/0x180
[    2.613326] --- Exception: 700 at .smp_call_function_mask+0x78/0x3f0
[    2.613330]     LR = .smp_call_function_mask+0x58/0x3f0
[    2.613342] [c0000004fe059660] [c000000000102f18] .smp_call_function+0x58/0x80
[    2.613356] [c0000004fe059700] [c000000000044bf4] .smp_send_stop+0x34/0x50
[    2.613370] [c0000004fe059780] [c0000000000a0b44] .panic+0xa4/0x210
[    2.613383] [c0000004fe059830] [c00000000012df20] .kgdb_handle_exception+0x4e0/0x8b0
[    2.613398] [c0000004fe059940] [c0000000000429e4] .kgdb_handle_breakpoint+0x74/0x120
[    2.613412] [c0000004fe0599d0] [c00000000003c3d0] .program_check_exception+0x370/0xb00
[    2.613427] [c0000004fe059a90] [c000000000004b04] program_check_common+0x104/0x180
[    2.613442] --- Exception: 700 at .smp_call_function_mask+0x78/0x3f0
[    2.613446]     LR = .smp_call_function_mask+0x58/0x3f0
[    2.613458] [c0000004fe059f10] [c000000000102f18] .smp_call_function+0x58/0x80
[    2.613472] [c0000004fe059fb0] [c000000000044bf4] .smp_send_stop+0x34/0x50
[    2.613486] [c0000004fe05a030] [c0000000000a0b44] .panic+0xa4/0x210
[    2.613499] [c0000004fe05a0e0] [c00000000012df20] .kgdb_handle_exception+0x4e0/0x8b0
[    2.613514] [c0000004fe05a1f0] [c0000000000429e4] .kgdb_handle_breakpoint+0x74/0x120
[    2.613528] [c0000004fe05a280] [c00000000003c3d0] .program_check_exception+0x370/0xb00
[    2.613543] [c0000004fe05a340] [c000000000004b04] program_check_common+0x104/0x180
[    2.613558] --- Exception: 700 at .smp_call_function_mask+0x78/0x3f0
[    2.613562]     LR = .smp_call_function_mask+0x58/0x3f0
[    2.613575] [c0000004fe05a7c0] [c0000000001020
[    2.628594] Call Trace:
[    2.628600] Kernel panic - not syncing: Recursive entry to debugger
[    2.628623] Call Trace:
[    2.628629] Kernel panic - not syncing: Recursive entry to debugger
[    2.628652] Call Trace:
(10000's of above 2 lines)
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
