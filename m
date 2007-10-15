Return-Path: <linux-kernel-owner+w=401wt.eu-S1763634AbXJOPoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763634AbXJOPoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 11:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756321AbXJOPnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 11:43:39 -0400
Received: from pat.uio.no ([129.240.10.15]:54954 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755105AbXJOPnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 11:43:37 -0400
Subject: Re: nfs mmap adventure (was: 2.6.23-mm1)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <1192451324.27435.71.camel@twins>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	 <1192451324.27435.71.camel@twins>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 11:43:18 -0400
Message-Id: <1192462998.7529.3.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.1, required=12.0, autolearn=disabled, AWL=0.122)
X-UiO-Scanned: 97A88463BBC1DFD381963A32CC051FEF0042C1E0
X-UiO-Ratelimit-Test: Ratelimit
X-UiO-SPAM-Test: UIO-RATELIMIT remote_host: 129.240.10.9 spam_score: 1 maxlevel 200 minaction 2 bait 0 mail/h: 1047 total 4502686 max/h 8345 blacklist 0 greylist 0 ratelimit 1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-10-15 at 14:28 +0200, Peter Zijlstra wrote:
> I get funny SIGBUS' like so:
> 
> fault
>   if (->page_mkwrite() < 0)
>     nfs_vm_page_mkwrite()
>       nfs_write_begin()
>         nfs_flush_incompatible()
>           nfs_wb_page()
>             nfs_wb_page_priority()
>               nfs_sync_mapping_wait()
>                 nfs_wait_on_request_locked()
>                   nfs_wait_on_request()
>                     nfs_wait_bit_interruptible()
>                       return -ERESTARTSYS
>     SIGBUS
> 
> trying to figure out what to do about this...

Why? If someone is interrupting the write, then a SIGBUS is pretty much
expected.

  Trond

