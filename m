Return-Path: <linux-kernel-owner+w=401wt.eu-S932180AbYBZS1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbYBZS1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 13:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760383AbYBZS06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 13:26:58 -0500
Received: from quasar.osc.edu ([192.148.249.15]:50035 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757889AbYBZS05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 13:26:57 -0500
Date: Tue, 26 Feb 2008 13:26:55 -0500
From: Pete Wyckoff <pw@osc.edu>
To: Roland Dreier <rdreier@cisco.com>
Cc: Olaf Kirch <olaf.kirch@oracle.com>, general@lists.openfabrics.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] (was Re: [ofa-general] fmr pool free_list empty)
Message-ID: <20080226182655.GD7033@osc.edu>
References: <20080225225330.GA3316@osc.edu> <ada1w70zlkf.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada1w70zlkf.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rdreier@cisco.com wrote on Mon, 25 Feb 2008 15:02 -0800:
> Ugh.
[pw wrote:]
>  > Looking at the FMR dirty list unmapping code in
>  > ib_fmr_batch_release(), there is a section that pulls all the dirty
>  > entries onto a list that it will later unmap and put back on the
>  > free list.
> 
>  > But it also plans to unmap all the free entries that have ever been
>  > remapped:
> 
> Yes, this came from a3cd7d90 ("IB/fmr_pool: ib_fmr_pool_flush() should
> flush all dirty FMRs").  That solved a real problem for Olaf, because
> otherwise dirty FMRs with not at the max map count might never get
> invalidated.  It's not exactly an optimization but rather a
> correctness issue, because RDS relies on killing mapping eventually.
> 
> On the other hand, this behavior clearly does lead to the possibility
> of leaving the free list temporarily empty for stupid reasons.
> 
> I don't see a really good way to fix this at the momemnt, need to
> meditate a little.

Adding CCs in case some iser users are not on the openfabrics list.
Original message is here:
http://lists.openfabrics.org/pipermail/general/2008-February/047111.html

This quoted commit is a regression for iSER.  Not sure if it causes
problems for the other FMR user, SRP.  It went in after v2.6.24.
Following this mail are two patches.  One to revert the change, and
one to attempt to do Olaf's patch in such a way that it does not
cause problems for other FMR users.

I haven't tested the patches with RDS.  It apparently isn't in the
tree yet.  In fact, there are no users of ib_flush_fmr_pool() in the
tree, which is the only function affected by the second patch.  But
iSER is working again in my scenario.

As a side note, I don't remember seeing this patch on the
openfabrics mailing list.  Perhaps I missed it.  Sometimes these
sorts of interactions can be spotted if proposed changes get wider
attention.

		-- Pete
