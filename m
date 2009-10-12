Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbZJLF77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbZJLF77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 01:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbZJLF76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 01:59:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35539 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbZJLF76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 01:59:58 -0400
Date: Mon, 12 Oct 2009 07:59:20 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       samba-technical@lists.samba.org
Subject: Re: [rfc][patch] store-free path walking
Message-ID: <20091012055920.GD25882@wotan.suse.de>
References: <20091006064919.GB30316@wotan.suse.de> <20091006101414.GM5216@kernel.dk> <20091006122623.GE30316@wotan.suse.de> <20091006124941.GS5216@kernel.dk> <20091007085849.GN30316@wotan.suse.de> <20091007095657.GB8703@kernel.dk> <20091012035843.GC25882@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012035843.GC25882@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 05:58:43AM +0200, Nick Piggin wrote:
> On Wed, Oct 07, 2009 at 11:56:57AM +0200, Jens Axboe wrote:
> Try changing the 'statvfs' syscall in dbench to 'statfs'.
> glibc has to do some nasty stuff parsing /proc/mounts to
> make statvfs work. On my 2s8c opteron it goes like this:
> clients     vanilla kernel     vfs scale (MB/s)
> 1            476                447
> 2           1092               1128
> 4           2027               2260
> 8           2398               4200
> 
> Single threaded performance isn't as good so I need to look
> at the reasons for that :(. But it's practically linearly
> scalable now. The dropoff at 8 I'd say is probably due to
> the memory controllers running out of steam rather than
> cacheline or lock contention.

Ah, no on a bigger machine it starts slowing down again due
to shared cwd contention, possibly due to creat/unlink type
events. This could be improved by not restarting the entire
path walk when we run into trouble but just trying to proceed
from the last successful element.

Anyway, if you do get a chance to run dbench with this
modification, I would appreciate seeing a profile with clal
traces (my bigger system is ia64 which doesn't do perf yet).

Thanks,
Nick

