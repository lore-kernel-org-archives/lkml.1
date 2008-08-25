Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbYHYQVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbYHYQVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 12:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbYHYQVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 12:21:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46918 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753408AbYHYQVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 12:21:31 -0400
Date: Mon, 25 Aug 2008 12:21:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <teheo@suse.de>
cc: Greg Kroah-Hartman <gregkh@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] klist: don't iterate over deleted entries
In-Reply-To: <48B2D037.1050403@suse.de>
Message-ID: <Pine.LNX.4.44L0.0808251219360.6639-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2008, Tejun Heo wrote:

> A klist entry is kept on the list till all its current iterations are
> finished; however, a new iteration after deletion also iterates over
> deleted entries as long as their reference count stays above zero.
> This causes problems for cases where there are users which iterate
> over the list while synchronized against list manipulations and
> natuarally expect already deleted entries to not show up during
> iteration.
> 
> This patch implements dead flag which gets set on deletion so that
> iteration can skip already deleted entries.  The dead flag piggy backs
> on the lowest bit of knode->n_klist and only visible to klist
> implementation proper.

This seems like a reasonable sort of thing to do.  I had considered 
something like it in the past, but never bothered because it wasn't 
needed at the time.

Alan Stern

