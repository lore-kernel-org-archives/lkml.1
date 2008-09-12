Return-Path: <linux-kernel-owner+w=401wt.eu-S1757628AbYILU1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbYILU1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 16:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbYILU1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:27:36 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:41808 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755374AbYILU1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:27:35 -0400
Date: Fri, 12 Sep 2008 22:27:32 +0200
From: Robert Schwebel <robert@schwebel.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.26.5-rt9
Message-ID: <20080912202732.GM9852@pengutronix.de>
References: <1221166441.22713.36.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1221166441.22713.36.camel@localhost.localdomain>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Hannoversche
	Str. 2, 31134 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-9 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 22:22:21 up 73 days,  9:05, 15 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 10.1.0.65
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 04:54:01PM -0400, Steven Rostedt wrote:
> We are pleased to announce the 2.6.26.5-rt9 tree, which can be
> downloaded from the location:

On the MPC5121e-ADS (Powerpc 32) I get this oops during my boot sequence when
enabling CONFIG_DYNAMIC_FTRACE. Without that option the oops doesn't happen.

----------8<----------

starting network interfaces...
lo        Link encap:Local Loopback
eth0      Link encap:Ethernet  HWaddr 00:1E:59:2F:03:60
/etc/network/can-pre-up: line 7: can0: not found
starting inetd...done
thttpd:  starting
thttpd:  done
pure-ftpd: no /etc/pure-ftpd.defaults found.
/usr/sbin/pure-ftpd
pure-ftpd: starting pure-ftpd: /usr/sbin/pure-ftpd
Unable to handle kernel paging request for data at address 0x28002846
Faulting instruction address: 0xc00784c0
Oops: Kernel access of bad area, sig: 11 [#1]
PREEMPT MPC5121 ADS
Modules linked in:
NIP: c00784c0 LR: c0078864 CTR: c001af30
REGS: df213cc0 TRAP: 0300   Not tainted  (2.6.26.5-rt9)
MSR: 00009032 <EE,ME,IR,DR>  CR: 22002848  XER: 00000000
DAR: 28002846, DSISR: 20000000
TASK = df1d8600[437] 'S05_pureftpd' THREAD: df212000
GPR00: c0078864 df213d70 df1d8600 c028cc18 c028cf7c c03694f8 00000000 00000000
GPR08: c0360000 00000000 0014484b df213d70 a90fa2f9 10075c60 1fffe000 00800000
GPR16: ffffffff 00000000 007fff00 00000000 4801e758 df4151d8 00000003 df212000
GPR24: df1d25b0 20000000 28002842 df4152a8 00000901 00000000 0014384c df213d70
NIP [c00784c0] filemap_fault+0x68/0x43c
LR [c0078864] filemap_fault+0x40c/0x43c
Call Trace:
[df213d70] [c0078864] filemap_fault+0x40c/0x43c (unreliable)
[df213db0] [c0088930] __do_fault+0x70/0x400
[df213e00] [c0088d38] do_linear_fault+0x78/0x90
[df213e30] [c008aa4c] handle_mm_fault+0x100/0x300
[df213e70] [c0014438] do_page_fault+0x2cc/0x44c
[df213f40] [c0012964] handle_page_fault+0xc/0x80
--- Exception: 401 at 0xfecb104
    LR = 0xfecd648
Instruction dump:
82bb0000 4bfa2b1d 83b50040 83d50044 38600001 4bfa2a81 54370024 80170034
70090004 408203ac 315e0fff 7d3d0194 <809a0004> 554ca33e 512ca016 7d2b6670
---[ end trpure-ftpd: no upload script defined, skipping
ace 6421ec44c27aeb2b ]---
done

----------8<----------

This is where 0xc00784c0 points to:

----------8<----------

c0078458 <filemap_fault>:
c0078458:       7c 08 02 a6     mflr    r0
c007845c:       90 01 00 04     stw     r0,4(r1)
c0078460:       4b f9 a9 f1     bl      c0012e50 <_mcount>
c0078464:       94 21 ff c0     stwu    r1,-64(r1)
c0078468:       7c 08 02 a6     mflr    r0
c007846c:       be 81 00 10     stmw    r20,16(r1)
c0078470:       7c 3f 0b 78     mr      r31,r1
c0078474:       7c 79 1b 78     mr      r25,r3
c0078478:       90 01 00 44     stw     r0,68(r1)
c007847c:       7c 9a 23 78     mr      r26,r4
c0078480:       83 83 00 48     lwz     r28,72(r3)
c0078484:       38 60 00 01     li      r3,1
c0078488:       83 7c 00 dc     lwz     r27,220(r28)
c007848c:       3b 1c 00 90     addi    r24,r28,144
c0078490:       82 bb 00 00     lwz     r21,0(r27)
c0078494:       4b fa 2b 1d     bl      c001afb0 <add_preempt_count>
c0078498:       83 b5 00 40     lwz     r29,64(r21)
c007849c:       83 d5 00 44     lwz     r30,68(r21)
c00784a0:       38 60 00 01     li      r3,1
c00784a4:       4b fa 2a 81     bl      c001af24 <sub_preempt_count>
c00784a8:       54 37 00 24     rlwinm  r23,r1,0,0,18
c00784ac:       80 17 00 34     lwz     r0,52(r23)
c00784b0:       70 09 00 04     andi.   r9,r0,4
c00784b4:       40 82 03 ac     bne-    c0078860 <filemap_fault+0x408>
c00784b8:       31 5e 0f ff     addic   r10,r30,4095
c00784bc:       7d 3d 01 94     addze   r9,r29
c00784c0:       80 9a 00 04     lwz     r4,4(r26)
c00784c4:       55 4c a3 3e     rlwinm  r12,r10,20,12,31
c00784c8:       51 2c a0 16     rlwimi  r12,r9,20,0,11
c00784cc:       7d 2b 66 70     srawi   r11,r9,12
c00784d0:       7f 84 60 40     cmplw   cr7,r4,r12
c00784d4:       40 9c 02 50     bge-    cr7,c0078724 <filemap_fault+0x2cc>
c00784d8:       80 19 00 14     lwz     r0,20(r25)

----------8<----------

rsc
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

