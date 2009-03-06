Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbZCFUqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbZCFUqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 15:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbZCFUq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 15:46:26 -0500
Received: from brick.kernel.dk ([93.163.65.50]:46014 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742AbZCFUq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 15:46:26 -0500
Date: Fri, 6 Mar 2009 21:46:23 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       John.Linn@xilinx.com, sr@denx.de
Subject: Re: [PATCH] Fix Xilinx SystemACE driver to handle empty CF slot
Message-ID: <20090306204623.GJ11787@kernel.dk>
References: <20090228204622.29719.55082.stgit@localhost.localdomain> <fa686aa40903060805i489d8676waad08e8263c02fe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa686aa40903060805i489d8676waad08e8263c02fe@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06 2009, Grant Likely wrote:
> Oops, sorry Jens.  I forgot to CC: you on this patch.
> 
> g.
> 
> On Sat, Feb 28, 2009 at 1:46 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> > From: Grant Likely <grant.likely@secretlab.ca>
> >
> > The SystemACE driver does not handle an empty CF slot gracefully.  An
> > empty CF slot ends up hanging the system.  This patch adds a check for
> > the CF state and stops trying to process requests if the slot is empty.

So with patches like this, it's always nice to know what your target is.
Do you want this in .29, or just queued up for .30? It's not always easy
to judge the urgency of such patches :-)

Also, I note that you are using end_request() throughout the driver. We
really want to get away from that, you should be using blk_end_request()
as that will handle full requests and not just segment-by-segment. No
worries for this patch, but you may want to consider that for a future
patch.

-- 
Jens Axboe

