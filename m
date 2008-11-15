Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbYKOPPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbYKOPPS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 10:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbYKOPPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 10:15:04 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:41484 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbYKOPPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 10:15:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:date:user-agent:mime-version:content-disposition:to:subject
         :content-type:content-transfer-encoding:message-id;
        b=wBqJby26+gqCRf1+Bxk/1VjYXLv28S22ktfffSd7Wg/yA88yQmVlYpwoZ+Jy3MJVOc
         It6s+N+hawjkvrUPW0i12E6OZpsSFMK0YShlQObnrc3cTK0PvpTSA9tjIIY8nH16UoJI
         MQU0uVRLER6twhGqKs20eod/yPsXqskVGn2j0=
From: Thomas PEGEOT <thomas.pegeot@gmail.com>
Date: Sat, 15 Nov 2008 16:14:53 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27-rc4; KDE/4.1.3; x86_64; ; )
MIME-Version: 1.0
Content-Disposition: inline
To: linux-kernel@vger.kernel.org
Subject: Some problems with Hauppauge HVR-1100 on 2.6.27
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200811151614.53883.thomas.pegeot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I've having some problems with my Hauppauge HVR-1100 (cx88-based chipset). My 
DVB card works like a charm on 2.6.27-rc4 (full .config : 
http://omploader.org/veGd1) but doesn't work any 
more on newer kernels.

When i try to use my DVB card on 2.6.27.6, i get these errors in dmesg : 
divide error: 0000 [1] PREEMPT                                                                                       
CPU 0                                                                                                                
Modules linked in: nouveau drm w83627hf hwmon_vid sky2 forcedeth i2c_nforce2 
k8temp                                  
Pid: 2678, comm: kdvb-fe-0 Not tainted 2.6.27.6 #1                                                                   
RIP: 0010:[<ffffffff8043f4bf>]  [<ffffffff8043f4bf>] simple_dvb_calc_regs+0x9c/0x227                                 
RSP: 0018:ffff880076a35d30  EFLAGS: 00010246                                                                         
RAX: 00000000217f7080 RBX: ffff880076a35db0 RCX: 0000000000000000                                                    
RDX: 0000000000000000 RSI: ffffffff807e1a00 RDI: ffff88007fbc8810                                                    
RBP: ffff880076a35da0 R08: ffff880076a35d76 R09: 0000000000000000                                                    
R10: 00007fffb8cd9ff8 R11: 0000000000000202 R12: ffff88007f16bba0                                                    
R13: ffff88007f16bba0 R14: ffff88007fbc8c08 R15: ffff88007fbc8810                                                    
FS:  00007f66af02a750(0000) GS:ffffffff80815e80(0000) knlGS:0000000000000000                                         
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b                                                                    
CR2: 00007f66ae30aeb5 CR3: 000000006fa1f000 CR4: 00000000000006e0                                                    
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000                                                    
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400                                                    
Process kdvb-fe-0 (pid: 2678, threadinfo ffff880076a34000, task ffff880066081630)                                    
Stack:  ffffffff8088e9d8 ffff8800768e9678 ffff880076a35d70 ffffffff8022513d                                          
 0000000000000001 ffff8800768e9668 ffffffff807e0b80 00000013fe9c93db                                                 
 8e01880000002320 ffff88007fbc8810 ffff88007f16bba0 0000000000000000                                                 
Call Trace:                                                                                                          
 [<ffffffff8022513d>] ? __dequeue_entity+0x61/0x6a                                                                   
 [<ffffffff8043f861>] simple_dvb_set_params+0x3e/0x9b                                                                
 [<ffffffff80484d92>] cx22702_set_tps+0x28/0x1d0                                                                     
 [<ffffffff8047e88e>] dvb_frontend_swzigzag_autotune+0x190/0x1b7                                                     
 [<ffffffff8047f09e>] dvb_frontend_swzigzag+0x1bc/0x21e                                                              
 [<ffffffff8047f456>] dvb_frontend_thread+0x356/0x43a                                                                
 [<ffffffff8047f100>] ? dvb_frontend_thread+0x0/0x43a                                                                
 [<ffffffff802403b5>] kthread+0x49/0x76                                                                              
 [<ffffffff8020c059>] child_rip+0xa/0x11
 [<ffffffff8024036c>] ? kthread+0x0/0x76
 [<ffffffff8020c04f>] ? child_rip+0x0/0x11


Code: 8b 45 c0 31 d2 44 8b 48 1c 48 8b 05 bc 2d 4b 00 44 89 c9 0f b7 40 0a d1 
e9 03 45 d0 03 0d ba 2d 4b 00 69 c0 24 f4 00 00 8d 04 01 <41> f7 f1 8a 55 d6 
41 89 c4 88 53 04 c1 e8 08 44 88 63 02 88 43
RIP  [<ffffffff8043f4bf>] simple_dvb_calc_regs+0x9c/0x227
 RSP <ffff880076a35d30>
---[ end trace f8338edded65e015 ]---


So i tried another configuration according to the Gentoo Wiki and it still 
fails : 
CONFIG_DVB=y
CONFIG_DVB_CORE=y
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=y
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_DVB_ALL_FRONTENDS=y

So i'm stuck in an "old" 2.6.27-rc4 since i can't get my card working on newer 
kernels.

If you need anything, feel free to ask me. ;)

Thank in advance.


