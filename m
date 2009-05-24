Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbZEXB07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbZEXB07 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 21:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbZEXB0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 21:26:51 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34320 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041AbZEXB0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 21:26:51 -0400
Subject: Re: Possible deadlock in jfs_imap.c?
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Jan Kucera <kucera.jan.cz@gmail.com>
Cc: JFS Discussion <jfs-discussion@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <ef67228d0905230819x633f0cd0t4dd1be639906f9bc@mail.gmail.com>
References: <ef67228d0905230819x633f0cd0t4dd1be639906f9bc@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 23 May 2009 20:26:50 -0500
Message-Id: <1243128410.27493.2.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-23 at 17:19 +0200, Jan Kucera wrote:
> Hi,
> 
> for my master thesis, I've designed static checker for finding deadlocks in C.
> My tool found some possible deadlock in file fs/jfs/jfs_imap.c
> between JFS_IP(ipimap)->commit_mutex and  imap->im_aglock[agno].
> 
> Reason of this problem is probably missed unlocking of
> JFS_IP(ipimap)->commit_mutex in branch starting at line 2564 which
> leaves JFS_IP(ipimap)->commit_mutex locked:
> 
>     in function diNewIAG(..)
>         locking mutex_lock(&JFS_IP(ipimap)->commit_mutex) at line 2540
>         condition at line 2543 is false
>         condition at line 2564 is true
>         goto out: at 2579
>         IAGFREE_UNLOCK(imap); at line 2654
>     return from diNewIAG(..) at line 2656
> 
> Version of kernel is 2.6.28 (maybe this code is in newer versions too).
> Could someone confirm, that this is a real bug? Thank you for your time.

Yes, it looks like a real bug.  As the comment states, it's an unlikely
error path. This would explain how it went undetected this long.  Should
be fixed anyway.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

