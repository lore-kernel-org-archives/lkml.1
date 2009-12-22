Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbZLVMzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbZLVMzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 07:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbZLVMze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 07:55:34 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38844 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZLVMzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 07:55:33 -0500
Date: Tue, 22 Dec 2009 13:55:32 +0100
From: Jan Kara <jack@suse.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Steve Rago <sar@nec-labs.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Trond.Myklebust@netapp.com" <Trond.Myklebust@netapp.com>,
       "jens.axboe" <jens.axboe@oracle.com>,
       Peter Staubach <staubach@redhat.com>
Subject: Re: [PATCH] improve the performance of large sequential write NFS workloads
Message-ID: <20091222125532.GC604@atrey.karlin.mff.cuni.cz>
References: <1261015420.1947.54.camel@serenity> <1261037877.27920.36.camel@laptop> <20091219122033.GA11360@localhost> <1261232747.1947.194.camel@serenity> <20091222122557.GA604@atrey.karlin.mff.cuni.cz> <1261485515.4937.28.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261485515.4937.28.camel@laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2009-12-22 at 13:25 +0100, Jan Kara wrote:
> >   I believe that if we had per-bdi dirty_background_ratio and set it low
> > for NFS's bdi, 
> 
> There's two things there I think:
>  1) bdi_background
>  2) different background ratios per bdi
  Right.

> 1) could be 'trivially' done much like we do bdi_dirty in
> get_dirty_limits().
> 
> 2) I'm not at all convinced we want to go there.
  Yeah. Doing 1) and playing with bdi->min_ratio and bdi->max_ratio should
be the first thing we should try...

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
