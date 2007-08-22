Return-Path: <linux-kernel-owner+w=401wt.eu-S933330AbXHVSyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330AbXHVSyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 14:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932794AbXHVSyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 14:54:31 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42097 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932762AbXHVSya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 14:54:30 -0400
Date: Wed, 22 Aug 2007 11:54:29 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
In-Reply-To: <20070822134656.GB7539@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0708221151380.13813@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0708211614370.6062@schroedinger.engr.sgi.com>
 <20070821233938.GD29691@Krystal> <Pine.LNX.4.64.0708211640430.6225@schroedinger.engr.sgi.com>
 <20070821234702.GE29691@Krystal> <Pine.LNX.4.64.0708211649260.6886@schroedinger.engr.sgi.com>
 <20070822000323.GG29691@Krystal> <p73fy2cz7bs.fsf@bingen.suse.de>
 <20070822003834.GB1400@Krystal> <Pine.LNX.4.64.0708211757360.3118@schroedinger.engr.sgi.com>
 <20070822134532.GA3769@Krystal> <20070822134656.GB7539@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I can confirm Mathieus' measurement now:

Athlon64:

regular NUMA/discontig

1. Kmalloc: Repeatedly allocate then free test
10000 times kmalloc(8) -> 79 cycles kfree -> 92 cycles
10000 times kmalloc(16) -> 79 cycles kfree -> 93 cycles
10000 times kmalloc(32) -> 88 cycles kfree -> 95 cycles
10000 times kmalloc(64) -> 124 cycles kfree -> 132 cycles
10000 times kmalloc(128) -> 157 cycles kfree -> 247 cycles
10000 times kmalloc(256) -> 200 cycles kfree -> 257 cycles
10000 times kmalloc(512) -> 250 cycles kfree -> 277 cycles
10000 times kmalloc(1024) -> 337 cycles kfree -> 314 cycles
10000 times kmalloc(2048) -> 365 cycles kfree -> 330 cycles
10000 times kmalloc(4096) -> 352 cycles kfree -> 240 cycles
10000 times kmalloc(8192) -> 456 cycles kfree -> 340 cycles
10000 times kmalloc(16384) -> 646 cycles kfree -> 471 cycles
2. Kmalloc: alloc/free test
10000 times kmalloc(8)/kfree -> 124 cycles
10000 times kmalloc(16)/kfree -> 124 cycles
10000 times kmalloc(32)/kfree -> 124 cycles
10000 times kmalloc(64)/kfree -> 124 cycles
10000 times kmalloc(128)/kfree -> 124 cycles
10000 times kmalloc(256)/kfree -> 132 cycles
10000 times kmalloc(512)/kfree -> 132 cycles
10000 times kmalloc(1024)/kfree -> 132 cycles
10000 times kmalloc(2048)/kfree -> 132 cycles
10000 times kmalloc(4096)/kfree -> 319 cycles
10000 times kmalloc(8192)/kfree -> 486 cycles
10000 times kmalloc(16384)/kfree -> 539 cycles

cmpxchg_local NUMA/discontig

1. Kmalloc: Repeatedly allocate then free test
10000 times kmalloc(8) -> 55 cycles kfree -> 90 cycles
10000 times kmalloc(16) -> 55 cycles kfree -> 92 cycles
10000 times kmalloc(32) -> 70 cycles kfree -> 91 cycles
10000 times kmalloc(64) -> 100 cycles kfree -> 141 cycles
10000 times kmalloc(128) -> 128 cycles kfree -> 233 cycles
10000 times kmalloc(256) -> 172 cycles kfree -> 251 cycles
10000 times kmalloc(512) -> 225 cycles kfree -> 275 cycles
10000 times kmalloc(1024) -> 325 cycles kfree -> 311 cycles
10000 times kmalloc(2048) -> 346 cycles kfree -> 330 cycles
10000 times kmalloc(4096) -> 351 cycles kfree -> 238 cycles
10000 times kmalloc(8192) -> 450 cycles kfree -> 342 cycles
10000 times kmalloc(16384) -> 630 cycles kfree -> 546 cycles
2. Kmalloc: alloc/free test
10000 times kmalloc(8)/kfree -> 81 cycles
10000 times kmalloc(16)/kfree -> 81 cycles
10000 times kmalloc(32)/kfree -> 81 cycles
10000 times kmalloc(64)/kfree -> 81 cycles
10000 times kmalloc(128)/kfree -> 81 cycles
10000 times kmalloc(256)/kfree -> 91 cycles
10000 times kmalloc(512)/kfree -> 90 cycles
10000 times kmalloc(1024)/kfree -> 91 cycles
10000 times kmalloc(2048)/kfree -> 90 cycles
10000 times kmalloc(4096)/kfree -> 318 cycles
10000 times kmalloc(8192)/kfree -> 483 cycles
10000 times kmalloc(16384)/kfree -> 536 cycles

