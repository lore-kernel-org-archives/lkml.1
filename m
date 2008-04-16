Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbYDPAFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbYDPAFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 20:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756928AbYDPAEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 20:04:47 -0400
Received: from relay1.sgi.com ([192.48.171.29]:57126 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756667AbYDPAEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 20:04:40 -0400
Date: Tue, 15 Apr 2008 17:04:38 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
In-Reply-To: <20080415232711.GA22679@elte.hu>
Message-ID: <Pine.LNX.4.64.0804151657210.5564@schroedinger.engr.sgi.com>
References: <20080415204025.GA29784@elte.hu>
 <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org>
 <20080415211359.GA1531@elte.hu> <20080415212430.GA5467@elte.hu>
 <Pine.LNX.4.64.0804151437300.3252@schroedinger.engr.sgi.com>
 <20080415215504.GA9066@elte.hu> <Pine.LNX.4.64.0804151455520.4038@schroedinger.engr.sgi.com>
 <20080415221314.GA12094@elte.hu> <Pine.LNX.4.64.0804151517530.4038@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0804151609510.5018@schroedinger.engr.sgi.com>
 <20080415232711.GA22679@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added some printks to the initialization of slub and I see 0x1 double 
words written over global variables that should be zero. The cpu mask to 
track processors that are initialized is screwed up 
(kmem_cach_cpu_free_init_once).

[    0.000999] 0xc0cb320c:  00 00 00 00 01 00 00 00 00 00 00 00 01 00 00 00 ................
[    0.000999] 0xc0cb321c:  00 00 00 00 01 00 00 00 00 00 00 00 01 00 00 00 ................
[    0.000999] 0xc0cb322c:  00 00 00 00 01 00 00 00                 ........

c0cb3010 B mem_section
c0cb3210 b lock.25923
c0cb3214 b shmem_inode_cachep
c0cb3218 b shm_mnt
c0cb321c b slab_state
c0cb3220 b kmem_cach_cpu_free_init_once
c0cb3224 b slub_debug
c0cb3228 b slub_debug_slabs

mem_section is 512 bytes long. Array overrun?

