Return-Path: <linux-kernel-owner+w=401wt.eu-S1761231AbYCaOwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761231AbYCaOwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYCaOwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:52:24 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:44873 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbYCaOwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:52:22 -0400
Message-ID: <47F0FA9B.5070807@linux.vnet.ibm.com>
Date: Mon, 31 Mar 2008 20:22:11 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: kernel list <linux-kernel@vger.kernel.org>
CC: linuxppc-dev@ozlabs.org, mingo@elte.hu,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>
Subject: [BUG] 2.6.24.4 - kernel bug at kernel/sched.c:5154!
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The 2.6.24.4 kernel panic's while booting up on powerpc, The kernel
was compiled with allmodconfig. (please let me know if the .config 
file is needed)


[    0.000000] Kernel command line: ro console=hvc0 rhgb quiet root=LABEL=/1 autobench_args: root=/dev/sda3 ABAT:1206964330 
[    0.103959] BUG: scheduling while atomic: kthreadd/2/0x0007431c
[    0.104051] BUG: scheduling while atomic: kthreadd/3/0xbe118168
[    0.104119] ------------[ cut here ]------------
[    0.104127] kernel BUG at kernel/sched.c:5154!
cpu 0x0: Vector: 700 (Program Check) at [c0000001be11bd70]
    pc: c000000000070b34: .migration_thread+0x64/0x31c
    lr: c000000000093878: .kthread+0x78/0xc4
    sp: c0000001be11bff0
   msr: 8000000000029032
  current = 0xc0000000ee0ed740
  paca    = 0xc000000000497500
    pid   = 3, comm = kthreadd
kernel BUG at kernel/sched.c:5154!
enter ? for help
[c0000001be11c0b0] c000000000093878 .kthread+0x78/0xc4
[c0000001be11c140] c00000000002906c .kernel_thread+0x4c/0x68

0:mon> r
R00 = 0000000000000001   R16 = 0000000000000000
R01 = c0000001be11bff0   R17 = 0000000000000000
R02 = c00000000053ab90   R18 = 0000000000000000
R03 = 0000000000000000   R19 = 4000000001c00000
R04 = c0000000ee0ed740   R20 = c000000000453218
R05 = 0000000000000000   R21 = 0000000002053488
R06 = c000000000497500   R22 = 00000000002c2000
R07 = c0000001be1181b0   R23 = c000000000453488
R08 = 0000000000000000   R24 = 0000000002053218
R09 = c0000000ee0ed73f   R25 = 0000000000000000
R10 = fffffffffffffffc   R26 = c0000000005d40f8
R11 = c000000000497500   R27 = c0000000005d00b0
R12 = c00000000002906c   R28 = c0000001be0c3ca8
R13 = c000000000497500   R29 = c000000000685c00
R14 = 0000000000000000   R30 = c0000000004f7210
R15 = 0000000000000000   R31 = c00000000050c788
pc  = c000000000070b34 .migration_thread+0x64/0x31c
lr  = c000000000093878 .kthread+0x78/0xc4
msr = 8000000000029032   cr  = 28000024
ctr = c000000000070ad0   xer = 0000000020000004   trap =  700

0:mon>  t
[c0000001be11c0b0] c000000000093878 .kthread+0x78/0xc4
[c0000001be11c140] c00000000002906c .kernel_thread+0x4c/0x68
0:mon>  S
msr  = 8000000000001032  sprg0= 0000000000000000
pvr  = 00000000003b0200  sprg1= c000000000497500
dec  = 00000000c4ac67ed  sprg2= c000000000497500
sp   = c0000001be11b620  sprg3= c000000000497500
toc  = c00000000053ab90  dar  = 0000000000000000

0xc000000000070b34 is in migration_thread (kernel/sched.c:5154).
5149    {
5150            int cpu = (long)data;
5151            struct rq *rq;
5152
5153            rq = cpu_rq(cpu);
5154            BUG_ON(rq->migration_thread != current);
5155
5156            set_current_state(TASK_INTERRUPTIBLE);
5157            while (!kthread_should_stop()) {
5158                    struct migration_req *req;
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
