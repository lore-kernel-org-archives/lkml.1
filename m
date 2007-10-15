Return-Path: <linux-kernel-owner+w=401wt.eu-S1763565AbXJOM25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763565AbXJOM25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 08:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758237AbXJOM2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 08:28:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34131 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050AbXJOM2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 08:28:47 -0400
Subject: nfs mmap adventure (was: 2.6.23-mm1)
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Trond Myklebust <trond.myklebust@fys.uio.no>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <20071011213126.cf92efb7.akpm@linux-foundation.org>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 14:28:44 +0200
Message-Id: <1192451324.27435.71.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I get funny SIGBUS' like so:

fault
  if (->page_mkwrite() < 0)
    nfs_vm_page_mkwrite()
      nfs_write_begin()
        nfs_flush_incompatible()
          nfs_wb_page()
            nfs_wb_page_priority()
              nfs_sync_mapping_wait()
                nfs_wait_on_request_locked()
                  nfs_wait_on_request()
                    nfs_wait_bit_interruptible()
                      return -ERESTARTSYS
    SIGBUS

trying to figure out what to do about this...

