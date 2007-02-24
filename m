Return-Path: <linux-kernel-owner+w=401wt.eu-S933299AbXBXBFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299AbXBXBFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 20:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933302AbXBXBFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 20:05:25 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:9732 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933299AbXBXBFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 20:05:23 -0500
X-AuditID: d80ac287-9ff9dbb000002978-15-45df8f520a93 
Date: Sat, 24 Feb 2007 01:05:27 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Joel Becker <Joel.Becker@oracle.com>
cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mm/mincore: Return EFAULT when passed an invalid address.
In-Reply-To: <20070223231112.GM7920@ca-server1.us.oracle.com>
Message-ID: <Pine.LNX.4.64.0702240052360.9507@blonde.wat.veritas.com>
References: <20070223225847.GL7920@ca-server1.us.oracle.com>
 <20070223231112.GM7920@ca-server1.us.oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 24 Feb 2007 01:05:22.0449 (UTC) FILETIME=[DBF4B810:01C757AF]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Feb 2007, Joel Becker wrote:

>  	The locking fix to sys_mincore in commit
> 2f77d107050abc14bc393b34bdb7b91cf670c250 returns -ENOMEM when given a
> bad userspace address.  It should return -EFAULT.

No, I think you're getting confused by the way Linus uses access_ok
on the address range given with the access_ok on the vector address.

Before and after, an access_ok failure on the output vector address
gives -EFAULT.  Before and after, an invalid address in the range
to be inspected gives -ENOMEM.

Which is consistent with the other m* system calls: -EFAULT if
arguments are inaccessible, -ENOMEM if address range is invalid.

Hugh
