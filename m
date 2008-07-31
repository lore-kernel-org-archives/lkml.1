Return-Path: <linux-kernel-owner+w=401wt.eu-S1763427AbYGaDCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763427AbYGaDCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 23:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763204AbYGaDBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 23:01:11 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:55901 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763389AbYGaDBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 23:01:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=D+UKvRuT3G+fYp/mEu+ea2Zd4y/0qs2NZhoWI8y5Ptnm20FVzgLB9vgzbmsj0iI1vE
         LyYZDpDU14Dn+Hol5BIdZmlLaLmBe+chxOgXtLyKdFA61akG+fCkEQwmvVaEZOfyb89H
         REoPeDbiil62QXQM+FqyXF1BR12sb17vNvTxw=
Message-ID: <a8e1da0807302001g647a613bpcca4b4bdc2b27987@mail.gmail.com>
Date: Thu, 31 Jul 2008 11:01:05 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [BUG] wireless : cpu stuck for 61s
Cc: "Johannes Berg" <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <20080730195637.2197a82d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20080729055731.GA3265@darkstar>
	 <1217334724.10489.47.camel@johannes.berg>
	 <20080730020820.8bcc00e2.akpm@linux-foundation.org>
	 <a8e1da0807300302m35a0a7c0q2ff2e0ab92a69239@mail.gmail.com>
	 <20080730031047.54e13e2d.akpm@linux-foundation.org>
	 <a8e1da0807301906j6438e5d8y64105fe8a2e3dffe@mail.gmail.com>
	 <20080730195637.2197a82d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m6V32xIG006467

On Thu, Jul 31, 2008 at 10:56 AM, Andrew Morton<akpm@linux-foundation.org> wrote:> On Thu, 31 Jul 2008 10:06:31 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:>>>>> Ok here it is.>> BTW, I run "klogd -c 7" after boot>> The sysrq output is still missing lots of stuff.  I guess we broke it.>>>>> This time I get a kmalloc poison overwritten:>>>> <fixes wordwrapping, cleans stuff up>
Thanks, sorry for that caused by webmail.
>> =============================================================================> BUG kmalloc-4096: Poison overwritten> ----------------------------------------------------------------------------->> INFO: 0xf6f3a080-0xf6f3a0ef. First byte 0x80 instead of 0x6b> INFO: Allocated in dev_alloc_skb+0x1c/0x30 age=3642 cpu=0 pid=0> INFO: Freed in skb_release_data+0x57/0x80 age=3146 cpu=0 pid=2398> INFO: Slab 0xc1c05440 objects=7 used=3 fp=0xf6f3a060 flags=0x400020c3> INFO: Object 0xf6f3a060 @offset=8288 fp=0xf6f39030>> Bytes b4 0xf6f3a050:  5e 09 00 00 57 c9 05 00 5a 5a 5a 5a 5a 5a 5a 5a ^...WÃ‰..ZZZZZZZZ> Object 0xf6f3a060:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk> Object 0xf6f3a070:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk> Object 0xf6f3a080:  80 00 00 00 ff ff ff ff ff ff 00 17 7b 00 46 40 ....Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿..{.F@> Object 0xf6f3a090:  00 17 7b 00 46 40 30 09 81 21 08 7a 21 00 00 00 ..{.F@0..!.z!...> Object 0xf6f3a0a0:  64 00 21 04 00 07 00 00 00 00 00 00 00 01 08 82 d.!.............> Object 0xf6f3a0b0:  84 8b 0c 12 96 18 24 03 01 01 05 04 00 02 00 00 ......$.........> Object 0xf6f3a0c0:  07 06 43 4e 20 01 0d 14 2a 01 00 32 04 30 48 60 ..CN....*..2.0H`> Object 0xf6f3a0d0:  6c dd 18 00 17 7b 01 04 00 00 00 01 00 00 00 10 lÃ...{..........> Redzone 0xf6f3b060:  bb bb bb bb                                     Â»Â»Â»Â»> Padding 0xf6f3b088:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ> Pid: 0, comm: swapper Tainted: G        W 2.6.26-smp #2> [<c0180f5d>] print_trailer+0xad/0xf0> [<c018103b>] check_bytes_and_report+0x9b/0xc0> [<c018145e>] check_object+0x19e/0x1e0> [<c01821a4>] __slab_alloc+0x454/0x4f0> [<c01834d6>] __kmalloc_track_caller+0xe6/0xf0> [<c03dd1ec>] ? dev_alloc_skb+0x1c/0x30> [<c03dd1ec>] ? dev_alloc_skb+0x1c/0x30> [<c03dce79>] __alloc_skb+0x49/0x100> [<c03dd1ec>] dev_alloc_skb+0x1c/0x30> [<f8a58599>] ath5k_rxbuf_setup+0x39/0x200 [ath5k]> [<f8a5a697>] ath5k_tasklet_rx+0x127/0x5c0 [ath5k]> [<c014969a>] ? print_lock_contention_bug+0x1a/0xe0> [<c012eafc>] tasklet_action+0x4c/0xc0> [<c012e463>] __do_softirq+0x93/0x120> [<c012e547>] do_softirq+0x57/0x60> [<c012ea29>] irq_exit+0x69/0x80> [<c0106b55>] do_IRQ+0x45/0x80> [<c010a5d0>] ? mwait_idle+0x0/0x50> [<c0104752>] common_interrupt+0x2e/0x34> [<c010a5d0>] ? mwait_idle+0x0/0x50> [<c010a609>] ? mwait_idle+0x39/0x50> [<c01026e0>] cpu_idle+0x60/0xd0> [<c043c8ce>] rest_init+0x4e/0x60> =======================> FIX kmalloc-4096: Restoring 0xf6f3a080-0xf6f3a0ef=0x6b>> FIX kmalloc-4096: Marking all objects used> [<c0243b4f>] ? security_file_permission+0xf/0x20> [<c019436f>] sys_select+0x3f/0x190> [<c01878e9>] ? fput+0x19/0x20> [<c0103dbf>] ? restore_nocheck+0x12/0x15> [<c014b06d>] ? trace_hardirqs_on+0xbd/0x140> [<c0103d5e>] syscall_call+0x7/0xb> =======================>> argh, that stuff hurts my brain.  None of the numbers seem to make any> sense for a 4k allocation :( Pekka, do you have time to decrypt this?>> Dave, could you please remind us which net driver was in use here?>>
It's the ath5k
-- Regardsdaveÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
