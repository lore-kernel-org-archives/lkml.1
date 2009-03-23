Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbZCWBrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbZCWBrO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 21:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbZCWBq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 21:46:57 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:48397 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbZCWBq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 21:46:57 -0400
Date: Mon, 23 Mar 2009 01:44:56 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] sysfs: fix some bin_vm_ops errors
In-Reply-To: <1237766914.25062.679.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0903230141370.10796@blonde.anvils>
References: <Pine.LNX.4.64.0903221826520.17976@blonde.anvils>
 <1237766914.25062.679.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Mar 2009, Benjamin Herrenschmidt wrote:
> On Sun, 2009-03-22 at 18:33 +0000, Hugh Dickins wrote:
> > Commit 86c9508eb1c0ce5aa07b5cf1d36b60c54efc3d7a
> > "sysfs: don't block indefinitely for unmapped files" in linux-next
> > crashes the PowerMac G5 when X starts up.  It's caught out by the way
> > powerpc's pci_mmap of legacy_mem uses shmem_zero_setup(), substituting
> > a new vma->vm_file whose private_data no longer points to the bin_buffer
> > (substitution done because some versions of X crash if that mmap fails).
> > 
> > The fix to this is straightforward: the original vm_file is fput() in
> > that case, so this mmap won't block sysfs at all, so just don't switch
> > over to bin_vm_ops if vm_file has changed.
> 
> Looks good, though we should probably also add a comment to your code
> to make it clear why the test is here.

Right, done.

> 
> The fix should probably go into .29...

No, this is just a linux-next or mmotm thing.  (I probably misled
you by quoting the commit id: though helpful, that is confusing.)

Hugh
