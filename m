Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbYGUJly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbYGUJly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 05:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbYGUJll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 05:41:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59565 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246AbYGUJli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 05:41:38 -0400
Date: Mon, 21 Jul 2008 11:41:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, cl@linux-foundation.org,
       davem@davemloft.net, johnpol@2ka.mipt.ru
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison
	overwritten
Message-ID: <20080721094110.GA16029@elte.hu>
References: <20080717214222.GA29449@elte.hu> <Pine.LNX.4.64.0807181149460.3852@sbz-30.cs.Helsinki.FI> <20080718091146.GQ6875@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080718091146.GQ6875@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


update about this problem: just triggered another colorful crash, see 
below. This was with the 4K object dump patch already, maybe the dump 
gives a clue?

The upstream base of this test kernel was v2.6.26-5253-g14b395e - i.e. 
post the big networking pull, but this problem predates it. (It first 
triggered after v2.6.26)

All the crashes trigger in or close to networking code - not a single 
block IO DMA or other DMA crash happened so far, and no filesystem 
corruptions or anything like that which would signal hw trouble.

	Ingo

------------------>
initcall sctp_init+0x0/0x697 returned 0 after 9 msecs
calling  powernowk8_init+0x0/0x6e
initcall powernowk8_init+0x0/0x6e returned -19 after 0 msecs
calling  hpet_insert_resource+0x0/0x1e
initcall hpet_insert_resource+0x0/0x1e returned 0 after 0 msecs
calling  lapic_insert_resource+0x0/0x44
initcall lapic_insert_resource+0x0/0x44 returned 0 after 0 msecs
calling  init_lapic_nmi_sysfs+0x0/0x33
initcall init_lapic_nmi_sysfs+0x0/0x33 returned 0 after 0 msecs
=============================================================================
BUG skbuff_head_cache: Poison overwritten
-----------------------------------------------------------------------------

INFO: 0xf7ccc100-0xf7ccc103. First byte 0x0 instead of 0x6b
INFO: Allocated in __alloc_skb+0x30/0x10e age=1 cpu=1 pid=1
INFO: Freed in __kfree_skb+0x63/0x66 age=1 cpu=0 pid=0
INFO: Slab 0xc1c34ca0 objects=16 used=1 fp=0xf7ccc100 flags=0x400000c3
INFO: Object 0xf7ccc100 @offset=256 fp=0xf7ccc200

Bytes b4 0xf7ccc0f0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
  Object 0xf7ccc100:  00 00 00 00 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b ....kkkkkkkkkkkk
  Object 0xf7ccc110:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xf7ccc120:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xf7ccc130:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xf7ccc140:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xf7ccc150:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xf7ccc160:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xf7ccc170:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xf7ccc180:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xf7ccc190:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xf7ccc1a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk�
 Redzone 0xf7ccc1b0:  bb bb bb bb                                     ����            
 Padding 0xf7ccc1d8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xf7ccc1e8:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Padding 0xf7ccc1f8:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
Pid: 1, comm: swapper Not tainted 2.6.26-tip #3261
 [<c01673ad>] print_trailer+0xd1/0xd9
 [<c0167428>] check_bytes_and_report+0x73/0x8f
 [<c0167664>] check_object+0xa5/0x15a
 [<c016824c>] __slab_alloc+0x2fb/0x3c8
 [<c0168364>] kmem_cache_alloc+0x4b/0xa8
 [<c0497376>] ? __alloc_skb+0x30/0x10e
 [<c0497376>] ? __alloc_skb+0x30/0x10e
 [<c0497376>] __alloc_skb+0x30/0x10e
 [<c04a6678>] alloc_skb+0xc/0xe
 [<c04a6ce5>] find_skb+0x28/0x66
 [<c04a6f5f>] netpoll_send_udp+0x2b/0x1cf
 [<c058800f>] ? _spin_lock_irqsave+0x4b/0x55
 [<c03db399>] write_msg+0x79/0xac
 [<c03db320>] ? write_msg+0x0/0xac
 [<c0122f96>] __call_console_drivers+0x56/0x63
 [<c0122ffa>] _call_console_drivers+0x57/0x5b
 [<c0123386>] release_console_sem+0x112/0x1a5
 [<c01238f3>] vprintk+0x344/0x35e
