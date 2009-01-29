Return-Path: <linux-kernel-owner+w=401wt.eu-S1760556AbZA2W2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760556AbZA2W2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757681AbZA2W2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:28:08 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49669 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbZA2W2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:28:04 -0500
Subject: Re: boot hang: async vs. kexec
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "arjan@infradead.org" <arjan@infradead.org>
In-Reply-To: <49821C68.4000502@oracle.com>
References: <49821C68.4000502@oracle.com>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 16:28:00 -0600
Message-Id: <1233268080.9299.135.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-29 at 13:15 -0800, Randy Dunlap wrote:
> I (try to) do daily build/boot testing.  The newly built kernel
> is booted via kexec.  This was working until sometime between
> 2.6.28 and 2.6.29-rc1, so I bisected it.*
> 
> git bisect blames this commit:
> 
> 96777fe7b042e5a5d0fe5fb861fcd6cd80ef9634 is first bad commit
> commit 96777fe7b042e5a5d0fe5fb861fcd6cd80ef9634
> Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> Date:   Thu Jan 8 09:46:31 2009 -0600
> 
>     async: Don't call async_synchronize_full_special() while holding sb_lock
>     
>     sync_filesystems() shouldn't be calling async_synchronize_full_special
>     while holding a spinlock.  The second while loop in that function is the
>     right place for this anyway.
> 
> 
> The new/kexec-loaded kernel hangs during initcalls.  The last one that
> I can see (via netconsole, might miss a few of the very last lines) is:
> 
> calling  net_ns_init+0x0/0x14d @ 1
> net_namespace: 1008 bytes
> initcall net_ns_init+0x0/0x14d returned 0 after 0 usecs
> 
> 
> 
> Any ideas/suggestions?

I'm not sure about any limitations of git bisect, but it seems unlikely
to me that sync_filesystems() would be getting called this early.  Are
any filesystems even mounted at this point?

Does reverting that commit fix the problem?  (I would be surprised, but
stranger things have happened.)

> Thanks.
> 
> 
> 
> *caveat: This was all done with the "don't use gcc 4.1.[01]
> because it miscompiles __weak" patch reverted.  Could that
> be an issue/problem here?  (I'm using gcc 4.1.1.)

I have no idea.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

