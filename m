Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbZD3Gme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbZD3Gme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 02:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZD3GmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 02:42:23 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:52596 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbZD3GmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 02:42:22 -0400
Message-ID: <49F9484E.1020105@in.ibm.com>
Date: Thu, 30 Apr 2009 12:12:22 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, linuxppc-dev@ozlabs.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: Next April 28: boot failure on PowerPC with SLQB
References: <20090428165343.2e357d7a.sfr@canb.auug.org.au> <49F6E421.401@in.ibm.com> <84144f020904280422s6a9a277fjc4619c904f37e5ca@mail.gmail.com> <20090429113604.GE3398@wotan.suse.de> <49F87FAB.9050408@in.ibm.com> <20090430041146.GB23746@wotan.suse.de> <49F938E4.2030703@in.ibm.com> <20090430060300.GD23746@wotan.suse.de>
In-Reply-To: <20090430060300.GD23746@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Thu, Apr 30, 2009 at 11:06:36AM +0530, Sachin Sant wrote:
>   
> Hmm, OK. Can you post the disassembly of your pidmap_init please?
>   
Here is the information.

Unable to handle kernel paging request for data at address 0x00000010
Faulting instruction address: 0xc0000000007d0404
cpu 0x0: Vector: 300 (Data Access) at [c000000000a23bd0]
    pc: c0000000007d0404: .pidmap_init+0x28/0x88
    lr: c0000000007b0bbc: .start_kernel+0x458/0x51c
    sp: c000000000a23e50
   msr: 8000000000009032
   dar: 10
 dsisr: 40000000
  current = 0xc000000000955fc0
  paca    = 0xc000000000af2400
    pid   = 0, comm = swapper
enter ? for help
[c000000000a23ee0] c0000000007b0bbc .start_kernel+0x458/0x51c
[c000000000a23f90] c0000000000083d8 .start_here_common+0x1c/0x44
0:mon> ls .pidmap_init
.pidmap_init: c0000000007d03dc
0:mon> di c0000000007d03dc
c0000000007d03dc  fbc1fff0      std     r30,-16(r1)
c0000000007d03e0  ebc2b1a8      ld      r30,-20056(r2)
c0000000007d03e4  39200010      li      r9,16
c0000000007d03e8  7c0802a6      mflr    r0
c0000000007d03ec  fba1ffe8      std     r29,-24(r1)
c0000000007d03f0  f8010010      std     r0,16(r1)
c0000000007d03f4  38000001      li      r0,1
c0000000007d03f8  ebbe8008      ld      r29,-32760(r30)
c0000000007d03fc  f821ff71      stdu    r1,-144(r1)
c0000000007d0400  f93d0010      std     r9,16(r29)
c0000000007d0404  7d6048a8      ldarx   r11,0,r9
c0000000007d0408  7d6b0378      or      r11,r11,r0
c0000000007d040c  7d6049ad      stdcx.  r11,0,r9
c0000000007d0410  40c2fff4      bne-    c0000000007d0404        # .pidmap_init+0x28/0x88
c0000000007d0414  381d0008      addi    r0,r29,8
c0000000007d0418  7d200028      lwarx   r9,0,r0
0:mon>
c0000000007d041c  3129ffff      addic   r9,r9,-1
c0000000007d0420  7d20012d      stwcx.  r9,0,r0
c0000000007d0424  40c2fff4      bne-    c0000000007d0418        # .pidmap_init+0x3c/0x88
c0000000007d0428  3cc00004      lis     r6,4
c0000000007d042c  e87e8010      ld      r3,-32752(r30)
c0000000007d0430  38800050      li      r4,80
c0000000007d0434  60c62000      ori     r6,r6,8192
c0000000007d0438  38a00008      li      r5,8
c0000000007d043c  38e00000      li      r7,0
c0000000007d0440  4b9716d9      bl      c000000000141b18        # .kmem_cache_create+0x0/0x2a0
c0000000007d0444  60000000      nop
c0000000007d0448  38210090      addi    r1,r1,144
c0000000007d044c  f87d0098      std     r3,152(r29)
c0000000007d0450  e8010010      ld      r0,16(r1)
c0000000007d0454  eba1ffe8      ld      r29,-24(r1)
c0000000007d0458  7c0803a6      mtlr    r0
0:mon> r
R00 = 0000000000000001   R16 = 00000000014f3150
R01 = c000000000a23e50   R17 = 0000000000000000
R02 = c000000000a17690   R18 = c0000000007f3150
R03 = 000000000000001f   R19 = 0000000002f1fc90
R04 = 0000000000000000   R20 = c0000000007f3168
R05 = ffffffffffffffff   R21 = c000000000725e2f
R06 = 00000000007974d4   R22 = 00000000007bb977
R07 = 800000000c9b2cc0   R23 = 0000000002f1fc90
R08 = 0000000000000000   R24 = 0000000002f1fc90
R09 = 0000000000000010   R25 = c0000000007f3208
R10 = 0000000000000000   R26 = 0000000000d00000
R11 = c00000000095b0f8   R27 = c000000000b73b10
R12 = 0000000028000082   R28 = c0000000007f0458
R13 = c000000000af2400   R29 = c00000000095db00
R14 = c0000000007f3218   R30 = c00000000098d5f0
R15 = c000000000705c32   R31 = 0000000003c90000
pc  = c0000000007d0404 .pidmap_init+0x28/0x88
lr  = c0000000007b0bbc .start_kernel+0x458/0x51c
msr = 8000000000009032   cr  = 28000084
ctr = 0000000000136f8c   xer = 0000000000000010   trap =  300
dar = 0000000000000010   dsisr = 40000000
0:mon> di %pc
c0000000007d0404  7d6048a8      ldarx   r11,0,r9
c0000000007d0408  7d6b0378      or      r11,r11,r0
c0000000007d040c  7d6049ad      stdcx.  r11,0,r9
c0000000007d0410  40c2fff4      bne-    c0000000007d0404        # .pidmap_init+0x28/0x88
c0000000007d0414  381d0008      addi    r0,r29,8
c0000000007d0418  7d200028      lwarx   r9,0,r0
c0000000007d041c  3129ffff      addic   r9,r9,-1
c0000000007d0420  7d20012d      stwcx.  r9,0,r0
c0000000007d0424  40c2fff4      bne-    c0000000007d0418        # .pidmap_init+0x3c/0x88
c0000000007d0428  3cc00004      lis     r6,4
c0000000007d042c  e87e8010      ld      r3,-32752(r30)
c0000000007d0430  38800050      li      r4,80
c0000000007d0434  60c62000      ori     r6,r6,8192
c0000000007d0438  38a00008      li      r5,8
c0000000007d043c  38e00000      li      r7,0
c0000000007d0440  4b9716d9      bl      c000000000141b18        # .kmem_cache_create+0x0/0x2a0
0:mon>

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

