Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbYHDFLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbYHDFLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 01:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbYHDFLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 01:11:08 -0400
Received: from jenny.ondioline.org ([66.220.1.122]:47056 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbYHDFLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 01:11:07 -0400
From: Paul Collins <paul@burly.ondioline.org>
To: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linuxppc-dev@ozlabs.org,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
Subject: Re: nfsd, v4: oops in find_acceptable_alias, ppc32 Linux, post-2.6.27-rc1
References: <87tze38vzt.fsf@burly.wgtn.ondioline.org>
	<20080802184554.GB715@fieldses.org>
	<87abfvm4cc.fsf@burly.wgtn.ondioline.org>
	<877iayy4qc.fsf@burly.wgtn.ondioline.org>
	<18581.40960.737792.454035@notabene.brown>
	<87r696l1yo.fsf@burly.wgtn.ondioline.org>
	<18582.32935.501672.689845@notabene.brown>
Date: Mon, 04 Aug 2008 17:11:05 +1200
In-Reply-To: <18582.32935.501672.689845@notabene.brown> (Neil Brown's message
	of "Mon, 4 Aug 2008 14:08:07 +1000")
Message-ID: <87fxpll5zq.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown <neilb@suse.de> writes:

> bctrl appears to be the indirect-function-call opcode.  There are
> three of them one each for
>   ->fh_to_dentry
>   acceptable
>   ->fh_to_parent
>
> 0xa8 is 'acceptable'.
>
> In the first traceback, the crash was a call from very early in 
> find_acceptable_alias,  The first significant thing it does is call
> the 'acceptable' function.
>
> So it seems clear that 'acceptable' is NULL.
> It is equally clear that we never ever set it to NULL in the code.
> The logical conclusion is "compiler error".
> We can confirm (hopefully) by looking at a disassembly of fh_verify.
>
> Maybe because nfsd_acceptable is 'static' and never explicitly called,
> gcc gets confused and optimises it away.  Maybe a disassembly of 
> nfsd_acceptable would be informative ... particularly if it turns out
> to be empty.

Here's the disassembly.

Dump of assembler code for function nfsd_acceptable:
0xc015f450 <nfsd_acceptable+0>:	mflr    r0
0xc015f454 <nfsd_acceptable+4>:	stw     r0,4(r1)
0xc015f458 <nfsd_acceptable+8>:	bl      0xc0013154 <_mcount>
0xc015f45c <nfsd_acceptable+12>:	stwu    r1,-32(r1)
0xc015f460 <nfsd_acceptable+16>:	mflr    r0
0xc015f464 <nfsd_acceptable+20>:	stmw    r28,16(r1)
0xc015f468 <nfsd_acceptable+24>:	mr      r28,r3
0xc015f46c <nfsd_acceptable+28>:	mr      r31,r1
0xc015f470 <nfsd_acceptable+32>:	stw     r0,36(r1)
0xc015f474 <nfsd_acceptable+36>:	li      r30,1
0xc015f478 <nfsd_acceptable+40>:	lwz     r0,24(r3)
0xc015f47c <nfsd_acceptable+44>:	mr      r3,r4
0xc015f480 <nfsd_acceptable+48>:	andi.   r9,r0,1024
0xc015f484 <nfsd_acceptable+52>:	bne-    0xc015f56c <nfsd_acceptable+284>
0xc015f488 <nfsd_acceptable+56>:	cmpwi   cr7,r4,0
0xc015f48c <nfsd_acceptable+60>:	beq-    cr7,0xc015f4b0 <nfsd_acceptable+96>
0xc015f490 <nfsd_acceptable+64>:	lwz     r0,0(r4)
0xc015f494 <nfsd_acceptable+68>:	cntlzw  r0,r0
0xc015f498 <nfsd_acceptable+72>:	rlwinm  r0,r0,27,5,31
0xc015f49c <nfsd_acceptable+76>:	twnei   r0,0
0xc015f4a0 <nfsd_acceptable+80>:	lwarx   r0,0,r4
0xc015f4a4 <nfsd_acceptable+84>:	addic   r0,r0,1
0xc015f4a8 <nfsd_acceptable+88>:	stwcx.  r0,0,r4
0xc015f4ac <nfsd_acceptable+92>:	bne-    0xc015f4a0 <nfsd_acceptable+80>
0xc015f4b0 <nfsd_acceptable+96>:	mr      r29,r3
0xc015f4b4 <nfsd_acceptable+100>:	b       0xc015f508 <nfsd_acceptable+184>
0xc015f4b8 <nfsd_acceptable+104>:	beq-    cr6,0xc015f4dc <nfsd_acceptable+140>
0xc015f4bc <nfsd_acceptable+108>:	lwz     r0,0(r30)
0xc015f4c0 <nfsd_acceptable+112>:	cntlzw  r0,r0
0xc015f4c4 <nfsd_acceptable+116>:	rlwinm  r0,r0,27,5,31
0xc015f4c8 <nfsd_acceptable+120>:	twnei   r0,0
0xc015f4cc <nfsd_acceptable+124>:	lwarx   r0,0,r30
0xc015f4d0 <nfsd_acceptable+128>:	addic   r0,r0,1
0xc015f4d4 <nfsd_acceptable+132>:	stwcx.  r0,0,r30
0xc015f4d8 <nfsd_acceptable+136>:	bne-    0xc015f4cc <nfsd_acceptable+124>
0xc015f4dc <nfsd_acceptable+140>:	lwz     r3,8(r30)
0xc015f4e0 <nfsd_acceptable+144>:	li      r4,1
0xc015f4e4 <nfsd_acceptable+148>:	bl      0xc00b2f50 <inode_permission>
0xc015f4e8 <nfsd_acceptable+152>:	cmpwi   cr7,r3,0
0xc015f4ec <nfsd_acceptable+156>:	mr      r3,r29
0xc015f4f0 <nfsd_acceptable+160>:	bge+    cr7,0xc015f500 <nfsd_acceptable+176>
0xc015f4f4 <nfsd_acceptable+164>:	mr      r3,r30
0xc015f4f8 <nfsd_acceptable+168>:	bl      0xc00befb0 <dput>
0xc015f4fc <nfsd_acceptable+172>:	b       0xc015f524 <nfsd_acceptable+212>
0xc015f500 <nfsd_acceptable+176>:	bl      0xc00befb0 <dput>
0xc015f504 <nfsd_acceptable+180>:	mr      r29,r30
0xc015f508 <nfsd_acceptable+184>:	lwz     r0,32(r28)
0xc015f50c <nfsd_acceptable+188>:	cmpw    cr7,r29,r0
0xc015f510 <nfsd_acceptable+192>:	beq-    cr7,0xc015f524 <nfsd_acceptable+212>
0xc015f514 <nfsd_acceptable+196>:	lwz     r30,20(r29)
0xc015f518 <nfsd_acceptable+200>:	cmpw    cr7,r29,r30
0xc015f51c <nfsd_acceptable+204>:	cmpwi   cr6,r30,0
0xc015f520 <nfsd_acceptable+208>:	bne+    cr7,0xc015f4b8 <nfsd_acceptable+104>
0xc015f524 <nfsd_acceptable+212>:	lwz     r0,32(r28)
0xc015f528 <nfsd_acceptable+216>:	cmpw    cr7,r29,r0
0xc015f52c <nfsd_acceptable+220>:	beq-    cr7,0xc015f554 <nfsd_acceptable+260>
0xc015f530 <nfsd_acceptable+224>:	lis     r9,-16296
0xc015f534 <nfsd_acceptable+228>:	lwz     r0,17792(r9)
0xc015f538 <nfsd_acceptable+232>:	andi.   r9,r0,2
0xc015f53c <nfsd_acceptable+236>:	beq+    0xc015f554 <nfsd_acceptable+260>
0xc015f540 <nfsd_acceptable+240>:	lis     r3,-16309
0xc015f544 <nfsd_acceptable+244>:	lwz     r5,32(r29)
0xc015f548 <nfsd_acceptable+248>:	mr      r4,r29
0xc015f54c <nfsd_acceptable+252>:	addi    r3,r3,7972
0xc015f550 <nfsd_acceptable+256>:	bl      0xc00330d4 <printk>
0xc015f554 <nfsd_acceptable+260>:	lwz     r0,32(r28)
0xc015f558 <nfsd_acceptable+264>:	mr      r3,r29
0xc015f55c <nfsd_acceptable+268>:	xor     r30,r29,r0
0xc015f560 <nfsd_acceptable+272>:	cntlzw  r30,r30
0xc015f564 <nfsd_acceptable+276>:	rlwinm  r30,r30,27,5,31
0xc015f568 <nfsd_acceptable+280>:	bl      0xc00befb0 <dput>
0xc015f56c <nfsd_acceptable+284>:	lwz     r11,0(r1)
0xc015f570 <nfsd_acceptable+288>:	mr      r3,r30
0xc015f574 <nfsd_acceptable+292>:	lwz     r0,4(r11)
0xc015f578 <nfsd_acceptable+296>:	lmw     r28,-16(r11)
0xc015f57c <nfsd_acceptable+300>:	mr      r1,r11
0xc015f580 <nfsd_acceptable+304>:	mtlr    r0
0xc015f584 <nfsd_acceptable+308>:	blr
End of assembler dump.

> Could you try removing the 'static' declaration for nfsd_acceptable
> and recompile?
> Or maybe try a different compiler?

I will give these a try this evening.

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
