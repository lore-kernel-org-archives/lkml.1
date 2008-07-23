Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbYGWJeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbYGWJeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 05:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbYGWJdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 05:33:53 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:1393 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbYGWJdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 05:33:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=RH/AwJjaZnRKqDfyBQhYnTY+IRNx6eFr3wy7uYAsmSek6mWw2i4vJhTeRH8QsQOQgV
         HeE8BZEnepmgugHxn3UNHChqqsOo0gfpG4YTu4bqzq8tVOgJ6M0juwE5RFY5AQm9NOOy
         vfYD63AZdImHpsap9gstxWr8ppASmCXyAy/gw=
Message-ID: <4886FA7C.8060809@gmail.com>
Date: Wed, 23 Jul 2008 11:31:40 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: WARNING: at arch/x86/mm/pageattr.c:591 __change_page_attr_set_clr
 [mmotm]
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

mmotm 2008-07-15-15-39 while booting:

EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
------------[ cut here ]------------
WARNING: at arch/x86/mm/pageattr.c:591 __change_page_attr_set_clr+0x627/0x990()
CPA: called for zero pte. vaddr = ffff88007d5b0000 cpa->vaddr = ffff88007d5b0000
Modules linked in: arc4 ecb crypto_blkcipher cryptomgr crypto_algapi ath5k 
mac80211 led_class ohci1394 usbhid rtc_cmos hid cfg80211 ieee1394 floppy evdev 
ff_memless [last unloaded: freq_table]
Pid: 2024, comm: acpidump Not tainted 2.6.26-mm1_64 #1

Call Trace:
  [<ffffffff80238d27>] warn_slowpath+0xb7/0xf0
  [<ffffffff80280b00>] ? filemap_fault+0x240/0x440
  [<ffffffff802a8bc5>] ? check_object+0x255/0x260
  [<ffffffff802a8410>] ? init_object+0x50/0x90
  [<ffffffff802a8410>] ? init_object+0x50/0x90
  [<ffffffff802c3b3c>] ? d_free+0x6c/0x80
  [<ffffffff802c50f1>] ? __d_lookup+0xb1/0x150
  [<ffffffff80225517>] __change_page_attr_set_clr+0x627/0x990
  [<ffffffff802b910d>] ? permission+0xbd/0x140
  [<ffffffff802a8bc5>] ? check_object+0x255/0x260
  [<ffffffff802a8410>] ? init_object+0x50/0x90
  [<ffffffff80225922>] change_page_attr_set_clr+0xa2/0x1f0
  [<ffffffff80225c43>] _set_memory_uc+0x13/0x20
  [<ffffffff8022466d>] ioremap_change_attr+0x2d/0x50
  [<ffffffff80226ad6>] phys_mem_access_prot_allowed+0x146/0x1d0
  [<ffffffff8039d975>] mmap_mem+0x35/0xb0
  [<ffffffff802998de>] mmap_region+0x21e/0x5d0
  [<ffffffff80299f24>] do_mmap_pgoff+0x294/0x390
  [<ffffffff80211256>] sys_mmap+0x106/0x130
  [<ffffffff8020c4db>] system_call_after_swapgs+0x7b/0x80

---[ end trace 34f56e4f17f94b6d ]---
acpidump:2024 /dev/mem ioremap_change_attr failed uncached-minus for 
7d5b0000-7d5b1000
