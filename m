Return-Path: <linux-kernel-owner+w=401wt.eu-S1766847AbXDSQn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766847AbXDSQn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766867AbXDSQn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:43:28 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766847AbXDSQn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:43:26 -0400
Date: Thu, 19 Apr 2007 09:42:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vladimir V. Saveliev" <vs@namesys.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org, reiserfs-dev@namesys.com, linux-mm@kvack.org
Subject: Re: dio_get_page() lockdep complaints
Message-Id: <20070419094254.2b273d0c.akpm@linux-foundation.org>
In-Reply-To: <200704191857.42001.vs@namesys.com>
References: <20070419073828.GB20928@kernel.dk>
	<20070419080157.GC20928@kernel.dk>
	<20070419012540.bed394e2.akpm@linux-foundation.org>
	<200704191857.42001.vs@namesys.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 18:57:41 +0400 "Vladimir V. Saveliev" <vs@namesys.com> wrote:

> > It's a bit odd that reiserfs is playing with file contents within
> > file_operations.release(): there could be other files open against that
> > inode.  One would expect this sort of thing to be happening in an
> > inode_operation.  But it's been like that for a long time.
> > 
> 
> reiserfs needs to "pack" file tail when last process which opened a file closes it.
> Can you see more suitable place where that could be performed?

No, you're right - I got my ->release() and ->flush() mixed up.

Possibly one could perform this operation on the final iput(), but I suspect the
locking situation there would be even more complex.
