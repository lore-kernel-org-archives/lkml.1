Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbYHNGqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbYHNGqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 02:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbYHNGii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 02:38:38 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:38143 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbYHNGiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 02:38:04 -0400
Date: Thu, 14 Aug 2008 00:14:39 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808140614.m7E6Ed4Z006268@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] mdb: version 2.6.27-rc3 released
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ChangesLog:
2.6.27-rc3 1/29 mdb:  add machine restart/genapic export
 
 add machine restart and genapic exports for the module based 
 build of the debugger.  genapic is exported here rather than 
 arch/x86/mach-generic/probes.c because EXPORT_SYMBOL does not
 work correctly when used inside of files in this directory in
 the 2.6.27 tree.
 

2.6.27-rc3 2/29 mdb:  add debug directory Makefile
 
 add a debug directory makefile for loadable kernel debugger modules.

2.6.27-rc3 3/29 mdb:  add mdb kernel debugger Makefile
 
 add the makefile for the MDB kernel debugger 

2.6.27-rc3 4/29 mdb:  checkpatch.pl fixes/add SSB support
 
 correct checkpatch.pl global declarations, volatile declarations moved
 to the ia32 specific file.  add focus processor support for SSB.  add
 sld update functions for SSB.   
 

2.6.27-rc3 5/29 mdb:  add external defines for debugger base
 
 add architecture independent external defines.  

2.6.27-rc3 6/29 mdb:  add main include configuration file
 
 add top level mdb.h include file.  added focus processor internal tracing
 and debugging defines.

2.6.27-rc3 7/29 mdb:  fix APIC ICR directed NMI lockup on SMP systems
 
 
 fixed the APIC ICR directed NMI lockup problem seen on certain laptop systems
 when sending directed NMI exceptions over the APIC ICC bus.  
 
 added exception forking logic into debug_lock to handle nested exceptions 
 and concurrent int1 debugger exceptions.  instrumented better detection 
 and quiescence logic for NMI xcalls.
 
 fixed external defines.  fixed a large number of checkpatch.pl reports of
 global variables.  moved volatile and __asm__ __volatile__ references into
 mdb-ia32.c since this file is architecture specific to ia32 systems.
 
 added focus processor support for SSB, trace, and proceed processing to 
 maintain processor focus for global breakpoints.   added additional 
 processor hold states during acquisition of the debugger lock for 
 cases where multiple int1 exceptions.
 
 added SSB (step til branch) support.  added SSB focus support.  (NOTE:  
 SSB was previously defined but the code was not fully instrumented in
 Linux.
 
 TO-DO
 
 Need to add TSS gates to all exceptions in ia32 since current GDT only
 uses trap gates.  TSS gates allow the processor to switch to a known
 good stack rather than expect the double fault handler to do so.
 
 
 

2.6.27-rc3 8/29 mdb:  add includes and external defines for ia32 specific code
 
 added includes and external defines for ia32 specific code
 

2.6.27-rc3 9/29 mdb:  add includes and external function prototypes for ia32 specific code
 
 added includes and external function prototypes for ia32 specific code
 

2.6.27-rc3 10/29 mdb:  add SSB jump detection support 
 
 added JMP, CALL, RET, J%% detection into the ia32 disassembler for
 SSB support and branch detection.
 

2.6.27-rc3 11/29 mdb:  add includes and external defines for keyboard specific code
 
 added includes and external defines for keyboard specific code
 

2.6.27-rc3 12/29 mdb:  add alternate debugger, accelerator, and keystroke command registry
 
 added the command registry for registering debugger and accelerator 
 keystroke commands.  corrected a large number of checkpatch.pl 
 reported issues.
 

2.6.27-rc3 13/29 mdb:  add includes and external function prototypes debugger registry
 
 added includes and external function prototypes debugger registry
 

2.6.27-rc3 14/29 mdb:  add logic processing module for mdb/checkpath.pl fixes
 
 added mathematical logic parser and conditional breakpoint 
 support.  corrected large number of checkpatch.pl reported
 issues.
 

2.6.27-rc3 15/29 mdb:  notify_die fixes/add SSB support
 
 added complete notify_die states and state support for SSB command.
 

2.6.27-rc3 16/29 mdb:  add touch_nmi_watchdog calls to keyboard poll
 
 added clocksource nmi functions and nmi watchdog update
 logic to correct soft cpu errors due to nmi watchdog 
 timers.
 
 
 

2.6.27-rc3 17/29 mdb:  update operating system defines
 
 updated and included operating system dependent defines
 

2.6.27-rc3 18/29 mdb:  add global external procedure defines 
 
 added global external procedure defines.  added and updated volatile 
 declarations.  added and updated debug_lock synchronization and SSB
 command support.
 
 

2.6.27-rc3 19/29 mdb:  adding notify_die handler for keyboard debugger entry
 
 added module support for keyboard debugger entry point and
 notify_die entry point.
 
 

2.6.27-rc3 20/29 mdb:  export the console redirection handle
 
 export the console redirection handle to allow 
 the debugger screen to becoime visible again during exceptions.  Export
 of this variable allows the debugger to switch to the current screen 
 in order to enable the debugging console on systems with a redirected
 system console.
 

2.6.27-rc3 21/29 mdb:  disable console warnings if the debugger is present.
 
 disable the console warning checks if the debugger is active
 because the debugger is dependent in the console output
 functions in order to provide console display.   
 

2.6.27-rc3 22/29 mdb:  export kernel_text_address
 
 export the kernel_text_address() to allow symbol searching and 
 matches of symbolic names contained the the kernel symbol table.
 

2.6.27-rc3 23/29 mdb:  export kallsyms functions
 
 export the kallsyms lookup functions to the module based debugger.
 add debugger specific lookup to search for matching strstr text 
 fragments for entered search terms.
 
 

2.6.27-rc3 24/29 mdb:  add export function to module.c
 
 add the ability to scan and display the loaded module list 
 inside the debugger.
 

2.6.27-rc3 25/29 mdb:  add a notify_die handler to panic.c
 
 add a notify_die handler to hook the panic entry point prior to 
 Linux "execve"-ing another kernel for crash analysis.
 

2.6.27-rc3 26/29 mdb:  export task_curr
 
 export the task_curr function to the module based kernel debugger to enable
 process back tracing and state display.
 

2.6.27-rc3 27/29 mdb:  export the clocksource nmi watchdog 
 
 export the clocksource nmi watchdog for the module based kernel debugger.
 This function is called to prevent watchdog events while the debugger 
 has processors in suspended states during active debugging sessions.
 

2.6.27-rc3 28/29 mdb:  change mdb name to "Merkey's Linux Kernel Debugger"
 
 change mdb name to "Merkey's Linux Kernel Debugger".  update description
 to add very simple and minimal instructions on entering the debugger and
 access to the internal help panels.
 

2.6.27-rc3 29/29 mdb:  add /debug directory to main Makefile
 
 add the /debug directory to the main Makefile for module-based kernel
 debuggers.
 

Site : http://www.wolfmountaingroup.org
FTP  : ftp://www.wolfmountaingroup.org/pub/mdb/mdb-2.6.27-rc3-ia32-08-13-08.patch
