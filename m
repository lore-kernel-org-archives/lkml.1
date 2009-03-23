Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbZCWAPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbZCWAPf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 20:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbZCWAP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 20:15:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:60584 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbZCWAPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 20:15:25 -0400
Subject: Re: [PATCH next] sysfs: fix some bin_vm_ops errors
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0903221826520.17976@blonde.anvils>
References: <Pine.LNX.4.64.0903221826520.17976@blonde.anvils>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 11:08:34 +1100
Message-Id: <1237766914.25062.679.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-22 at 18:33 +0000, Hugh Dickins wrote:
> Commit 86c9508eb1c0ce5aa07b5cf1d36b60c54efc3d7a
> "sysfs: don't block indefinitely for unmapped files" in linux-next
> crashes the PowerMac G5 when X starts up.  It's caught out by the way
> powerpc's pci_mmap of legacy_mem uses shmem_zero_setup(), substituting
> a new vma->vm_file whose private_data no longer points to the bin_buffer
> (substitution done because some versions of X crash if that mmap fails).
> 
> The fix to this is straightforward: the original vm_file is fput() in
> that case, so this mmap won't block sysfs at all, so just don't switch
> over to bin_vm_ops if vm_file has changed.

Looks good, though we should probably also add a comment to your code
to make it clear why the test is here.

The fix should probably go into .29...

Cheers,
Ben.


