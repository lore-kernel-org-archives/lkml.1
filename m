Return-Path: <linux-kernel-owner+w=401wt.eu-S1762064AbXFHGLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762064AbXFHGLG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 02:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbXFHGKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 02:10:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54570 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbXFHGKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 02:10:54 -0400
Date: Thu, 7 Jun 2007 23:10:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 001 of 2] Fix read/truncate race.
Message-Id: <20070607231042.97c7b68b.akpm@linux-foundation.org>
In-Reply-To: <18024.50064.799102.305585@notabene.brown>
References: <20070607114043.26967.patches@notabene>
	<1070607014653.27304@suse.de>
	<20070607181820.6b22bb29.akpm@linux-foundation.org>
	<18024.50064.799102.305585@notabene.brown>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007 12:48:48 +1000 Neil Brown <neilb@suse.de> wrote:

> The following patch will remove the extra seqlock except when we
> actually need it and remove the extra arithmetic - but I haven't
> tested it or reviewed it properly.  I can do that if you think it is
> the right direction.

Yes, the optimisation is valid and looks useful.

>  ./mm/filemap.c |   34 ++++++++++++++++++++++++++++------

It didn't apply - your tree seems different from mine.

> +		 *
> +		 * NOTE: This access of inode->i_size is not protected
> +		 *  and if there is a concurrent update on a 32bit machine,
> +		 *  it could return the wrong value.  This could only be a problem
> +		 *  if i_size has actually changed to a smaller value before the
> +		 *  page became uptodate, and at this point it still has a smaller
> +		 *  value, but due to a race while reading, it appears unchanged.
> +		 *  The chances of this happening are so small and the consequence
> +		 *  sufficiently minor, that the cost of the seqlock seems
> +		 *  not to be justified.

please consider incorporating scripts/checkpatch.pl into your patch
preparation toolchain.

