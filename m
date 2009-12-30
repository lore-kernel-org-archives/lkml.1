Return-Path: <linux-kernel-owner+w=401wt.eu-S1752536AbZL3JJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbZL3JJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 04:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbZL3JJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 04:09:31 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:35223 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbZL3JJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 04:09:29 -0500
Message-ID: <4B3B1895.1070007@pardus.org.tr>
Date: Wed, 30 Dec 2009 11:08:37 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       avi@redhat.com
Subject: BUG at kvm_main.c: invalid opcode 0000 [#1] SMP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

kvm-kmod 2.6.32 compiled and loaded against 2.6.30.9 gives the following trace after modprobe:

[   36.116037] loaded kvm module (kvm-kmod-2.6.32)                                                                                                                                    
[   36.116053] ------------[ cut here ]------------                                                                                                                                   
[   36.116645] kernel BUG at /var/pisi/module-kvm-2.6.32-8/work/kvm-kmod-2.6.32/x86/kvm_main.c:2594!                                                                                  
[   36.117752] invalid opcode: 0000 [#1] SMP                                                                                                                                          
[   36.118304] last sysfs file: /sys/devices/virtual/misc/kvm/dev                                                                                                                     
[   36.119030] Modules linked in: kvm_intel(+) pcspkr r8169 iTCO_wdt iTCO_vendor_support mii kvm brd ohci1394 ieee1394 firewire_ohci firewire_core ahci libata                        
[   36.121088]                                                                                                                                                                        
[   36.121275] Pid: 337, comm: modprobe Not tainted (2.6.30.9-128 #1) System Product Name                                                                                             
[   36.122255] EIP: 0060:[<f88431da>] EFLAGS: 00010246 CPU: 1                                                                                                                         
[   36.122951] EIP is at kvm_handle_fault_on_reboot+0xe/0x12 [kvm]                                                                                                                    
[   36.123684] EAX: f6723f68 EBX: 00000000 ECX: 00000002 EDX: 00000000                                                                                                                
[   36.124459] ESI: 00000400 EDI: f5d4f000 EBP: f6723f60 ESP: f6723f60                                                                                                                
[   36.125236]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068                                                                                                                          
[   36.125905] Process modprobe (pid: 337, ti=f6722000 task=f6743e30 task.ti=f6722000)                                                                                                
[   36.126852] Stack:                                                                                                                                                                 
[   36.127100]  f6723f84 f88d339e 00000000 00000000 00000000 00000000 f88ce17c fffffffc                                                                                               
[   36.128215]  f88d31d9 f6723f9c c0101139 00000000 f88ce17c fffffffc 00000000 f6723fac                                                                                               
[   36.129373]  c01531f9 09a385a8 bfbb3354 f6722000 c01031d4 09a385a8 0000b761 09a2a2f0                                                                                               
[   36.130555] Call Trace:                                                                                                                                                            
[   36.130857]  [<f88d339e>] ? vmx_init+0x1c5/0x20a [kvm_intel]                                                                                                                       
[   36.131585]  [<f88d31d9>] ? vmx_init+0x0/0x20a [kvm_intel]                                                                                                                         
[   36.132290]  [<c0101139>] ? do_one_initcall+0x4c/0x13a                                                                                                                             
[   36.132951]  [<c01531f9>] ? sys_init_module+0x87/0x18b                                                                                                                             
[   36.133613]  [<c01031d4>] ? sysenter_do_call+0x12/0x28                                                                                                                             
[   36.134272] Code: c3 55 31 c0 89 e5 c7 42 40 f8 6c 86 f8 5d c3 55 31 c0 89 e5 c7 42 40 7c 6c 86 f8 5d c3 80 3d 1c 82 86 f8 00 55 89 e5 74 02 eb fe <0f> 0b eb fe 55 b9 07 00 00 00 89 e5 57 89 c7 31 c0 f3 ab 5f 5d                                                                                                                                                      
[   36.138053] EIP: [<f88431da>] kvm_handle_fault_on_reboot+0xe/0x12 [kvm] SS:ESP 0068:f6723f60                                                                                       
[   36.139168] ---[ end trace 6acc003c8ce73117 ]---


It seems that it doesn't affect the kvm performance/functioning. Here's the processor information:


processor       : 7
vendor_id       : GenuineIntel
cpu family      : 6
model           : 26
model name      : Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz
stepping        : 5
cpu MHz         : 2668.000
cache size      : 8192 KB
physical id     : 0
siblings        : 8
core id         : 3
cpu cores       : 4
apicid          : 7
initial apicid  : 7
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 11
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx rdtscp lm constant_tsc arch_perfmon pebs bts xtopology tsc_reliable nonstop_tsc pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
bogomips        : 5344.67
clflush size    : 64
power management:


--
Thanks,
