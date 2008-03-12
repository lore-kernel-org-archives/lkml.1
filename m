Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbYCLSP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbYCLSP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 14:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbYCLSPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 14:15:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029AbYCLSPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 14:15:13 -0400
Date: Wed, 12 Mar 2008 11:15:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc5-mm1 - x86_64 boot problem ?
Message-Id: <20080312111509.301c9d24.akpm@linux-foundation.org>
In-Reply-To: <1205345451.23611.6.camel@dyn9047017100.beaverton.ibm.com>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
	<1205345451.23611.6.camel@dyn9047017100.beaverton.ibm.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008 10:10:50 -0800 Badari Pulavarty <pbadari@gmail.com> wrote:

> On Tue, 2008-03-11 at 01:14 -0700, Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/
> > 
> 
> I am having trouble booting rc5-mm1 on my x86_64. (ppc64 boots & works
> fine). Seems to be a networking issues (hangs on boot). Here are the 
> messages on the console (not really useful to me).
> 
> On a good kernel (rc5), the next set of messages would be ..
> 
> IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
> TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
> TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> TCP: Hash tables configured (established 524288 bind 65536)
> TCP reno registered
> Total HugeTLB memory allocated, 0
> VFS: Disk quotas dquot_6.5.1
> Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> msgmni has been set to 13864 for ipc namespace ffffffff806903a0
> ..
> 
> Sorry for not being really useful here. But would like to
> know if its a known issue ?

No, it's not known (to me).

> Or should I start bisecting ?

Would be good, please.

I guess here:

#
# ipc
#
ipc-use-ipc_buildid-directly-from-ipc_addid.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
#
ipc-scale-msgmni-to-the-amount-of-lowmem.patch
ipc-scale-msgmni-to-the-number-of-ipc-namespaces.patch
ipc-define-the-slab_memory_callback-priority-as-a-constant.patch
ipc-recompute-msgmni-on-memory-add--remove.patch
ipc-invoke-the-ipcns-notifier-chain-as-a-work-item.patch
ipc-recompute-msgmni-on-ipc-namespace-creation-removal.patch
ipc-do-not-recompute-msgmni-anymore-if-explicitly-set-by-user.patch
ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative.patch
#
ipc-semaphores-code-factorisation.patch
ipc-shared-memory-introduce-shmctl_down.patch
ipc-message-queues-introduce-msgctl_down.patch
ipc-semaphores-move-the-rwmutex-handling-inside-semctl_down.patch
ipc-semaphores-remove-one-unused-parameter-from-semctl_down.patch
ipc-get-rid-of-the-use-_setbuf-structure.patch
ipc-introduce-ipc_update_perm.patch
ipc-consolidate-all-xxxctl_down-functions.patch
ipc-consolidate-all-xxxctl_down-functions-fix.patch

would be the place to start looking.
