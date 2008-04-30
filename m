Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbYD3JAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbYD3JAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 05:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbYD3JAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 05:00:00 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38835 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbYD3I74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 04:59:56 -0400
X-Greylist: delayed 2805 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Apr 2008 04:59:56 EDT
Subject: Soft Lock up report
From: "J.H." <warthog19@eaglescrag.net>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-eqA2E1k6OsHNY0SRqdEj"
Date: Wed, 30 Apr 2008 01:13:01 -0700
Message-Id: <1209543181.11526.68.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-2.1.12 (shards.monkeyblade.net [198.137.202.13]); Wed, 30 Apr 2008 01:13:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eqA2E1k6OsHNY0SRqdEj
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Just a quick one, since checking with HPA he seemed to indicate it was
worth reporting, I happened to notice a soft lockup on my system this
evening:

------------------------------------------------------
BUG: soft lockup - CPU#1 stuck for 11s! [imap:4394]

Pid: 4394, comm:                 imap
EIP: 0060:[<c04fabdb>] CPU: 1
EIP is at __copy_to_user_ll+0x2b/0xcf
 EFLAGS: 00000202    Not tainted  (2.6.23.15-137.fc8PAE #1)
EAX: 312d7475 EBX: 00000000 ECX: 0000063b EDX: 090a2c45
ESI: fff979c5 EDI: 09bf3938 EBP: e96f7eb4 DS: 007b ES: 007b FS: 00d8
CR0: 8005003b CR2: b9aa0eec CR3: 309cc000 CR4: 000006f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c04634a2>] file_read_actor+0x6a/0xe0
 [<c0463be8>] do_generic_mapping_read+0x1b8/0x42a
 [<c04453d6>] tick_program_event+0x33/0x52
 [<c04653d6>] generic_file_aio_read+0x149/0x175
 [<c0463438>] file_read_actor+0x0/0xe0
 [<c04849a6>] do_sync_read+0xc7/0x10a
 [<c0487523>] cp_new_stat64+0xfc/0x10e
 [<c043e3f1>] autoremove_wake_function+0x0/0x35
 [<c045a26e>] audit_syscall_exit+0x2aa/0x2c6
 [<c04848df>] do_sync_read+0x0/0x10a
 [<c0485262>] vfs_read+0xa6/0x158
 [<c0485795>] sys_pread64+0x48/0x5f
 [<c040518a>] syscall_call+0x7/0xb
 =======================

------------------------------------

The system in question is a Fedora 6 base system running the Fedora 8
i386 PAE kernel.  Version information included in version.log.

The underlying hardware is an old ProLiant DL380 G2, it has a pair of
1.2Ghz PIII cpu's, 6GB of PC133 single-bit ECC memory (including
dmidecode as an attachment).

The imap process in question is dovecot-1.0.2-5.fc6.  Dovecot is
continuing without further issue.  No other lock-up has been seen.

If there's anything else that would be useful please let me know.

- John 'Warthog9' Hawley

--=-eqA2E1k6OsHNY0SRqdEj
Content-Disposition: attachment; filename=s.mb.net-dmidecode.txt
Content-Type: text/plain; name=s.mb.net-dmidecode.txt; charset=UTF-8
Content-Transfer-Encoding: 7bit

# dmidecode 2.7
SMBIOS 2.3 present.
38 structures occupying 1108 bytes.
Table at 0x000EC000.

Handle 0x0000, DMI type 0, 20 bytes.
BIOS Information
        Vendor: Compaq
        Version: P24
        Release Date: 05/01/2004
        Address: 0xF0000
        Runtime Size: 64 kB
        ROM Size: 2048 kB
        Characteristics:
                PCI is supported
                PNP is supported
                BIOS is upgradeable
                BIOS shadowing is allowed
                ESCD support is available
                Boot from CD is supported
                Selectable boot is supported
                5.25"/360 KB floppy services are supported (int 13h)
                5.25"/1.2 MB floppy services are supported (int 13h)
                3.5"/720 KB floppy services are supported (int 13h)
                Print screen service is supported (int 5h)
                8042 keyboard services are supported (int 9h)
                Serial services are supported (int 14h)
                Printer services are supported (int 17h)
                CGA/mono video services are supported (int 10h)
                ACPI is supported
                USB legacy is supported
                BIOS boot specification is supported

Handle 0x0100, DMI type 1, 25 bytes.
System Information
        Manufacturer: Compaq
        Product Name: ProLiant DL380 G2
        Version: Not Specified
        Serial Number: <withheld>
        UUID: <withheld>
        Wake-up Type: Power Switch

Handle 0x0300, DMI type 3, 13 bytes.
Chassis Information
        Manufacturer: Compaq
        Type: Rack Mount Chassis
        Lock: Not Present
        Version: Not Specified
        Serial Number: <withheld>
        Asset Tag:                                 
        Boot-up State: Unknown
        Power Supply State: Unknown
        Thermal State: Unknown
        Security Status: Unknown

Handle 0x0403, DMI type 4, 32 bytes.
Processor Information
        Socket Designation: Proc 1
        Type: Central Processor
        Family: Pentium III
        Manufacturer: Intel
        ID: B4 06 00 00 FF FB 83 03
        Signature: Type 0, Family 6, Model 11, Stepping 4
        Flags:
                FPU (Floating-point unit on-chip)
                VME (Virtual mode extension)
                DE (Debugging extension)
                PSE (Page size extension)
                TSC (Time stamp counter)
                MSR (Model specific registers)
                PAE (Physical address extension)
                MCE (Machine check exception)
                CX8 (CMPXCHG8 instruction supported)
                APIC (On-chip APIC hardware supported)
                SEP (Fast system call)
                MTRR (Memory type range registers)
                PGE (Page global enable)
                MCA (Machine check architecture)
                CMOV (Conditional move instruction supported)
                PAT (Page attribute table)
                PSE-36 (36-bit page size extension)
                MMX (MMX technology supported)
                FXSR (Fast floating-point save and restore)
                SSE (Streaming SIMD extensions)
        Version: Not Specified
        Voltage: 2.8 V
        External Clock: 133 MHz
        Max Speed: 1660 MHz
        Current Speed: 1266 MHz
        Status: Populated, Idle
        Upgrade: ZIF Socket
        L1 Cache Handle: 0x0713
        L2 Cache Handle: 0x0723
        L3 Cache Handle: Not Provided

Handle 0x0400, DMI type 4, 32 bytes.
Processor Information
        Socket Designation: Proc 2
        Type: Central Processor
        Family: Pentium III
        Manufacturer: Intel
        ID: B1 06 00 00 FF FB 83 03
        Signature: Type 0, Family 6, Model 11, Stepping 1
        Flags:
                FPU (Floating-point unit on-chip)
                VME (Virtual mode extension)
                DE (Debugging extension)
                PSE (Page size extension)
                TSC (Time stamp counter)
                MSR (Model specific registers)
                PAE (Physical address extension)
                MCE (Machine check exception)
                CX8 (CMPXCHG8 instruction supported)
                APIC (On-chip APIC hardware supported)
                SEP (Fast system call)
                MTRR (Memory type range registers)
                PGE (Page global enable)
                MCA (Machine check architecture)
                CMOV (Conditional move instruction supported)
                PAT (Page attribute table)
                PSE-36 (36-bit page size extension)
                MMX (MMX technology supported)
                FXSR (Fast floating-point save and restore)
                SSE (Streaming SIMD extensions)
        Version: Not Specified
        Voltage: 2.8 V
        External Clock: 133 MHz
        Max Speed: 1660 MHz
        Current Speed: 1266 MHz
        Status: Populated, Enabled
        Upgrade: ZIF Socket
        L1 Cache Handle: 0x0710
        L2 Cache Handle: 0x0720
        L3 Cache Handle: Not Provided

Handle 0x0713, DMI type 7, 19 bytes.
Cache Information
        Socket Designation: Processor 1 Internal L1 Cache
        Configuration: Enabled, Not Socketed, Level 1
        Operational Mode: Write Back
        Location: Internal
        Installed Size: 32 KB
        Maximum Size: 32 KB
        Supported SRAM Types:
                Burst
        Installed SRAM Type: Burst
        Speed: Unknown
        Error Correction Type: Unknown
        System Type: Unknown
        Associativity: 4-way Set-associative

Handle 0x0710, DMI type 7, 19 bytes.
Cache Information
        Socket Designation: Processor 2 Internal L1 Cache
        Configuration: Enabled, Not Socketed, Level 1
        Operational Mode: Write Back
        Location: Internal
        Installed Size: 32 KB
        Maximum Size: 32 KB
        Supported SRAM Types:
                Burst
        Installed SRAM Type: Burst
        Speed: Unknown
        Error Correction Type: Unknown
        System Type: Unknown
        Associativity: 4-way Set-associative

Handle 0x0723, DMI type 7, 19 bytes.
Cache Information
        Socket Designation: Processor 1 Internal L2 Cache
        Configuration: Enabled, Not Socketed, Level 2
        Operational Mode: Varies With Memory Address
        Location: Internal
        Installed Size: 512 KB
        Maximum Size: 2048 KB
        Supported SRAM Types:
                Burst
        Installed SRAM Type: Burst
        Speed: Unknown
        Error Correction Type: Unknown
        System Type: Unknown
        Associativity: 4-way Set-associative

Handle 0x0720, DMI type 7, 19 bytes.
Cache Information
        Socket Designation: Processor 2 Internal L2 Cache
        Configuration: Enabled, Not Socketed, Level 2
        Operational Mode: Varies With Memory Address
        Location: Internal
        Installed Size: 512 KB
        Maximum Size: 2048 KB
        Supported SRAM Types:
                Burst
        Installed SRAM Type: Burst
        Speed: Unknown
        Error Correction Type: Unknown
        System Type: Unknown
        Associativity: 4-way Set-associative

Handle 0x0801, DMI type 8, 9 bytes.
Port Connector Information
        Internal Reference Designator: J58
        Internal Connector Type: Access Bus (USB)
        External Reference Designator: USB Port 1
        External Connector Type: Access Bus (USB)
        Port Type: USB

Handle 0x0802, DMI type 8, 9 bytes.
Port Connector Information
        Internal Reference Designator: J58
        Internal Connector Type: Access Bus (USB)
        External Reference Designator: USB Port 2
        External Connector Type: Access Bus (USB)
        Port Type: USB

Handle 0x0901, DMI type 9, 13 bytes.
System Slot Information
        Designation: PCI Slot 1
        Type: 64-bit PCI
        Current Usage: In Use
        Length: Long
        ID: 1
        Characteristics:
                5.0 V is provided
                PME signal is supported

Handle 0x0902, DMI type 9, 13 bytes.
System Slot Information
        Designation: PCI Slot 2
        Type: 64-bit PCI-66
        Current Usage: Available
        Length: Long
        ID: 2
        Characteristics:
                5.0 V is provided
                PME signal is supported
                Hot-plug devices are supported

Handle 0x0903, DMI type 9, 13 bytes.
System Slot Information
        Designation: PCI Slot 3
        Type: 64-bit PCI-66
        Current Usage: Available
        Length: Long
        ID: 3
        Characteristics:
                5.0 V is provided
                PME signal is supported
                Hot-plug devices are supported

Handle 0x1000, DMI type 16, 15 bytes.
Physical Memory Array
        Location: System Board Or Motherboard
        Use: System Memory
        Error Correction Type: Single-bit ECC
        Maximum Capacity: 6 GB
        Error Information Handle: Not Provided
        Number Of Devices: 6

Handle 0x1100, DMI type 17, 23 bytes.
Memory Device
        Array Handle: 0x1000
        Error Information Handle: Not Provided
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 1024 MB
        Form Factor: DIMM
        Set: 1
        Locator: DIMM 1A
        Bank Locator: Not Specified
        Type: SDRAM
        Type Detail: Synchronous
        Speed: 133 MHz (7.5 ns)

Handle 0x1101, DMI type 17, 23 bytes.
Memory Device
        Array Handle: 0x1000
        Error Information Handle: Not Provided
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 1024 MB
        Form Factor: DIMM
        Set: 1
        Locator: DIMM 4A
        Bank Locator: Not Specified
        Type: SDRAM
        Type Detail: Synchronous
        Speed: 133 MHz (7.5 ns)

Handle 0x1102, DMI type 17, 23 bytes.
Memory Device
        Array Handle: 0x1000
        Error Information Handle: Not Provided
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 1024 MB
        Form Factor: DIMM
        Set: 2
        Locator: DIMM 2B
        Bank Locator: Not Specified
        Type: SDRAM
        Type Detail: Synchronous
        Speed: 133 MHz (7.5 ns)

Handle 0x1103, DMI type 17, 23 bytes.
Memory Device
        Array Handle: 0x1000
        Error Information Handle: Not Provided
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 1024 MB
        Form Factor: DIMM
        Set: 2
        Locator: DIMM 5B
        Bank Locator: Not Specified
        Type: SDRAM
        Type Detail: Synchronous
        Speed: 133 MHz (7.5 ns)

Handle 0x1104, DMI type 17, 23 bytes.
Memory Device
        Array Handle: 0x1000
        Error Information Handle: Not Provided
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 1024 MB
        Form Factor: DIMM
        Set: 3
        Locator: DIMM 3C
        Bank Locator: Not Specified
        Type: SDRAM
        Type Detail: Synchronous
        Speed: 133 MHz (7.5 ns)

Handle 0x1105, DMI type 17, 23 bytes.
Memory Device
        Array Handle: 0x1000
        Error Information Handle: Not Provided
        Total Width: 72 bits
        Data Width: 64 bits
        Size: 1024 MB
        Form Factor: DIMM
        Set: 3
        Locator: DIMM 6C
        Bank Locator: Not Specified
        Type: SDRAM
        Type Detail: Synchronous
        Speed: 133 MHz (7.5 ns)

Handle 0x1300, DMI type 19, 15 bytes.
Memory Array Mapped Address
        Starting Address: 0x00000000000
        Ending Address: 0x0017FFFFFFF
        Range Size: 6 GB
        Physical Array Handle: 0x1000
        Partition Width: 0

Handle 0x1400, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00000000000
        Ending Address: 0x0003FFFFFFF
        Range Size: 1 GB
        Physical Device Handle: 0x1100
        Memory Array Mapped Address Handle: 0x1300
        Partition Row Position: 1

Handle 0x1401, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00040000000
        Ending Address: 0x0007FFFFFFF
        Range Size: 1 GB
        Physical Device Handle: 0x1101
        Memory Array Mapped Address Handle: 0x1300
        Partition Row Position: 1

Handle 0x1402, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00080000000
        Ending Address: 0x000BFFFFFFF
        Range Size: 1 GB
        Physical Device Handle: 0x1102
        Memory Array Mapped Address Handle: 0x1300
        Partition Row Position: 1

Handle 0x1403, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x000C0000000
        Ending Address: 0x000FFFFFFFF
        Range Size: 1 GB
        Physical Device Handle: 0x1103
        Memory Array Mapped Address Handle: 0x1300
        Partition Row Position: 1

Handle 0x1404, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00100000000
        Ending Address: 0x0013FFFFFFF
        Range Size: 1 GB
        Physical Device Handle: 0x1104
        Memory Array Mapped Address Handle: 0x1300
        Partition Row Position: 1

Handle 0x1405, DMI type 20, 19 bytes.
Memory Device Mapped Address
        Starting Address: 0x00140000000
        Ending Address: 0x0017FFFFFFF
        Range Size: 1 GB
        Physical Device Handle: 0x1105
        Memory Array Mapped Address Handle: 0x1300
        Partition Row Position: 1

Handle 0x2000, DMI type 32, 11 bytes.
System Boot Information
        Status: No errors detected

Handle 0xC100, DMI type 193, 7 bytes.
OEM-specific Type
        Header and Data:
                C1 07 00 C1 01 01 02
        Strings:
                11/15/2002
                06/07/2001

Handle 0xC200, DMI type 194, 5 bytes.
OEM-specific Type
        Header and Data:
                C2 05 00 C2 09

Handle 0xC300, DMI type 195, 5 bytes.
OEM-specific Type
        Header and Data:
                C3 05 00 C3 01
        Strings:
                $0E11071A

Handle 0xC400, DMI type 196, 5 bytes.
OEM-specific Type
        Header and Data:
                C4 05 00 C4 00

Handle 0xC503, DMI type 197, 10 bytes.
OEM-specific Type
        Header and Data:
                C5 0A 03 C5 03 04 03 00 01 01

Handle 0xC500, DMI type 197, 10 bytes.
OEM-specific Type
        Header and Data:
                C5 0A 00 C5 00 04 00 01 02 02

Handle 0xC600, DMI type 198, 10 bytes.
OEM-specific Type
        Header and Data:
                C6 0A 00 C6 17 00 00 01 3C 00

Handle 0xC700, DMI type 199, 40 bytes.
OEM-specific Type
        Header and Data:
                C7 28 00 C7 04 00 00 00 00 20 15 11 B0 06 00 00
                1C 00 00 00 01 20 15 02 B1 06 00 00 01 00 00 00
                02 20 10 01 B4 06 00 00

Handle 0x7F00, DMI type 127, 4 bytes.
End Of Table

--=-eqA2E1k6OsHNY0SRqdEj
Content-Disposition: attachment; filename=s.mb.net-version.log
Content-Type: text/x-log; name=s.mb.net-version.log; charset=UTF-8
Content-Transfer-Encoding: 7bit

[ ~]# cat /proc/cpuinfo /proc/modules /proc/ioports /proc/iomem /proc/scsi/scsi
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 11
model name      : Intel(R) Pentium(R) III CPU family      1266MHz
stepping        : 1
cpu MHz         : 1263.633
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 mmx fxsr sse
bogomips        : 2527.69
clflush size    : 32

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 11
model name      : Intel(R) Pentium(R) III CPU - S         1266MHz
stepping        : 4
cpu MHz         : 1263.633
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 mmx fxsr sse
bogomips        : 2526.55
clflush size    : 32

mptctl 28485 0 - Live 0xf90d4000
mptbase 68641 1 mptctl, Live 0xf90f7000
ip6table_filter 6337 1 - Live 0xf90af000
iptable_raw 5953 0 - Live 0xf90ac000
xt_comment 5697 0 - Live 0xf90b8000
xt_policy 7361 0 - Live 0xf90a9000
xt_multiport 6849 10 - Live 0xf90a6000
ipt_ULOG 11077 13 - Live 0xf90a2000
ipt_TTL 5953 0 - Live 0xf909f000
ipt_ttl 5697 0 - Live 0xf909c000
ipt_TOS 5953 0 - Live 0xf9099000
ipt_tos 5569 0 - Live 0xf9096000
ipt_SAME 6081 0 - Live 0xf9093000
ipt_REJECT 7617 4 - Live 0xf9090000
ipt_REDIRECT 5825 0 - Live 0xf908d000
ipt_recent 11097 0 - Live 0xf9089000
ipt_owner 5825 0 - Live 0xf9086000
ipt_NETMAP 5825 0 - Live 0xf9083000
ipt_MASQUERADE 6721 2 - Live 0xf9080000
ipt_LOG 9281 2 - Live 0xf907c000
ipt_iprange 5697 0 - Live 0xf9079000
ipt_ECN 6465 0 - Live 0xf9076000
ipt_ecn 5953 0 - Live 0xf9073000
ipt_CLUSTERIP 10181 0 - Live 0xf906f000
ipt_ah 5697 0 - Live 0xf906c000
ipt_addrtype 5697 0 - Live 0xf9069000
nf_nat_tftp 5697 0 - Live 0xf9066000
nf_nat_snmp_basic 12869 0 - Live 0xf9061000
nf_nat_sip 8001 0 - Live 0xf905e000
nf_nat_pptp 6976 0 - Live 0xf905b000
nf_nat_proto_gre 6341 1 nf_nat_pptp, Live 0xf9058000
nf_nat_irc 6209 0 - Live 0xf9055000
nf_nat_h323 9921 0 - Live 0xf9051000
nf_nat_ftp 6721 0 - Live 0xf904e000
nf_nat_amanda 5953 0 - Live 0xf904b000
ts_kmp 5953 5 - Live 0xf9048000
nf_conntrack_amanda 7745 1 nf_nat_amanda, Live 0xf9045000
nf_conntrack_tftp 8149 1 nf_nat_tftp, Live 0xf9042000
nf_conntrack_sip 11093 1 nf_nat_sip, Live 0xf903e000
nf_conntrack_proto_sctp 10825 0 - Live 0xf903a000
nf_conntrack_pptp 9153 1 nf_nat_pptp, Live 0xf901e000
nf_conntrack_proto_gre 8257 1 nf_conntrack_pptp, Live 0xf901a000
nf_conntrack_netlink 25793 0 - Live 0xf9032000
nf_conntrack_netbios_ns 6465 0 - Live 0xf8fa1000
nf_conntrack_irc 9177 1 nf_nat_irc, Live 0xf9016000
nf_conntrack_h323 49309 1 nf_nat_h323, Live 0xf9024000
nf_conntrack_ftp 10977 1 nf_nat_ftp, Live 0xf9012000
xt_tcpmss 6081 0 - Live 0xf900a000
xt_pkttype 5825 4 - Live 0xf9007000
xt_physdev 6481 0 - Live 0xf9004000
xt_NFQUEUE 5825 0 - Live 0xf9001000
xt_NFLOG 5953 0 - Live 0xf8ffe000
xt_MARK 6081 0 - Live 0xf8ffb000
xt_mark 5825 0 - Live 0xf8ff8000
xt_mac 5825 0 - Live 0xf8ff5000
xt_limit 6337 0 - Live 0xf8ff2000
xt_length 5825 0 - Live 0xf8fef000
xt_helper 6209 0 - Live 0xf8fa4000
xt_hashlimit 11725 0 - Live 0xf8feb000
ip6_tables 15109 2 ip6table_filter,xt_hashlimit, Live 0xf8fa7000
xt_dccp 6725 0 - Live 0xf8f92000
xt_conntrack 6337 3 - Live 0xf8f9e000
xt_CONNMARK 6465 0 - Live 0xf8f9b000
xt_connmark 6081 0 - Live 0xf8f98000
xt_CLASSIFY 5697 0 - Live 0xf8f95000
xt_tcpudp 6977 118 - Live 0xf8f73000
xt_state 6081 22 - Live 0xf8f76000
iptable_nat 9669 1 - Live 0xf8f80000
nf_nat 18669 14 ipt_SAME,ipt_REDIRECT,ipt_NETMAP,ipt_MASQUERADE,nf_nat_tftp,nf_nat_sip,nf_nat_pptp,nf_nat_proto_gre,nf_nat_irc,nf_nat_h323,nf_nat_ftp,nf_nat_amanda,nf_conntrack_netlink,iptable_nat, Live 0xf8f7a000
nf_conntrack_ipv4 11717 27 iptable_nat, Live 0xf8975000
nf_conntrack 51977 29 ipt_MASQUERADE,ipt_CLUSTERIP,nf_nat_tftp,nf_nat_snmp_basic,nf_nat_sip,nf_nat_pptp,nf_nat_irc,nf_nat_h323,nf_nat_ftp,nf_nat_amanda,nf_conntrack_amanda,nf_conntrack_tftp,nf_conntrack_sip,nf_conntrack_proto_sctp,nf_conntrack_pptp,nf_conntrack_proto_gre,nf_conntrack_netlink,nf_conntrack_netbios_ns,nf_conntrack_irc,nf_conntrack_h323,nf_conntrack_ftp,xt_helper,xt_conntrack,xt_CONNMARK,xt_connmark,xt_state,iptable_nat,nf_nat,nf_conntrack_ipv4, Live 0xf8f84000
iptable_mangle 6337 1 - Live 0xf8f67000
nfnetlink 8281 4 nf_conntrack_netlink,nf_nat,nf_conntrack_ipv4,nf_conntrack, Live 0xf8f6f000
iptable_filter 6465 1 - Live 0xf8f64000
ip_tables 14213 4 iptable_raw,iptable_nat,iptable_mangle,iptable_filter, Live 0xf8f6a000
x_tables 14277 44 xt_comment,xt_policy,xt_multiport,ipt_ULOG,ipt_TTL,ipt_ttl,ipt_TOS,ipt_tos,ipt_SAME,ipt_REJECT,ipt_REDIRECT,ipt_recent,ipt_owner,ipt_NETMAP,ipt_MASQUERADE,ipt_LOG,ipt_iprange,ipt_ECN,ipt_ecn,ipt_CLUSTERIP,ipt_ah,ipt_addrtype,xt_tcpmss,xt_pkttype,xt_physdev,xt_NFQUEUE,xt_NFLOG,xt_MARK,xt_mark,xt_mac,xt_limit,xt_length,xt_helper,xt_hashlimit,ip6_tables,xt_dccp,xt_conntrack,xt_CONNMARK,xt_connmark,xt_CLASSIFY,xt_tcpudp,xt_state,iptable_nat,ip_tables, Live 0xf895f000
tun 11713 1 - Live 0xf8971000
ipv6 245989 120 nf_conntrack_h323, Live 0xf8fad000
dm_mirror 21697 0 - Live 0xf896a000
dm_mod 46465 1 dm_mirror, Live 0xf8979000
video 20177 0 - Live 0xf8964000
output 6977 1 video, Live 0xf8924000
sbs 20169 0 - Live 0xf893f000
battery 14025 0 - Live 0xf8945000
ac 8133 0 - Live 0xf8882000
parport_pc 26981 0 - Live 0xf88f3000
lp 13161 0 - Live 0xf891f000
parport 32393 2 parport_pc,lp, Live 0xf8953000
sg 31965 0 - Live 0xf894a000
sr_mod 17509 0 - Live 0xf8919000
cdrom 33889 1 sr_mod, Live 0xf8935000
pata_serverworks 10945 0 - Live 0xf8915000
floppy 53125 0 - Live 0xf8927000
pcspkr 6593 0 - Live 0xf88e4000
e100 34125 0 - Live 0xf88e9000
i2c_piix4 11341 0 - Live 0xf8836000
ata_generic 8901 0 - Live 0xf88ce000
mii 8385 1 e100, Live 0xf88d2000
libata 100657 2 pata_serverworks,ata_generic, Live 0xf88fb000
i2c_core 21825 1 i2c_piix4, Live 0xf88d6000
cpqphp 58833 0 - Live 0xf88a2000
megaraid 36873 0 - Live 0xf88c3000
button 10449 0 - Live 0xf8847000
serio_raw 9029 0 - Live 0xf8843000
cciss 55621 5 - Live 0xf88b4000
sd_mod 27329 0 - Live 0xf884d000
scsi_mod 120013 7 mptctl,sg,sr_mod,libata,megaraid,cciss,sd_mod, Live 0xf8863000
ext3 110665 3 - Live 0xf8885000
jbd 52457 1 ext3, Live 0xf8855000
mbcache 10177 1 ext3, Live 0xf882f000
ehci_hcd 32205 0 - Live 0xf883a000
ohci_hcd 21829 0 - Live 0xf8828000
uhci_hcd 23761 0 - Live 0xf8821000
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:0f.1
  0170-0177 : libata
01f0-01f7 : 0000:00:0f.1
  01f0-01f7 : libata
0220-0223 : ACPI PM1a_EVT_BLK
0230-0231 : ACPI PM1a_CNT_BLK
0240-0243 : ACPI PM_TMR
0376-0376 : 0000:00:0f.1
  0376-0376 : libata
03c0-03df : vga+
03f2-03f5 : floppy
03f6-03f6 : 0000:00:0f.1
  03f6-03f6 : libata
03f7-03f7 : floppy DIR
03f8-03ff : serial
0408-040f : pnp 00:01
04d0-04d1 : pnp 00:01
0c06-0c08 : pnp 00:01
0c14-0c14 : pnp 00:01
0c49-0c4a : pnp 00:01
0cf8-0cff : PCI conf1
0f50-0f58 : pnp 00:01
1800-18ff : 0000:00:06.0
2000-20ff : 0000:00:01.0
  2000-20ff : cciss
2400-243f : 0000:00:02.0
  2400-243f : e100
2440-247f : 0000:00:04.0
  2440-247f : e100
2c00-2c0f : 0000:00:0f.1
  2c00-2c0f : libata
3000-3fff : PCI Bus #02
  3000-30ff : 0000:02:00.0
00000000-0009f3ff : System RAM
  00000000-00000000 : Crash kernel
0009f400-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000c8000-000cbfff : Adapter ROM
000f0000-000fffff : System ROM
00100000-efffbfff : System RAM
  00400000-00625aff : Kernel code
  00625b00-0073b563 : Kernel data
efffc000-efffffff : ACPI Tables
f1000000-f10fffff : 0000:00:02.0
f1100000-f11fffff : 0000:00:04.0
f1200000-f1203fff : 0000:00:01.0
f1210000-f121ffff : 0000:01:03.1
f3ef0000-f3ef3fff : 0000:00:01.0
  f3ef0000-f3ef3fff : cciss
f3fd0000-f3fd0fff : 0000:00:0f.2
  f3fd0000-f3fd0fff : ohci_hcd
f3fe0000-f3fe00ff : 0000:00:06.0
f5b00000-f5bfffff : 0000:00:04.0
  f5b00000-f5bfffff : e100
f5cf0000-f5cf0fff : 0000:00:04.0
  f5cf0000-f5cf0fff : e100
f5d00000-f5dfffff : 0000:00:02.0
  f5d00000-f5dfffff : e100
f5eb0000-f5eb0fff : 0000:00:02.0
  f5eb0000-f5eb0fff : e100
f5ec0000-f5efffff : 0000:00:01.0
  f5ec0000-f5efffff : cciss
f5fc0000-f5ffffff : 0000:01:03.1
f6000000-f6ffffff : PCI Bus #02
  f6000000-f6ffffff : 0000:02:00.0
f7e00000-f7efffff : PCI Bus #02
  f7e00000-f7e1ffff : 0000:02:00.0
  f7ef0000-f7ef0fff : 0000:02:00.0
f7ff0000-f7ff00ff : 0000:07:07.0
  f7ff0000-f7ff00ff : cpqphp
fec00000-fec0ffff : reserved
fee00000-fee0ffff : reserved
ffc00000-ffffffff : reserved
100000000-17fffffff : System RAM
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: COMPAQ   Model: CD-ROM SN-124    Rev: N102
  Type:   CD-ROM                           ANSI  SCSI revision: 05
[ ~]#

--=-eqA2E1k6OsHNY0SRqdEj
Content-Disposition: attachment; filename=s.mb.net-lspci.log
Content-Type: text/x-log; name=s.mb.net-lspci.log; charset=UTF-8
Content-Transfer-Encoding: 7bit

[ ~]# lspci -vvv
00:00.0 Host bridge: Broadcom CNB20HE Host Bridge (rev 23)
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-

00:00.1 Host bridge: Broadcom CNB20HE Host Bridge (rev 01)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
        Latency: 64, Cache Line Size: 32 bytes

00:00.2 Host bridge: Broadcom CNB20HE Host Bridge (rev 01)
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-

00:00.3 Host bridge: Broadcom CNB20HE Host Bridge (rev 01)
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-

00:01.0 RAID bus controller: Compaq Computer Corporation Smart Array 5i/532 (rev 01)
        Subsystem: Compaq Computer Corporation Smart Array 5i
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 71, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at f5ec0000 (64-bit, non-prefetchable) [size=256K]
        Region 2: I/O ports at 2000 [size=256]
        Region 3: Memory at f3ef0000 (64-bit, prefetchable) [size=16K]
        [virtual] Expansion ROM at f1200000 [disabled] [size=16K]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [cc] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [dc] PCI-X non-bridge device
                Command: DPERE- ERO- RBC=512 OST=4
                Status: Dev=de:00.0 64bit+ 133MHz- SCD- USC- DC=simple DMMRBC=512 DMOST=4 DMCRS=16 RSCEM- 266MHz- 533MHz-

00:02.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 100] (rev 08)
        Subsystem: Compaq Computer Corporation NC3163 Fast Ethernet NIC (embedded, WOL)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at f5eb0000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at 2400 [size=64]
        Region 2: Memory at f5d00000 (32-bit, non-prefetchable) [size=1M]
        [virtual] Expansion ROM at f1000000 [disabled] [size=1M]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

00:04.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 100] (rev 08)
        Subsystem: Compaq Computer Corporation NC3163 Fast Ethernet NIC (embedded, WOL)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at f5cf0000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at 2440 [size=64]
        Region 2: Memory at f5b00000 (32-bit, non-prefetchable) [size=1M]
        [virtual] Expansion ROM at f1100000 [disabled] [size=1M]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

00:06.0 System peripheral: Compaq Computer Corporation Advanced System Management Controller
        Subsystem: Compaq Computer Corporation Unknown device b0f3
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 10
        Region 0: I/O ports at 1800 [size=256]
        Region 1: Memory at f3fe0000 (32-bit, non-prefetchable) [size=256]

00:0f.0 ISA bridge: Broadcom OSB4 South Bridge (rev 51)
        Subsystem: Broadcom OSB4 South Bridge
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:0f.1 IDE interface: Broadcom OSB4 IDE Controller (prog-if 8a [Master SecP PriP])
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64
        Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
        Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
        Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
        Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
        Region 4: I/O ports at 2c00 [size=16]

00:0f.2 USB Controller: Broadcom OSB4/CSB5 OHCI USB Controller (rev 04) (prog-if 10 [OHCI])
        Subsystem: Broadcom OSB4/CSB5 OHCI USB Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (20000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f3fd0000 (32-bit, non-prefetchable) [size=4K]

01:03.0 PCI bridge: Intel Corporation 80960RP [i960 RP Microprocessor/Bridge] (rev 05) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64, Cache Line Size: 32 bytes
        Bus: primary=01, secondary=02, subordinate=02, sec-latency=64
        I/O behind bridge: 00003000-00003fff
        Memory behind bridge: f7e00000-f7efffff
        Prefetchable memory behind bridge: f6000000-f6ffffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-

01:03.1 Memory controller: Intel Corporation 80960RP [i960RP Microprocessor] (rev 05)
        Subsystem: Compaq Computer Corporation Unknown device c000
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at f5fc0000 (32-bit, prefetchable) [size=256K]
        [virtual] Expansion ROM at f1210000 [disabled] [size=64K]

02:00.0 VGA compatible controller: ATI Technologies Inc 3D Rage IIC 215IIC [Mach64 GT IIC] (rev 7a) (prog-if 00 [VGA])
        Subsystem: ATI Technologies Inc Rage IIC
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (2000ns min), Cache Line Size: 32 bytes
        Region 0: Memory at f6000000 (32-bit, prefetchable) [size=16M]
        Region 1: I/O ports at 3000 [size=256]
        Region 2: Memory at f7ef0000 (32-bit, non-prefetchable) [size=4K]
        [virtual] Expansion ROM at f7e00000 [disabled] [size=128K]
        Capabilities: [5c] Power Management version 1
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

07:07.0 PCI Hot-plug controller: Compaq Computer Corporation PCI Hotplug Controller (rev 12)
        Subsystem: Compaq Computer Corporation Unknown device a2f9
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at f7ff0000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000

[ ~]#

--=-eqA2E1k6OsHNY0SRqdEj--

