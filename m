Return-Path: <linux-kernel-owner+w=401wt.eu-S935432AbZDIPvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935432AbZDIPvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935403AbZDIPvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:51:14 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:33212 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841AbZDIPvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:51:11 -0400
Message-ID: <49DE1969.1000709@in.ibm.com>
Date: Thu, 09 Apr 2009 21:21:05 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, axboe@kernel.dk
Subject: [CFQ/OOPS]  rb_erase with April 9 next tree
References: <20090409163305.8c7a0371.sfr@canb.auug.org.au>
In-Reply-To: <20090409163305.8c7a0371.sfr@canb.auug.org.au>
Content-Type: multipart/mixed;
 boundary="------------020902050302010207020004"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020902050302010207020004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I had Next 09 booted on a powerpc box and was compiling a kernel.
That's when i ran into this oops.

Unable to handle kernel paging request for data at address 0x00000010.
Faulting instruction address: 0xc0000000002ee1b0...................
0:mon> e
cpu 0x0: Vector: 300 (Data Access) at [c0000000d6cf63c0]
    pc: c0000000002ee1b0: .rb_erase+0x16c/0x3b4
    lr: c0000000002e14d0: .cfq_prio_tree_add+0x58/0x120
    sp: c0000000d6cf6640
   msr: 8000000000009032
   dar: 10
 dsisr: 40000000
  current = 0xc0000000fbdf5880
  paca    = 0xc000000000a92300
   pid   = 1867, comm = ld
0:mon> t
[c0000000d6cf66d0] c0000000002e14d0 .cfq_prio_tree_add+0x58/0x120
[c0000000d6cf6770] c0000000002e16c8 .__cfq_slice_expired+0xc8/0x11c
[c0000000d6cf6800] c0000000002e3920 .cfq_insert_request+0x374/0x3f4
[c0000000d6cf68a0] c0000000002cf448 .elv_insert+0x234/0x348
[c0000000d6cf6940] c0000000002d3348 .__make_request+0x514/0x5b0
[c0000000d6cf6a00] c0000000002d1348 .generic_make_request+0x430/0x4c8
[c0000000d6cf6b30] c0000000002d14dc .submit_bio+0xfc/0x124
[c0000000d6cf6bf0] c000000000156998 .submit_bh+0x14c/0x198
[c0000000d6cf6c80] c00000000015ba78 .block_read_full_page+0x394/0x40c
[c0000000d6cf7180] c000000000163080 .do_mpage_readpage+0x680/0x688
[c0000000d6cf7690] c000000000163200 .mpage_readpages+0x104/0x190
[c0000000d6cf77f0] c0000000001e2aac .ext3_readpages+0x28/0x40
[c0000000d6cf7870] c0000000000ebd20 .__do_page_cache_readahead+0x180/0x278
[c0000000d6cf7960] c0000000000ec16c .ondemand_readahead+0x1ac/0x1d8
[c0000000d6cf7a00] c0000000000e1f28 .generic_file_aio_read+0x260/0x6b0
[c0000000d6cf7b40] c000000000129f74 .do_sync_read+0xcc/0x130
[c0000000d6cf7ce0] c00000000012af44 .vfs_read+0xd0/0x1bc
[c0000000d6cf7d80] c00000000012b138 .SyS_read+0x58/0xa0
[c0000000d6cf7e30] c0000000000084ac syscall_exit+0x0/0x40
--- Exception: c01 (System Call) at 000004000050a854
SP (fffd455e850) is in userspace
0:mon> di %pc
c0000000002ee1b0  e95f0010      ld      r10,16(r31)
c0000000002ee1b4  7faa4000      cmpd    cr7,r10,r8
c0000000002ee1b8  409e00ec      bne     cr7,c0000000002ee2a4    # .rb_erase+0x260/0x3b4
c0000000002ee1bc  e95f0008      ld      r10,8(r31)
c0000000002ee1c0  e80a0000      ld      r0,0(r10)
c0000000002ee1c4  780907e1      clrldi. r9,r0,63
c0000000002ee1c8  40820028      bne     c0000000002ee1f0        # .rb_erase+0x1ac/0x3b4
c0000000002ee1cc  60000001      ori     r0,r0,1
c0000000002ee1d0  7fe3fb78      mr      r3,r31
c0000000002ee1d4  7fa4eb78      mr      r4,r29
c0000000002ee1d8  f80a0000      std     r0,0(r10)
c0000000002ee1dc  e81f0000      ld      r0,0(r31)
c0000000002ee1e0  780007a4      rldicr  r0,r0,0,62
c0000000002ee1e4  f81f0000      std     r0,0(r31)
c0000000002ee1e8  4bfffbfd      bl      c0000000002edde4        # .__rb_rotate_left+0x0/0x7c
c0000000002ee1ec  e95f0008      ld      r10,8(r31)
0:mon> di %ld
invalid register name '%ld'
c0000000002ee1f0  e96a0010      ld      r11,16(r10)
c0000000002ee1f4  2fab0000      cmpdi   cr7,r11,0
c0000000002ee1f8  419e0010      beq     cr7,c0000000002ee208    # .rb_erase+0x1c4/0x3b4
c0000000002ee1fc  e80b0000      ld      r0,0(r11)
c0000000002ee200  780907e1      clrldi. r9,r0,63
c0000000002ee204  4182001c      beq     c0000000002ee220        # .rb_erase+0x1dc/0x3b4
c0000000002ee208  e92a0008      ld      r9,8(r10)
c0000000002ee20c  2fa90000      cmpdi   cr7,r9,0
c0000000002ee210  419e00f4      beq     cr7,c0000000002ee304    # .rb_erase+0x2c0/0x3b4
c0000000002ee214  e8090000      ld      r0,0(r9)
c0000000002ee218  780907e1      clrldi. r9,r0,63
c0000000002ee21c  408200e8      bne     c0000000002ee304        # .rb_erase+0x2c0/0x3b4
c0000000002ee220  e92a0008      ld      r9,8(r10)
c0000000002ee224  2fa90000      cmpdi   cr7,r9,0
c0000000002ee228  419e0010      beq     cr7,c0000000002ee238    # .rb_erase+0x1f4/0x3b4
c0000000002ee22c  e8090000      ld      r0,0(r9)
0:mon>
R00 = c0000000fbc07330   R16 = c0000000006d2c92
R01 = c0000000d6cf6640   R17 = 0000000000000000
R02 = c0000000009986e8   R18 = 0000000000000004
R03 = c0000000f93620b0   R19 = c0000000d6cf6a90
R04 = c0000000fb8af038   R20 = c0000000d6cf6a70
R05 = fffffffffffffff0   R21 = 0000000000800000
R06 = 0000000000000001   R22 = 0000000004334ff2
R07 = c0000000f936a210   R23 = 0000000000800005
R08 = c0000000f936a210   R24 = c0000000fbaf0000
R09 = 0000000000000001   R25 = 0000000000000000
R10 = c0000000fbc09130   R26 = c0000000fbb0e490
R11 = 0000000000000000   R27 = c0000000fb8af000
R12 = c0000000dd7e3800   R28 = c0000000fb8af038
R13 = c000000000a92300   R29 = c0000000fb8af038
R14 = 0000000000010000   R30 = c000000000923360
R15 = 0000000000000001   R31 = 0000000000000000
pc  = c0000000002ee1b0 .rb_erase+0x16c/0x3b4
lr  = c0000000002e14d0 .cfq_prio_tree_add+0x58/0x120
msr = 8000000000009032   cr  = 44004448
ctr = c0000000002e35ac   xer = 0000000000000001   trap =  300
dar = 0000000000000010   dsisr = 40000000

On subsequent reboots, i observed similar oops during bootup.
I have attached the oops message here.

Let me know if i can provide any other information.

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------


--------------020902050302010207020004
Content-Type: text/plain;
 name="oops_message"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="oops_message"

Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=1024 NUMA pSeries
Modules linked in: ipv6(F) fuse(F) loop(F) dm_mod(F) ehea(F)
NIP: c0000000002ee1b0 LR: c0000000002e14d0 CTR: c0000000002e35ac
REGS: c0000000f20d2940 TRAP: 0300   Tainted: GF           (2.6.30-rc1-next-20090409)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 44024448  XER: 00000001
DAR: 0000000000000010, DSISR: 0000000040000000
TASK = c0000000f9346a00[3684] 'sh' THREAD: c0000000f20d0000 CPU: 1
GPR00: c0000000f941f030 c0000000f20d2bc0 c0000000009986e8 c0000000fbe91c50 
GPR04: c0000000fb8af038 fffffffffffffff0 0000000000000001 c0000000f941edb0 
GPR08: c0000000f941edb0 0000000000000001 c0000000fbb3cb50 0000000000000000 
GPR12: c0000000f975ed00 c000000000a92500 c0000000f20d0080 c0000000f20d34c0 
GPR16: c0000000006d2c92 0000000000000000 0000000000000004 c0000000f20d3010 
GPR20: c0000000f20d2ff0 0000000000800000 0000000002c8bc82 0000000000800005 
GPR24: c0000000fbaf0000 0000000000000000 c0000000f98ef010 c0000000fb8af000 
GPR28: c0000000fb8af038 c0000000fb8af038 c000000000923360 0000000000000000 
NIP [c0000000002ee1b0] .rb_erase+0x16c/0x3b4
LR [c0000000002e14d0] .cfq_prio_tree_add+0x58/0x120
Call Trace:
[c0000000f20d2bc0] [c0000000002e1450] .cfq_service_tree_add+0x23c/0x264 (unreliable)
[c0000000f20d2c50] [c0000000002e14d0] .cfq_prio_tree_add+0x58/0x120
[c0000000f20d2cf0] [c0000000002e16c8] .__cfq_slice_expired+0xc8/0x11c
[c0000000f20d2d80] [c0000000002e3920] .cfq_insert_request+0x374/0x3f4
[c0000000f20d2e20] [c0000000002cf448] .elv_insert+0x234/0x348
[c0000000f20d2ec0] [c0000000002d3348] .__make_request+0x514/0x5b0
[c0000000f20d2f80] [c0000000002d1348] .generic_make_request+0x430/0x4c8
[c0000000f20d30b0] [c0000000002d14dc] .submit_bio+0xfc/0x124
[c0000000f20d3170] [c000000000156998] .submit_bh+0x14c/0x198
[c0000000f20d3200] [c000000000158814] .bh_submit_read+0x70/0xd0
[c0000000f20d3290] [c0000000001dbf6c] .read_block_bitmap+0xb8/0x238
[c0000000f20d3330] [c0000000001dc2d4] .ext3_free_blocks_sb+0x178/0x5e4
[c0000000f20d3450] [c0000000001dc780] .ext3_free_blocks+0x40/0xe4
[c0000000f20d34e0] [c0000000001e3e70] .ext3_clear_blocks+0x1d8/0x21c
[c0000000f20d35a0] [c0000000001e3fcc] .ext3_free_data+0x118/0x190
[c0000000f20d3650] [c0000000001e49c0] .ext3_truncate+0x670/0xa80
[c0000000f20d37b0] [c0000000000fda70] .vmtruncate+0xf0/0x134
[c0000000f20d3850] [c0000000001457c0] .inode_setattr+0x44/0x180
[c0000000f20d38f0] [c0000000001e15e8] .ext3_setattr+0x1ec/0x298
[c0000000f20d39a0] [c000000000145afc] .notify_change+0x200/0x3dc
[c0000000f20d3a60] [c00000000012905c] .do_truncate+0x84/0xbc
[c0000000f20d3b40] [c000000000137630] .may_open+0x1fc/0x2f4
[c0000000f20d3be0] [c00000000013a5c4] .do_filp_open+0x400/0x95c
[c0000000f20d3d80] [c000000000127e68] .do_sys_open+0x80/0x140
[c0000000f20d3e30] [c0000000000084ac] syscall_exit+0x0/0x40
Instruction dump:
e8090010 7fa01800 409e000c f9090010 48000010 f9090008 48000008 f91d0000 
2f860001 7cff3b78 409e0238 48000200 <e95f0010> 7faa4000 409e00ec e95f0008 



--------------020902050302010207020004--
