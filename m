Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbYCCWV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbYCCWV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760505AbYCCWVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:21:42 -0500
Received: from neuf-infra-smtp-out-sp604007av.neufgp.fr ([84.96.92.120]:46847
	"EHLO neuf-infra-smtp-out-sp604007av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760278AbYCCWVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:21:41 -0500
Message-ID: <47CC79EC.1010601@cosmosbay.com>
Date: Mon, 03 Mar 2008 23:21:32 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: Oleksandr Samoylyk <oleksandr@samoylyk.sumy.ua>,
       linux-kernel@vger.kernel.org
Subject: Re: e1000 latency problem or what ?
References: <47CC45E5.9080600@samoylyk.sumy.ua> <47CC7210.5050806@intel.com>
In-Reply-To: <47CC7210.5050806@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kok, Auke a écrit :
> Oleksandr Samoylyk wrote:
>> Dear community,
>>
>> I'm running a busy pptp-server which serves about 1500 users on about 80
>> Mbit/s (> 15000 packets/sec) through it. I use poptop, traffic shaper
>> and basic firewall rules.
>>
>> As for hardware it's a server on SuperMicro Server on X7DB8+ serverboard
>> server with 8 GB RAM on it running Ubuntu Server Edition.
>>
>> As for problem, sometimes I get the following erors in logs:
>> Mar  3 15:21:14 vpn kernel: [    0.000000] BUG: soft lockup - CPU#7
>> stuck for 11s! [events/7:34]
>> Mar  3 15:21:14 vpn kernel: [    0.000000] CPU 7:
>> Mar  3 15:21:14 vpn kernel: [    0.000000] Modules linked in: af_packet
>> xt_tcpmss iptable_mangle act_police sch_ingress cls_u32 sch_sfq sch_htb
>> e1000 xt_multiport xt_TCPMSS xt_state xt_limit xt_tcpudp
>> nf_conntrack_pptp nf_conntrack_proto_gre nf_nat_irc nf_conntrack_irc
>> nf_nat_ftp nf_conntrack_ftp iptable_nat nf_nat nf_conntrack_ipv4
>> nf_conntrack e1000e iptable_filter ip_tables x_tables tcp_cubic pptp
>> pppox ppp_generic slhc parport_pc lp parport loop iTCO_wdt
>> iTCO_vendor_support pcspkr shpchp i5000_edac pci_hotplug evdev edac_core
>> ext3 jbd mbcache sg sr_mod cdrom sd_mod ata_piix pata_acpi aic94xx
>> libsas ata_generic libata scsi_transport_sas scsi_mod fuse
>> Mar  3 15:21:14 vpn kernel: [    0.000000] Pid: 34, comm: events/7 Not
>> tainted 2.6.24-11-server #1
>> Mar  3 15:21:14 vpn kernel: [    0.000000] RIP:
>> 0010:[libata:_spin_unlock_irqrestore+0x8/0x26222]
>> [libata:_spin_unlock_irqrestore+0x8/0x26222]
>> _spin_unlock_irqrestore+0x8/0x10
>> Mar  3 15:21:14 vpn kernel: [    0.000000] RSP: 0018:ffff810225a779a0
>> EFLAGS: 00000246
>> Mar  3 15:21:14 vpn kernel: [    0.000000] RAX: 0000000000000000 RBX:
>> ffffc20001a1ab80 RCX: 0000000000000000
>> Mar  3 15:21:14 vpn kernel: [    0.000000] RDX: 0000000000000014 RSI:
>> 0000000000000246 RDI: ffff8102249d5aa8
>> Mar  3 15:21:14 vpn kernel: [    0.000000] RBP: ffff810225a77920 R08:
>> 0000000000001000 R09: 0000000002000000
>> Mar  3 15:21:14 vpn kernel: [    0.000000] R10: 0000000000000000 R11:
>> ffff81021ac01300 R12: ffffffff8020cfb6
>> Mar  3 15:21:14 vpn kernel: [    0.000000] R13: 0000000000000000 R14:
>> ffff8102249d5a80 R15: 0000000000000010
>> Mar  3 15:21:14 vpn kernel: [    0.000000] FS:  0000000000000000(0000)
>> GS:ffff81022590cd00(0000) knlGS:0000000000000000
>> Mar  3 15:21:14 vpn kernel: [    0.000000] CS:  0010 DS: 0018 ES: 0018
>> CR0: 000000008005003b
>> Mar  3 15:21:14 vpn kernel: [    0.000000] CR2: 00007fa2778f7315 CR3:
>> 0000000000201000 CR4: 00000000000006e0
>> Mar  3 15:21:14 vpn kernel: [    0.000000] DR0: 0000000000000000 DR1:
>> 0000000000000000 DR2: 0000000000000000
>> Mar  3 15:21:14 vpn kernel: [    0.000000] DR3: 0000000000000000 DR6:
>> 00000000ffff0ff0 DR7: 0000000000000400
>> Mar  3 15:21:14 vpn kernel: [    0.000000]
>> Mar  3 15:21:14 vpn kernel: [    0.000000] Call Trace:
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  <IRQ>  [<ffffffff8825ab1c>]
>> :e1000:e1000_xmit_frame+0x8fc/0xcb0
>> Mar  3 15:21:14 vpn kernel: [    0.000000]
>> [e1000:____versions+0x56f3/0x7340]
>> :nf_conntrack_ipv4:ipv4_confirm+0x33/0x60
>> Mar  3 15:21:14 vpn kernel: [    0.000000]
>> [dev_hard_start_xmit+0x22c/0x2a0] dev_hard_start_xmit+0x22c/0x2a0
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [__qdisc_run+0x74/0x1f0]
>> __qdisc_run+0x74/0x1f0
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [dev_queue_xmit+0x1e8/0x300]
>> dev_queue_xmit+0x1e8/0x300
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [pptp:pptp_xmit+0x567/0x7e0]
>> :pptp:pptp_xmit+0x567/0x7e0
>> Mar  3 15:21:14 vpn kernel: [    0.000000]
>> [ppp_generic:ppp_push+0x45c/0x620] :ppp_generic:ppp_push+0x45c/0x620
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [<ffffffff8827b235>]
>> :sch_htb:htb_safe_rb_erase+0x15/0x50
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [<ffffffff8827b635>]
>> :sch_htb:htb_deactivate_prios+0x1a5/0x250
>> Mar  3 15:21:14 vpn kernel: [    0.000000]
>> [ppp_generic:ppp_xmit_process+0x469/0x640]
>> :ppp_generic:ppp_xmit_process+0x469/0x640
>> Mar  3 15:21:14 vpn kernel: [    0.000000]
>> [ppp_generic:ppp_start_xmit+0x151/0x1e0]
>> :ppp_generic:ppp_start_xmit+0x151/0x1e0
>> Mar  3 15:21:14 vpn kernel: [    0.000000]
>> [dev_hard_start_xmit+0x22c/0x2a0] dev_hard_start_xmit+0x22c/0x2a0
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [__qdisc_run+0x74/0x1f0]
>> __qdisc_run+0x74/0x1f0
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [dev_queue_xmit+0x1e8/0x300]
>> dev_queue_xmit+0x1e8/0x300
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [ip_rcv_finish+0x114/0x3b0]
>> ip_rcv_finish+0x114/0x3b0
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [ip_rcv+0x212/0x300]
>> ip_rcv+0x212/0x300
>> Mar  3 15:21:14 vpn kernel: [    0.000000]
>> [e1000:netif_receive_skb+0x3ac/0xd80] netif_receive_skb+0x3ac/0x490
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [<ffffffff8825c7a4>]
>> :e1000:e1000_clean_rx_irq+0x1c4/0x590
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [<ffffffff88259609>]
>> :e1000:e1000_clean+0x69/0x250
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [net_rx_action+0x128/0x230]
>> net_rx_action+0x128/0x230
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [__do_softirq+0x75/0xe0]
>> __do_softirq+0x75/0xe0
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [call_softirq+0x1c/0x30]
>> call_softirq+0x1c/0x30
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  <EOI>
>> [pptp:_ack_timeout_work+0x0/0x20] :pptp:_ack_timeout_work+0x0/0x20
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [do_softirq+0x35/0x90]
>> do_softirq+0x35/0x90
>> Mar  3 15:21:14 vpn kernel: [    0.000000]
>> [local_bh_enable_ip+0x54/0x60] local_bh_enable_ip+0x54/0x60
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [run_workqueue+0xcc/0x170]
>> run_workqueue+0xcc/0x170
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [worker_thread+0x0/0x110]
>> worker_thread+0x0/0x110
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [worker_thread+0x0/0x110]
>> worker_thread+0x0/0x110
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [worker_thread+0xa3/0x110]
>> worker_thread+0xa3/0x110
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [<ffffffff802543d0>]
>> autoremove_wake_function+0x0/0x30
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [worker_thread+0x0/0x110]
>> worker_thread+0x0/0x110
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [worker_thread+0x0/0x110]
>> worker_thread+0x0/0x110
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [kthread+0x4b/0x80]
>> kthread+0x4b/0x80
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [child_rip+0xa/0x12]
>> child_rip+0xa/0x12
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [kthread+0x0/0x80]
>> kthread+0x0/0x80
>> Mar  3 15:21:14 vpn kernel: [    0.000000]  [child_rip+0x0/0x12]
>> child_rip+0x0/0x12
>> Mar  3 15:21:14 vpn kernel: [    0.000000]
>>
>> One of my CPUs goes 100% with ksoftirqd.
> 
> sysreq-t?
> 
>> Latency increases signifcantly during this this (more than >100ms).
>>
>>
>> ethtool -G eth0 tx 4096 rx 4096
>> ethtool -G eth1 tx 4096 rx 4096
> 
> unless you're not seeing rx_no_buffer_count increase in the `ethtool -S ethx`
> increase this is unnecesary
> 
>> echo "8192" > /proc/sys/vm/min_free_kbytes
> 
> ditto
> 
>> I attached IRQ to different CPUs by:
>> /bin/echo "0f" > /proc/irq/2297/smp_affinity
>> /bin/echo "f0" > /proc/irq/2296/smp_affinity
>>
>> root@vpn:~# cat /proc/interrupts
>>            CPU0       CPU1       CPU2       CPU3       CPU4       CPU5
>>       CPU6       CPU7
>>   0:         72          0          0          0          0          0
>>          0          0    XT-PIC-XT        timer
>>   1:          2          0          0          0          0          0
>>          0          0    XT-PIC-XT        i8042
>>   2:          0          0          0          0          0          0
>>          0          0    XT-PIC-XT        cascade
>>   8:          1          0          0          0          0          0
>>          0          0    XT-PIC-XT        rtc
>>  11:       9117          0          0          0          0          0
>>          0          0    XT-PIC-XT        aic94xx
>>  14:         84          0          0          0          0          0
>>          0          0    XT-PIC-XT        libata
>>  15:          0          0          0          0          0          0
>>          0          0    XT-PIC-XT        libata
>> 2296:      76853      76976      76639      76692     248073     247957
>>     248079     248084   PCI-MSI-edge      eth1
>> 2297:     266795     266672     267009     266956      93920      94035
>>      93914      93908   PCI-MSI-edge      eth0
> 
> your cpu is round-robinning network interrupts which is bad, turn the in-kernel
> irqbalance feature OFF and use the userspace irqbalance tool instead
> 
>> ifconfig eth0 txqueuelen 1000
>> ifconfig eth1 txqueuelen 1000
>>
>> I wanted to switch to e1000e driver instead of e1000 as I've in kernel:
>>
>> CONFIG_E1000=m
>> CONFIG_E1000E=m
>> # CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
>> CONFIG_E1000_NAPI=y
>>
>> I'm trying to load it by:
>> modprobe -r e1000; modprobe e1000e; /etc/init.d/networking restart
>>
>> but NICs aren't detected :(
>>
>> Why so?
> 
> because that device is not going to be supported by e1000e until 2.6.25. you're
> using 2.6.24 so you need to use e1000 just one kernel release longer.
> 
>> I have (lspci -vvv output):
>>
>> 06:00.0 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit
>> Ethernet Controller (Copper) (rev 01)
>>         Subsystem: Super Micro Computer Inc Unknown device 0000
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr+ Stepping- SERR+ FastB2B-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR-
>>         Latency: 0, Cache Line Size: 32 bytes
>>         Interrupt: pin A routed to IRQ 2297
>>         Region 0: Memory at d8300000 (32-bit, non-prefetchable) [size=128K]
>>         Region 2: I/O ports at 3000 [size=32]
>>         Capabilities: [c8] Power Management version 2
>>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
>>         Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+
>> Queue=0/0 Enable+
>>                 Address: 00000000fee0f00c  Data: 41b9
>>         Capabilities: [e0] Express Endpoint IRQ 0
>>                 Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
>> ExtTag-
>>                 Device: Latency L0s <512ns, L1 <64us
>>                 Device: AtnBtn- AtnInd- PwrInd-
>>                 Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>>                 Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>                 Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
>>                 Link: Supported Speed 2.5Gb/s, Width x4, ASPM unknown,
>> Port 0
>>                 Link: Latency L0s <128ns, L1 <64us
>>                 Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
>>                 Link: Speed 2.5Gb/s, Width x4
>>
>> 06:00.1 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit
>> Ethernet Controller (Copper) (rev 01)
>>         Subsystem: Super Micro Computer Inc Unknown device 0000
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr+ Stepping- SERR+ FastB2B-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR-
>>         Latency: 0, Cache Line Size: 32 bytes
>>         Interrupt: pin B routed to IRQ 2296
>>         Region 0: Memory at d8320000 (32-bit, non-prefetchable) [size=128K]
>>         Region 2: I/O ports at 3020 [size=32]
>>         Capabilities: [c8] Power Management version 2
>>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>>                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
>>         Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+
>> Queue=0/0 Enable+
>>                 Address: 00000000feef000c  Data: 41c1
>>         Capabilities: [e0] Express Endpoint IRQ 0
>>                 Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
>> ExtTag-
>>                 Device: Latency L0s <512ns, L1 <64us
>>                 Device: AtnBtn- AtnInd- PwrInd-
>>                 Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>>                 Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>                 Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
>>                 Link: Supported Speed 2.5Gb/s, Width x4, ASPM unknown,
>> Port 0
>>                 Link: Latency L0s <128ns, L1 <64us
>>                 Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
>>                 Link: Speed 2.5Gb/s, Width x4
>>
>> So I still have to use e1000 with InterruptThrottleRate=0,0
>> RxIntDelay=0,0 RxAbsIntDelay=0,0 TxIntDelay=0,0 TxAbsIntDelay=0,0:
> 
> just use the defaults for e1000 please, unless those defaults don't work - and
> then it's a bug.
> 
> 
> I don't think e1000 is the issue here, I've definately not seen any reports of
> e1000+pptp giving issues. perhaps one of the pptp/pppd developers can look at the
> stack trace.
> 

I cant find pptp_xmit() function in 2.6.24 sources. I must be blind, or some 
contextual information is missing.


