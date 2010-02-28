Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031404Ab0B1GXq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 01:23:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:56828 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016Ab0B1GXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 01:23:45 -0500
Message-ID: <4B8A0DFA.5040902@kernel.org>
Date: Sun, 28 Feb 2010 15:32:26 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#4
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <20100228011123.GC13594@kryten>
In-Reply-To: <20100228011123.GC13594@kryten>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 28 Feb 2010 06:21:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/28/2010 10:11 AM, Anton Blanchard wrote:
> I gave the workqueue patches a spin on PowerPC. I'm particularly interested
> from an OS jitter perspective, and that these patches wont introduce more
> jitter.  It looks like we reach a steady state of worker threads and arent
> continually creating and destroying them which is good. This could be a big
> deal on compute CPUs (CPUs isolated via isol_cpus or cpusets).

Yeap, it should reach a stable state very quickly.

> A few things I've found so far:
> 
> 1. NR_CPUS > 32 causes issues with the workqueue debugfs code:

Heh heh, that's me using roundup_pow_of_two() where I should have used
order_base_2().  Fixed.

> 2. cifs needs to be converted:
> 
> fs/cifs/cifsfs.c: In function ‘exit_cifs’:
> fs/cifs/cifsfs.c:1067: error: ‘system_single_wq’ undeclared (first use in this function)
> fs/cifs/cifsfs.c:1067: error: (Each undeclared identifier is reported only once
> fs/cifs/cifsfs.c:1067: error: for each function it appears in.)

Ah... right, fixed.  Will soon update the git and patch tarball and
post the updated patches.

Thank you.

-- 
tejun
