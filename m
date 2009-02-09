Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbZBIVhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbZBIVhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbZBIVhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:37:05 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:36700 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbZBIVhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:37:04 -0500
Subject: Re: Build failure with latest -git: btrfs on ppc64
From: Chris Mason <chris.mason@oracle.com>
To: Chuck Ebbert <cebbert@redhat.com>, Kyle McMartin <kyle@infradead.org>,
       jeffm@suse.de, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090207155039.3b6a7429@dhcp-100-2-144.bos.redhat.com>
References: <20090207155039.3b6a7429@dhcp-100-2-144.bos.redhat.com>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 16:36:11 -0500
Message-Id: <1234215371.17365.16.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4990A1CF.01A1:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-07 at 15:50 -0500, Chuck Ebbert wrote:
> fs/btrfs/locking.c: In function 'btrfs_path_lock_waiting':
> fs/btrfs/locking.c:254: error: implicit declaration of function '__raw_spin_is_contended'
> 
> Looks like spin_is_contended() is only available on mips and x86??

Btrfs was using spin_is_contended to decide if it should drop locks
before doing an expensive operation during the core btree search.  After
a few latency tests here, I think it makes more sense to always drop
them instead.

Linus, if you pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git

You'll get the build fix for btrfs on arches without ticket spinlocks 

 fs/btrfs/ctree.c   |    3 +--
 fs/btrfs/locking.c |   22 ----------------------
 fs/btrfs/locking.h |    2 --
 3 files changed, 1 insertion(+), 26 deletions(-)

-chris


