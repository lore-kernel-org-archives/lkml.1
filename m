Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbYBUOWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbYBUOWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 09:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYBUOWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 09:22:43 -0500
Received: from alpha.facton.com ([83.236.152.122]:44315 "EHLO alpha.facton.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399AbYBUOWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 09:22:41 -0500
X-Greylist: delayed 1029 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2008 09:22:41 EST
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: zlib oops with ipcomp in 2.6.24
Date: Thu, 21 Feb 2008 15:05:29 +0100
Message-ID: <3C59DB883F7B0B4D8096010D45ACCD134F210D@exch.facton.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: zlib oops with ipcomp in 2.6.24
Thread-Index: Ach0ks/jNjewxWkwTFaUmTNcUxd1ng==
From: "Beschorner Daniel" <Daniel.Beschorner@facton.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2.6.24 we got reproducible oopses in a special ipsec/ipcomp
configuration.
We suspected a distro compiler problem, but a fresh gcc 4.2.3 doesn't
change anything.

What could I do/help to track the problem down?

The Oops:

invalid opcode: 0000 [1] SMP
CPU 0
Modules linked in:
Pid: 3713, comm: httpd Not tainted 2.6.24 #9
RIP: 0010:[<ffffffff8031ba08>]  [<ffffffff8031ba08>]
deflate_slow+0x158/0x470
RSP: 0018:ffff81007deedab8  EFLAGS: 00010292
RAX: 0000000000000021 RBX: ffffc200000b9000 RCX: ffffffff80573d68
RDX: ffffffff80573d68 RSI: 0000000000000086 RDI: ffffffff80573d60
RBP: 00000000ffffffff R08: 0000000955231a67 R09: ffff81007f8e3878
R10: ffff810002c0f680 R11: 0000000000000001 R12: 0000000000000596
R13: 0000000000000000 R14: 0000000000000005 R15: ffffc20000097000
FS:  00002ae22211a190(0000) GS:ffffffff805a8000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005555555c7c5d CR3: 000000007dd1d000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process httpd (pid: 3713, threadinfo ffff81007deec000, task
ffff81007f88c7e0)
Stack:  ffff81007cf32200 0000000000000005 ffffc200000b9000
ffff81007ef52800
 0000000000000000 ffffffff8031c2cd 0000000000000000 ffff81007cf32200
 ffff81007cf321c0 ffff81007ef5288c 0000000000000596 ffffffff802ff351
Call Trace:
 [<ffffffff8031c2cd>] zlib_deflate+0x10d/0x330
 [<ffffffff802ff351>] deflate_compress+0x91/0xb0
 [<ffffffff80477228>] ipcomp_output+0x98/0x1e0
 [<ffffffff80489f66>] xfrm_output+0x116/0x1e0
 [<ffffffff80482e34>] xfrm4_output_finish2+0x44/0x1e0
 [<ffffffff804830e5>] xfrm4_output+0x55/0x60
 [<ffffffff804459f9>] ip_queue_xmit+0x209/0x450
 [<ffffffff802a1545>] generic_file_splice_read+0x495/0x4e0
 [<ffffffff80456e3f>] tcp_transmit_skb+0x40f/0x7c0
 [<ffffffff80458b67>] __tcp_push_pending_frames+0x167/0x940
 [<ffffffff80459912>] tcp_push_one+0xb2/0x100
 [<ffffffff8044c3b8>] tcp_sendpage+0x718/0x740
 [<ffffffff802a0229>] pipe_to_sendpage+0x59/0x80
 [<ffffffff802a0924>] __splice_from_pipe+0x54/0x240
 [<ffffffff802a01d0>] pipe_to_sendpage+0x0/0x80
 [<ffffffff802a01d0>] pipe_to_sendpage+0x0/0x80
 [<ffffffff802a0c84>] splice_from_pipe+0x64/0x90
 [<ffffffff802a03eb>] direct_splice_actor+0x1b/0x20
 [<ffffffff802a0628>] splice_direct_to_actor+0xb8/0x190
 [<ffffffff802a03d0>] direct_splice_actor+0x0/0x20
 [<ffffffff802a0730>] do_splice_direct+0x30/0x40
 [<ffffffff8027fdec>] do_sendfile+0x17c/0x230
 [<ffffffff8027ff2e>] sys_sendfile64+0x8e/0xb0
 [<ffffffff8020bb3e>] system_call+0x7e/0x83


Code: 0f 0b eb fe 0f 1f 40 00 48 8b 03 48 89 df 44 8b 60 08 e8 51
RIP  [<ffffffff8031ba08>] deflate_slow+0x158/0x470
 RSP <ffff81007deedab8>
---[ end trace b78f0624c782f205 ]---


The output with the patch below (a zlib patch Herbert Xu sent me to find
the problem) right before the oops:

lookahead = -1 strstart = 141
------------[ cut here ]------------
kernel BUG at lib/zlib_deflate/deflate.c:1255!


diff --git a/lib/zlib_deflate/deflate.c b/lib/zlib_deflate/deflate.c
index c3e4a2b..0dfef7f 100644
--- a/lib/zlib_deflate/deflate.c
+++ b/lib/zlib_deflate/deflate.c
@@ -1138,6 +1138,8 @@ static block_state deflate_slow(
     IPos hash_head = NIL;    /* head of hash chain */
     int bflush;              /* set if current block must be flushed */

+    BUG_ON((int)s->lookahead < 0);
+
     /* Process the input block. */
     for (;;) {
         /* Make sure that we always have enough lookahead, except
@@ -1146,7 +1148,14 @@ static block_state deflate_slow(
          * string following the next match.
          */
         if (s->lookahead < MIN_LOOKAHEAD) {
+           int avail = s->strm->avail_in;
+           int oldlook = s->lookahead;
+
             fill_window(s);
+           if (unlikely((int)s->lookahead < 0)) {
+               printk("availin = %d, lookahead = %d new = %d\n", avail,
oldlook, s->lookahead);
+               BUG();
+           }
             if (s->lookahead < MIN_LOOKAHEAD && flush == Z_NO_FLUSH) {
                return need_more;
            }
@@ -1216,6 +1225,10 @@ static block_state deflate_slow(

             if (bflush) FLUSH_BLOCK(s, 0);

+           if (unlikely((int)s->lookahead < 0)) {
+               printk("prev_length = %d, availin = %d, lookahead =
%d\n", s->prev_length, s->strm->avail_in, s->lookahead);
+               BUG();
+           }
         } else if (s->match_available) {
             /* If there was no match at the previous position, output a
              * single literal. If there was a match but the current
match
@@ -1236,6 +1249,11 @@ static block_state deflate_slow(
             s->strstart++;
             s->lookahead--;
         }
+
+       if (unlikely((int)s->lookahead < 0)) {
+           printk("lookahead = %d strstart = %d\n", s->lookahead,
s->strstart);
+           BUG();
+       }
     }
     Assert (flush != Z_NO_FLUSH, "no flush?");
     if (s->match_available) {


Thank you
Daniel
