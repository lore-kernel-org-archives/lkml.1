Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbYFMUKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbYFMUKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 16:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbYFMUKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 16:10:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46012 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbYFMUKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 16:10:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.26-git: NULL pointer deref in __switch_to
Date: Fri, 13 Jun 2008 22:10:52 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
References: <4852B19E.4010202@trash.net>
In-Reply-To: <4852B19E.4010202@trash.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806132210.52840.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 13 of June 2008, Patrick McHardy wrote:
> I get this oops once a day, its apparently triggered by something
> run by cron, but the process is a different one each time.
> 
> Kernel is -git from yesterday shortly before the -rc6 release
> (last commit is the usb-2.6 merge, the x86 patches are missing),
> .config is attached.
> 
> I'll retry with current -git, but the patches that have gone in
> since I last updated don't look related.

Is this a regression from 2.6.25?

> [62060.043009] BUG: unable to handle kernel NULL pointer dereference at 
> 000001ff
> [62060.043009] IP: [<c0102a9b>] __switch_to+0x2f/0x118
> [62060.043009] *pde = 00000000
> [62060.043009] Oops: 0002 [#1] PREEMPT
> [62060.043009] Modules linked in: nfsd lockd nfs_acl auth_rpcgss sunrpc 
> exportfs sch_red cls_fw cls_flow tun sit tunnel4 sch_drr sch_hfsc 
> af_packet xt_statistic xt_CONNMARK xt_connmark xt_length xt_owner 
> xt_MARK ip6table_mangle ipt_MASQUERADE ipt_REDIRECT ipt_TTL 
> iptable_mangle iptable_nat nf_nat_sip nf_nat_irc nf_conntrack_irc 
> nf_nat_ftp nf_nat nf_conntrack_ftp ip6t_hl ip6t_REJECT ip6t_ah 
> ip6table_filter ipt_ttl ipt_REJECT xt_limit ipt_ah xt_esp xt_state 
> xt_TCPMSS xt_tcpmss xt_helper xt_tcpudp xt_hashlimit iptable_filter 
> ip6table_raw ip6_tables xt_policy xt_NFLOG iptable_raw ip_tables 
> x_tables nfnetlink_log nfnetlink nf_conntrack_ipv6 nf_conntrack_ipv4 
> nf_conntrack_sip nf_conntrack deflate zlib_deflate zlib_inflate ctr 
> twofish twofish_common camellia serpent blowfish des_generic xcbc 
> sha256_generic sha1_generic crypto_null af_key cbc dm_crypt 
> crypto_blkcipher dm_snapshot dm_mod lg cpufreq_ondemand p4_clockmod 
> speedstep_lib aes_i586 aes_generic esp6 esp4 aead usblp parport_pc 
> parport ehci_hcd ohci_hcd rtc e1000 sata_promise usbcore unix
> [62060.043009]
> [62060.043009] Pid: 18031, comm: find Not tainted (2.6.26-rc5 #5)
> [62060.043009] EIP: 0060:[<c0102a9b>] EFLAGS: 00010002 CPU: 0
> [62060.043009] EIP is at __switch_to+0x2f/0x118
> [62060.043009] EAX: 00000000 EBX: f7cf6c38 ECX: f6cfd0e0 EDX: f7cf6a20
> [62060.043009] ESI: f7cf6a20 EDI: f6cfd0e0 EBP: f7c41f04 ESP: f7c41ef4
> [62060.043009]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [62060.043009] Process find (pid: 18031, ti=f7c41000 task=f6cfd0e0 
> task.ti=f571c000)
> [62060.043009] Stack: f6cfd2f8 f7cf6a20 00000000 f6040d80 f571cde0 
> c0321c3c f7c41f34 00000046
> [62060.043009]        f7c41f98 f7c41fcc f6ac90e0 f7cf6a20 f7cf6b74 
> 00000001 c04153c0 f7c41f98
> [62060.043009]        f7c41fcc c015159a f7cf6a48 c047f934 f7c41f70 
> c047f918 c0415e68 00000000
> [62060.043009] Call Trace:
> [62060.043009]  [<c0321c3c>] ? schedule+0x1a6/0x2e5
> [62060.043009]  [<c015159a>] ? kswapd+0x387/0x3f3
> [62060.043009]  [<c01164d0>] ? __dequeue_entity+0x24/0x95
> [62060.043009]  [<c014fb1a>] ? isolate_pages_global+0x0/0x46
> [62060.043009]  [<c012e582>] ? autoremove_wake_function+0x0/0x3a
> [62060.043009]  [<c0151213>] ? kswapd+0x0/0x3f3
> [62060.043009]  [<c0151213>] ? kswapd+0x0/0x3f3
> [62060.043009]  [<c012e285>] ? kthread+0x36/0x5a
> [62060.043009]  [<c012e24f>] ? kthread+0x0/0x5a
> [62060.043009]  [<c01047ef>] ? kernel_thread_helper+0x7/0x18
> [62060.043009]  =======================
> [62060.043009] Code: 56 53 83 ec 04 89 c7 89 d6 8d 80 18 02 00 00 89 45 
> f0 8d 9a 18 02 00 00 8b 47 04 f6 40 0c 01 0f 84 c9 00 00 00 8b 87 6c 02 
> 00 00 <0f> ae 00 0f ba 60 02 07 73 02 db e2 0f 1f 00 90 8d b4 26 00 00
> [62060.043009] EIP: [<c0102a9b>] __switch_to+0x2f/0x118 SS:ESP 0068:f7c41ef4
> [62060.043009] ---[ end trace b024364060382aa3 ]---
> [62060.043009] note: find[18031] exited with preempt_count 2
