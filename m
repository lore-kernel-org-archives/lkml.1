Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031370Ab0B1BPQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 20:15:16 -0500
Received: from ozlabs.org ([203.10.76.45]:54074 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031049Ab0B1BPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 20:15:14 -0500
Date: Sun, 28 Feb 2010 12:11:23 +1100
From: Anton Blanchard <anton@samba.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#4
Message-ID: <20100228011123.GC13594@kryten>
References: <1267187000-18791-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1267187000-18791-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Tejun,

I gave the workqueue patches a spin on PowerPC. I'm particularly interested
from an OS jitter perspective, and that these patches wont introduce more
jitter.  It looks like we reach a steady state of worker threads and arent
continually creating and destroying them which is good. This could be a big
deal on compute CPUs (CPUs isolated via isol_cpus or cpusets).

A few things I've found so far:

1. NR_CPUS > 32 causes issues with the workqueue debugfs code:

kernel/workqueue.c:3314: warning: left shift count >= width of type
kernel/workqueue.c:3323: warning: left shift count >= width of type
kernel/workqueue.c:3323: warning: integer overflow in expression
kernel/workqueue.c:3324: warning: enumeration values exceed range of largest integer
kernel/workqueue.c: In function ‘wq_debugfs_decode_pos’:
kernel/workqueue.c:3336: warning: right shift count is negative
kernel/workqueue.c:3337: warning: right shift count is negative
kernel/workqueue.c: In function ‘wq_debugfs_next_pos’:
kernel/workqueue.c:3435: warning: left shift count is negative
kernel/workqueue.c:3436: warning: left shift count is negative
kernel/workqueue.c: In function ‘wq_debugfs_start’:
kernel/workqueue.c:3455: warning: left shift count >= width of type

2. cifs needs to be converted:

fs/cifs/cifsfs.c: In function ‘exit_cifs’:
fs/cifs/cifsfs.c:1067: error: ‘system_single_wq’ undeclared (first use in this function)
fs/cifs/cifsfs.c:1067: error: (Each undeclared identifier is reported only once
fs/cifs/cifsfs.c:1067: error: for each function it appears in.)

Anton
