Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580AbXHAUwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbXHAUwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 16:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbXHAUwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 16:52:10 -0400
Received: from uosis.mif.vu.lt ([193.219.42.14]:1427 "EHLO uosis.mif.vu.lt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbXHAUwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 16:52:09 -0400
Date: Wed, 1 Aug 2007 23:52:05 +0300
From: Rokas Masiulis <roma1390@uosis.mif.vu.lt>
To: linux-kernel@vger.kernel.org
Subject: Re: Examine user space locks
Message-ID: <20070801205205.GA34272@uosis.mif.vu.lt>
References: <20070801190754.GA31656@uosis.mif.vu.lt> <Pine.LNX.4.64.0708012150420.23692@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708012150420.23692@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.2i
Organization: VU MIF
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 09:51:06PM +0200, Jan Engelhardt wrote:
> On Aug 1 2007 22:07, Rokas Masiulis wrote:
> >sometimes user space program hangs forever.
> >In old days i remeber there was unkillable dosemu.
> >May be there are good how to. Some one can point to it?
> >
> >This is problem/solution isn't related to current kernel. This
> >is question: what to do in this sitaution. 
> 
> echo t >/proc/sysrq-trigger

 # cat /proc/kmsg > log &
 [1] 28058
 # echo t >/proc/sysrq-trigger
 # sleep 3
 # fg
 cat /proc/kmsg > log
 ^C

it seems that i can't get full log. Not all proceses are listed on it.

But some of "bad proceses i have".
(full log: http://89.190.108.145/~rokas/tasks.txt)

it seems that some are stoped on cdrom_transfer_packet_command, some on __mutex_lock_slowpath.
I'm confused..

 hald-addon-st D 000004E2     0  5826      1         17981 12866 (NOTLB)
        f55ebc34 c02c9717 c02c94b8 000004e2 c0529780 00000000 00200202 c0529a64 
        00000000 c0529780 c02c9656 00000080 c2a17b20 00000000 b25fc600 003d0c2e 
        c042e340 f54d1a70 f54d1b78 f55ea000 f55ebca8 f55ebc54 f55ebc8c c03bdb8a 
 Call Trace:
  <c02c9717> cdrom_transfer_packet_command+0x80/0xf9  <c02c94b8> cdrom_timer_expiry+0x0/0x5d
  <c02c9656> cdrom_start_packet_command+0x141/0x182  <c03bdb8a> wait_for_completion+0x85/0xca
...
  <c016051e> do_sys_open+0x4a/0xca  <c01605ba> sys_open+0x1c/0x20
  <c0102b67> sysenter_past_esp+0x54/0x75 
 eject         D 00000101     0 12662      1         12793 17981 (NOTLB)
        e5c17e9c c0156dfd 00000000 00000101 00000001 00000000 f308eac4 00000000 
        00000003 00000802 f56d5e40 00000003 c2a17b20 00000000 0616c400 003d2850 
        c042e340 eb65e030 eb65e138 f5ad970c f5ad9710 eb65e030 f5ad9718 c03be586 
 Call Trace:
  <c0156dfd> free_pages_and_swap_cache+0x51/0x75  <c03be586> __mutex_lock_slowpath+0x46/0x7f
  <c03be6e0> .text.lock.mutex+0x5/0x14  <c0169041> do_open+0x55/0x382
...
  <c016051e> do_sys_open+0x4a/0xca  <c01605ba> sys_open+0x1c/0x20
  <c0102b67> sysenter_past_esp+0x54/0x75 
 mc            D 000004E2     0 12793      1 12795         12662 (NOTLB)
        d483dd54 c02c9717 c02c94b8 000004e2 c0529780 00000002 00200202 c0529a64 
        00000008 c0529780 c02c9656 00000080 c2a17b20 0006c81c d6cab200 003d289b 
        c042e340 ca35f550 ca35f658 d483c000 d483ddc8 d483dd74 d483ddac c03bdb8a 
 Call Trace:
  <c02c9717> cdrom_transfer_packet_command+0x80/0xf9  <c02c94b8> cdrom_timer_expiry+0x0/0x5d
  <c02c9656> cdrom_start_packet_command+0x141/0x182  <c03bdb8a> wait_for_completion+0x85/0xca
...
  <c0160e4a> vfs_read+0x94/0x16c  <c01611ef> sys_read+0x41/0x6a
  <c0102b67> sysenter_past_esp+0x54/0x75 
 eject         D 00000101     0 12866      1          5826 11794 (NOTLB)
        dd45de9c 00000000 00000000 00000101 00000001 00000000 00000000 00000000 
        00000003 00000802 f7d02b40 00000003 c2a17b20 00000000 61409300 003d28ba 
        c042e340 c876e030 c876e138 f5ad970c f5ad9710 c876e030 f5ad9718 c03be586 
 Call Trace:
  <c03be586> __mutex_lock_slowpath+0x46/0x7f  <c03be6e0> .text.lock.mutex+0x5/0x14
  <c0169041> do_open+0x55/0x382  <c0169405> blkdev_open+0x0/0x5a
...
  <c016051e> do_sys_open+0x4a/0xca  <c01605ba> sys_open+0x1c/0x20
  <c0102bcf> syscall_call+0x7/0xb 
 hald-probe-st D 00000101     0 17981      1         12662  5826 (NOTLB)
        dfa3be9c f5761144 00000000 00000101 00000001 00000000 e5ab03f4 00000000 
        00000004 00008800 00000000 dd243550 c2a1fb20 00000000 22986700 003d64c8 
        dd243550 e4379550 e4379658 f5ad970c f5ad9710 e4379550 f5ad9718 c03be586 
 Call Trace:
  <c03be586> __mutex_lock_slowpath+0x46/0x7f  <c03be6e0> .text.lock.mutex+0x5/0x14
  <c0169041> do_open+0x55/0x382  <c0169405> blkdev_open+0x0/0x5a
...
  <c012926e> do_sigaction+0xf1/0x192  <c016051e> do_sys_open+0x4a/0xca
  <c01605ba> sys_open+0x1c/0x20  <c0102b67> sysenter_past_esp+0x54/0x75


roma1390
