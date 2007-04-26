Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbXDZUcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbXDZUcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbXDZUcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:32:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026AbXDZUch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:32:37 -0400
Message-ID: <46310B19.8@redhat.com>
Date: Thu, 26 Apr 2007 16:27:05 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (Macintosh/20070221)
MIME-Version: 1.0
To: Vincent ETIENNE <ve@vetienne.net>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, fubar@us.ibm.com,
       bonding-devel@lists.sourceforge.net
Subject: Re: [PROBLEM] Bonding driver in linux-2.6.21-rc6-mm1
References: <200704262058.33087.ve@vetienne.net>
In-Reply-To: <200704262058.33087.ve@vetienne.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vincent ETIENNE wrote:
> Hi,
>  
>  Summary :
> 	Got this trace when one network interface come down or up in a 2
> 	interfaces bonding.	So far, system seems to survive to this problem
> 	and works fine.

I'm investigating a similar/possibly identical bug.  Do you experience 
packet loss or throughput stalls, beyond just the loss of the interface 
that went down, when this happens?

	-- Chris

>  Full description
>  
> 	During testing of bonding of 2 interfaces, i have seen this from
> 	time to time in my log file ( the problem doesn't arrive each
> 	time but one in 3 or 4 try ). 
> 
> 	SYSTEM :	 2 NIC card bond on interface bond0 : 
> 				intel PRO/1000 (e1000 )
> 				Broadcomm ( tg3 )
> 	I have also try a 2.6.20 and 2.6.19 vanilla kernel ( identical problem but in 
> 	onecase the system doesn't survive : that the reason the problem catch my 
> 	attention )
>  
> 	Keywords	; network, bonding
>  
> 	Version : Linux version 2.6.21-rc6-mm1 (root@jupiter2) (gcc version 4.1.1
> 	(Gentoo 4.1.1-r3)) #3 SMP Thu Apr 26 08:45:06 CEST 2007
>  
> 	Output of /var/log/messages
>  
> 		Apr 26 11:09:34 jupiter2 e1000: eth0: e1000_watchdog_task: NIC Link
> 		is Down Apr 26 11:09:34 jupiter2 bonding: bond0: link status
> 		definitely down for interface eth0, disabling it
> 		Apr 26 11:09:34 jupiter2 bonding: bond0: making interface eth1 the new
> 		active one.
> 		Apr 26 11:09:34 jupiter2 RTNL: assertion failed at net/ipv4/devinet.c
> 		(1055) Apr 26 11:09:34 jupiter2
> 		Apr 26 11:09:34 jupiter2 Call Trace:
> 		Apr 26 11:09:34 jupiter2 <IRQ>  [<ffffffff8049b49e>] 
> inetdev_event+0x48/0x283
> 		Apr 26 11:09:34 jupiter2 [<ffffffff804c8731>] _spin_lock_bh+0x9/0x19
> 		Apr 26 11:09:34 jupiter2 [<ffffffff80473df1>] rt_run_flush+0x7e/0xaf
> 		Apr 26 11:09:34 jupiter2 [<ffffffff8022bdd0>] notifier_call_chain+0x29/0x56 
> 		Apr 26 11:09:34 jupiter2 [<ffffffff804560cc>] dev_set_mac_address+0x53/0x59 			
> 		Apr 26 11:09:34 jupiter2 [<ffffffff88006d8d>] 
> bonding:alb_set_slave_mac_addr+0x41/0x6c
> 		Apr 26 11:09:34 jupiter2 [<ffffffff88007215>] 
> bonding:alb_swap_mac_addr+0x91/0x165
> 		Apr 26 11:09:34 jupiter2 [<ffffffff88002029>] 
> bonding:bond_change_active_slave+0x227/0x382
> 		Apr 26 11:09:34 jupiter2 [<ffffffff880024c9>]
> 		bonding:bond_select_active_slave+0xb7/0xe5
> 		Apr 26 11:09:34 jupiter2 [<ffffffff88004182>] 
> bonding:bond_mii_monitor+0x3cd/0x41e
> 		Apr 26 11:09:34 jupiter2 [<ffffffff88003db5>] 
> bonding:bond_mii_monitor+0x0/0x41e
> 		Apr 26 11:09:34 jupiter2 [<ffffffff80228714>]
>  run_timer_softirq+0x130/0x19f
> 		Apr 26 11:09:34 jupiter2[<ffffffff8022618a>] __do_softirq+0x55/0xc4 
> 		Apr 26 11:09:34 jupiter2 [<ffffffff8020a5ac>] call_softirq+0x1c/0x28
> 		Apr 26 11:09:34 jupiter2 [<ffffffff8020bead>] do_softirq+0x2c/0x7d
> 		Apr 26 11:09:34 jupiter2 [<ffffffff80213b2a>] 
> smp_apic_timer_interrupt+0x49/0x5f
> 		 Apr 26 11:09:34 jupiter2 [<ffffffff802088a3>] mwait_idle+0x0/0x45
> 		Apr 26 11:09:34 jupiter2 [<ffffffff8020a056>] apic_timer_interrupt+0x66/0x70
> 		 Apr 26 11:09:34 jupiter2 <EOI>  [<ffffffff802088e5>] mwait_idle+0x42/0x45 
> 		Apr 26 11:09:34 jupiter2 [<ffffffff8020883f>] cpu_idle+0x51/0x70 
> 		Apr 26 11:09:34 jupiter2 [<ffffffff806369bd>] start_kernel+0x242/0x24e
> 		Apr 26 11:09:34 jupiter2 [<ffffffff80636146>] _sinittext+0x146/0x14a
>  
>  
> other  informations (ver_linux, lspci, ...  ) available at 
> http://mail1.vetienne.net/linux
> 
> I'm a bit worried by the message so any help will be greatly appreciated
> 
> 	Vincent

