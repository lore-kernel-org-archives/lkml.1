Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbZHYTqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbZHYTqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbZHYTqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:46:54 -0400
Received: from hosting.visp.net.lb ([194.146.153.11]:40867 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936AbZHYTqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:46:54 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Aug 2009 15:46:53 EDT
From: Denys Fedoryschenko <denys@visp.net.lb>
Organization: VISP
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: unable to handle kernel NULL pointer / tty / 2.6.31-rc7
Date: Tue, 25 Aug 2009 22:37:54 +0300
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908252237.54324.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel 2.6.31-rc7
x86 , 32-bit
gcc 4.4.1


Happened on heavy network load, i don't know if it is related.

Here is part of remote syslog, notice failed dropbear ssh authentication.
I guess if it is not fixed - it is critical to upcoming release, seems bug 
triggered by ssh worm.

Aug 25 22:34:35 10.22.24.2 login[2099]: pam_radius_auth: DEBUG: 
getservbyname(radius, udp) returned -1209037784.
Aug 25 22:34:36 10.22.24.2 login[2099]: pam_unix(login:auth): authentication 
failure; logname= uid=0 euid=0 tty=pts/0 ruser= rhost=  user=root
Aug 25 22:34:37 10.22.24.2 ripd[1862]: rip_read: cannot find interface for 
packet from 80.83.24.49 port 520
Aug 25 22:34:41 10.22.24.2 ripd[1862]: Neighbor 10.22.22.2 doesnt have 
connected interface!
Aug 25 22:34:46 10.22.24.2 kernel: [22630.973706] BUG: unable to handle kernel 
NULL pointer dereference at (null)
Aug 25 22:34:46 10.22.24.2 kernel: [22630.973807] IP: [<c0251814>] 
n_tty_read+0x3c6/0x5ad

Full BUG message


 [22630.973706] BUG: unable to handle kernel NULL pointer dereference at 
(null)
 [22630.973807] IP: [<c0251814>] n_tty_read+0x3c6/0x5ad
 [22630.973909] *pdpt = 0000000032327001 *pde = 0000000000000000
 [22630.973927] Oops: 0000 [#1] SMP
 [22630.973927] last sysfs file: /sys/devices/virtual/vc/vcsa3/dev
 [22630.973927] Modules linked in: cls_u32 sch_htb tun nf_defrag_ipv4 xt_MARK 
xt_mark xt_tcpudp rtc_cmos rtc_core rtc_lib iptable_mangle e1000e 
iptable_filter ip_tables
 [22630.973927]
 [22630.973927] Pid: 2100, comm: login Not tainted 
(2.6.31-rc7-build-0046-32bit #10)
 [22630.973927] EIP: 0060:[<c0251814>] EFLAGS: 00010246 CPU: 2
 [22630.973927] EIP is at n_tty_read+0x3c6/0x5ad
 [22630.973927] EAX: 00000000 EBX: f23aa988 ECX: 00000002 EDX: 00000000
 [22630.973927] ESI: f23aa800 EDI: 00000000 EBP: f64eef40 ESP: f64eeee0
 [22630.973927]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
 [22630.973927] Process login (pid: 2100, ti=f64ee000 task=f6f3a0a0 
task.ti=f64ee000)
 [22630.973927] Stack:
 [22630.973927]  bfd0ddac f3056200 f23aa91c f23aaba0 f23aabf8 00000000 
00000000 00000000
 [22630.973927] <0> 7fffffff 00000000 00000286 f23aa920 f23aa988 f23aa898 
f23aa800 00000000
 [22630.973927] <0> f6f3a0a0 c01293a4 f23aa920 f23aa920 bfd0ddac fffffffb 
f23aa800 c025144e
 [22630.973927] Call Trace:
 [22630.973927]  [<c01293a4>] ? default_wake_function+0x0/0xd
 [22630.973927]  [<c025144e>] ? n_tty_read+0x0/0x5ad
 [22630.973927]  [<c024dfd6>] ? tty_read+0x62/0x99
 [22630.973927]  [<c024df74>] ? tty_read+0x0/0x99
 [22630.973927]  [<c0190dae>] ? vfs_read+0x87/0x110
 [22630.973927]  [<c0190ed0>] ? sys_read+0x3b/0x60
 [22630.973927]  [<c0102955>] ? syscall_call+0x7/0xb
 [22630.973927] Code: 4c 01 00 00 10 0f 85 95 00 00 00 e9 ae 00 00 00 8b 86 80 
01 00 00 8b 5d d0 f0 0f b3 03 19 ff 8b 96 78 01 00 00 8b 86 80 01 00 00 <0f> 
be 04 02 89
 [22630.973927] EIP: [<c0251814>] n_tty_read+0x3c6/0x5ad SS:ESP 0068:f64eeee0
 [22630.973927] CR2: 0000000000000000
 [22630.977423] ---[ end trace 688db8f89c0bcf7b ]---
 [22630.977544] Kernel panic - not syncing: Fatal exception
 [22630.977672] Pid: 2100, comm: login Tainted: G      D    
2.6.31-rc7-build-0046-32bit #10
 [22630.977842] Call Trace:
 [22630.977965]  [<c02fac50>] ? printk+0xf/0x17
 [22630.978080]  [<c02faba1>] panic+0x39/0xd9
 [22630.978197]  [<c0105997>] oops_end+0x8b/0x9a
 [22630.978305]  [<c0118f2d>] no_context+0x13d/0x147
 [22630.978416]  [<c011904a>] __bad_area_nosemaphore+0x113/0x11b
 [22630.978531]  [<c02fb622>] ? schedule+0x75d/0x7c7
 [22630.978645]  [<c0119092>] bad_area+0x30/0x39
 [22630.978757]  [<c0119318>] do_page_fault+0x16b/0x26f
 [22630.978872]  [<c01191ad>] ? do_page_fault+0x0/0x26f
 [22630.979007]  [<c02fcca6>] error_code+0x66/0x6c
 [22630.979134]  [<c01191ad>] ? do_page_fault+0x0/0x26f
 [22630.979258]  [<c0251814>] ? n_tty_read+0x3c6/0x5ad
 [22630.979377]  [<c01293a4>] ? default_wake_function+0x0/0xd
 [22630.979492]  [<c025144e>] ? n_tty_read+0x0/0x5ad
 [22630.979605]  [<c024dfd6>] tty_read+0x62/0x99
 [22630.979712]  [<c024df74>] ? tty_read+0x0/0x99
 [22630.979820]  [<c0190dae>] vfs_read+0x87/0x110
 [22630.979963]  [<c0190ed0>] sys_read+0x3b/0x60
