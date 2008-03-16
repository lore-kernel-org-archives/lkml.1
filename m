Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbYCPK1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbYCPK1N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 06:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbYCPK05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 06:26:57 -0400
Received: from alliance-computing.co.uk ([217.33.254.230]:42216 "EHLO
	alliance-computing.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbYCPK0z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 06:26:55 -0400
From: "rhh" <rhh@bytron.com>
To: <linux-kernel@vger.kernel.org>
Subject: Kernel Oops problem
Date: Sun, 16 Mar 2008 10:26:38 -0000
Message-ID: <004001c88750$383b8f60$0b0aa8c0@asus>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AciG+D0ZLckrckr1So+1M1E/WJhmcQAV5S4g
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - alliance-computing.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - bytron.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

A server of mine has recently been suffering a “Kernel Oops”.  The following
link
http://users.sosdg.org/~qiyong/lxr/source/Documentation/oops-tracing.txt?v=2
.6.16 contains information on how to trace and log a “Kernel Oops” problem. 
The link offers your email address if, to quote ‘If you are totally stumped
as to whom to send the report’.  Please accept my apologies if I have the
wrong information for reporting a ‘Kernel Oops’ problem.  I believe the
ksysmoops utility in my case is useless, again to quote the above link
‘NOTE: ksymoops is useless on 2.6.’; hence, I am stumped.

The server in question is running the following:

	home# uname -a
	Linux <xyz> 2.6.9-55.0.9.ELsmp #1 SMP Thu Sep 27 18:27:41 EDT 2007
i686 i686 i386 GNU/Linux

	home# cat /etc/redhat-release
	CentOS release 4.6 (Final)

The Oops seems to occur at a random interval, but, has constant detail in
the report:

	home# tail -n80000 /var/log/messages  | grep  "Oops"
	Mar 10 19:15:58 home kernel: Oops: 0000 [#1]
	Mar 11 01:50:33 home kernel: Oops: 0000 [#1]
	Mar 12 10:44:38 home kernel: Oops: 0000 [#1]
	Mar 15 00:58:24 home kernel: Oops: 0000 [#1]

The detail obtained so far is:

Unable to handle kernel paging request at virtual address 00100100
printing eip:
c011e7ea
*pde = 3584d001
Oops: 0000 [#1]
SMP
Modules linked in: loop ipt_owner parport_pc lp parport autofs4 md5 ipv6
ipt_REJECT ipt_state ip_conntrack iptable_filter ip_tables button battery ac
tg3 floppy dm_snapshot dm_zero dm_mirror ext3 jbd dm_mod cciss sd_mod
scsi_mod
CPU:    1
EIP:    0060:[<c011e7ea>]    Not tainted VLI
EFLAGS: 00010046   (2.6.9-55.0.9.ELsmp)
EIP is at __wake_up_common+0x13/0x51
eax: 00000000   ebx: e964500c   ecx: c282dde0   edx: 00100100
esi: 00000000   edi: f3fb5118   ebp: c2b75f1c   esp: c2b75f04
ds: 007b   es: 007b   ss: 0068
Process authdaemond (pid: 2574, threadinfo=c2b75000 task=f59c4230)
Stack: 00000000 00100100 00000001 f3fb5118 00000000 00000000 c2b75f40
c011e851
       00000000 00000000 00000246 00000001 f3fb5118 f5fb7980 f2458c80
f7e0be00
       c027c767 00000000 f5fb7980 00000000 c02cecc9 00000001 f575f5a4
00000000
Call Trace:
 [<c011e851>] __wake_up+0x29/0x3c
 [<c027c767>] sock_def_wakeup+0x2e/0x3c
 [<c02cecc9>] unix_release_sock+0x118/0x209
 [<c0279676>] sock_release+0x11/0x85
 [<c027a0dd>] sock_close+0x26/0x2a
 [<c015c1b6>] __fput+0x55/0x100
 [<c015add0>] filp_close+0x59/0x5f
 [<c015ae31>] sys_close+0x5b/0x92
 [<c02d64db>] syscall_call+0x7/0xb
Code: 83 c4 1c 5b 5e 5f 5d e9 64 fb ff ff 55 89 e5 5d 8b 40 04 e9 8f e8 ff
ff 55 89 e5 57 89 c7 56 89 ce 53 83 ec 0c 89 55 f0 8b 50 08 <8b> 02 89 45 ec
8d 47 08 39 c2 74 2a 8d 5a f4 8b 52 f4 8b 4d 08
 <0>Fatal exception: panic in 5 seconds

Any advice either on the correct way to report this or extra commands to run
to obtain the reason or fix would be gratefully appreciated.

Regards

Ray Hammond


