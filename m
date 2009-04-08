Return-Path: <linux-kernel-owner+w=401wt.eu-S1765355AbZDHNDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765355AbZDHNDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932380AbZDHNDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:03:11 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:48144 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326AbZDHNDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:03:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=ROAYqM20JdMfbkXkTYMcDMJXFVq2PPg6OgP68KK2c48mMg5uXcwTrDDgD6ajvce2CP
         EHlBjwapRElqeMbdJaK1Ti/6R3bN5uZSk0zL18PNAakdmq+zQMJTfyc83wme3UQYF2bH
         Y3+zOF2M2ZuUpMxTmHFJjUD0uyPNAeiMWkPXo=
MIME-Version: 1.0
Date: Wed, 8 Apr 2009 17:03:04 +0400
Message-ID: <a4423d670904080603w50face2fl87cd16bd7967cb5d@mail.gmail.com>
Subject: 2.6.30-rc1: parisc: system hangs on boot at __schedule()
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-parisc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Machine is HP j6000.
CPU(s): 2 x PA8700 (PCX-W2) at 750.000000 MHz

gcc version 4.3.3 (Gentoo 4.3.3-r2 p1.1, pie-10.1.5)


Machine hangs before starting rc scripts, but SysRq and C-A-Del work.

All tasks are at __schedule+0x268/0x7bc:


__schedule is at 0x278 in sched.o
plus 268 it is 0x4e0

     454:       2b 60 00 00     addil L%0,dp,r1
                        454: R_PARISC_DPREL21L  rt_sched_class
     458:       34 24 00 00     ldo 0(r1),r4
                        458: R_PARISC_DPREL14R  rt_sched_class
     45c:       48 96 00 28     ldw 14(r4),r22
     460:       08 05 02 5a     copy r5,r26
     464:       e6 c0 20 00     be,l 0(sr4,r22),sr0,r31
     468:       08 1f 02 42     copy r31,rp
     46c:       cb 3c 3f d7     movb,=,n ret0,r25,45c <__schedule+0x1e4>
     470:       0c 80 10 84     ldw 0(r4),r4
     474:       80 d9 28 da     cmpb,=,n r25,r6,8e8 <__schedule+0x670>
     478:       68 b9 08 08     stw r25,404(r5)
     47c:       48 bc 00 70     ldw 38(r5),ret0
     480:       48 bd 00 78     ldw 3c(r5),ret1
     484:       b7 bd 00 02     addi 1,ret1,ret1
     488:       08 1c 07 1c     add,c ret0,r0,ret0
     48c:       68 bc 00 70     stw ret0,38(r5)
     490:       68 bd 00 78     stw ret1,3c(r5)
     494:       0d a0 10 93     ldw 0(r13),r19
     498:       36 73 00 02     ldo 1(r19),r19
     49c:       0d b3 12 80     stw r19,0(r13)
     4a0:       4b 34 01 b0     ldw d8(r25),r20
     4a4:       86 80 22 c8     cmpib,= 0,r20,610 <__schedule+0x398>
     4a8:       48 d5 01 b8     ldw dc(r6),r21
     4ac:       82 95 20 3a     cmpb,=,n r21,r20,4d0 <__schedule+0x258>
     4b0:       4a 9c 00 48     ldw 24(r20),ret0
     4b4:       22 60 0e 01     ldil L%-10000000,r19
     4b8:       0a 7c 0a 3c     add,l ret0,r19,ret0
     4bc:       03 3c 18 40     mtctl ret0,tr1
     4c0:       4a 93 02 d0     ldw 168(r20),r19
     4c4:       00 13 d8 20     mtsp r19,sr3
     4c8:       d6 73 08 21     depw,z r19,30,31,r19
     4cc:       01 13 18 40     mtctl r19,pidr1
     4d0:       48 dc 01 b0     ldw d8(r6),ret0
     4d4:       87 80 22 52     cmpib,=,n 0,ret0,604 <__schedule+0x38c>
     4d8:       e8 00 a0 00     b,l 4e0 <__schedule+0x268>,rp
                        4d8: R_PARISC_PCREL22F  _switch_to
     4dc:       08 06 02 5a     copy r6,r26
     4e0:       08 11 02 44     copy r17,r4
     4e4:       03 c0 08 b3     mfctl tr6,r19
     4e8:       4a 74 00 20     ldw 10(r19),r20
     4ec:       08 1c 02 59     copy ret0,r25
     4f0:       0e 54 20 9a     ldw,s r20(r18),r26
     4f4:       e8 00 a0 00     b,l 4fc <__schedule+0x284>,rp
                        4f4: R_PARISC_PCREL22F  finish_task_switch
     4f8:       0b 44 0a 3a     add,l r4,r26,r26
     4fc:       03 c0 08 bc     mfctl tr6,ret0
     500:       4b 8a 00 20     ldw 10(ret0),r10
     504:       0e 4a 20 93     ldw,s r10(r18),r19
     508:       0a 64 0a 25     add,l r4,r19,r5
     50c:       03 c0 08 bc     mfctl tr6,ret0
     510:       0f 80 10 93     ldw 0(ret0),r19
     514:       4a 74 00 28     ldw 14(r19),r20
     518:       8e 80 60 20     cmpib,> 0,r20,530 <__schedule+0x2b8>
     51c:       48 62 3f d9     ldw -14(r3),rp
     520:       e8 00 a0 00     b,l 528 <__schedule+0x2b0>,rp
                        520: R_PARISC_PCREL22F  __reacquire_kernel_lock
