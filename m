Return-Path: <linux-kernel-owner+w=401wt.eu-S964776AbXBNVoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964776AbXBNVoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 16:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964783AbXBNVoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 16:44:34 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47388 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964776AbXBNVo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 16:44:28 -0500
Date: Wed, 14 Feb 2007 13:44:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: NeilBrown <neilb@suse.de>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org,
       Norman Weathers <norman.r.weathers@conocophillips.com>,
       "Vladimir V \".\" Saveliev" <vs@namesys.com>
Subject: Re: [PATCH] knfsd: Stop NFSD writes from being broken into lots of
 little writes to filesystem.
Message-Id: <20070214134408.431cddcc.akpm@linux-foundation.org>
In-Reply-To: <45D15687.5080505@yahoo.com.au>
References: <20070213170049.3488.patches@notabene>
	<1070213060131.3560@suse.de>
	<45D15687.5080505@yahoo.com.au>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007 17:11:19 +1100
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> NeilBrown wrote:
> > Another nfsd patch for 2.6.21...
> > 
> > ### Comments for Changeset
> > 
> > When NFSD receives a write request, the data is typically in a number
> > of 1448 byte segments and writev is used to collect them together.
> > 
> > Unfortunately, generic_file_buffered_write passes these to the filesystem
> > one at a time, so an e.g. 32K over-write becomes a series of partial-page
> > writes to each page, causing the filesystem to have to pre-read those
> > pages - wasted effort.
> > 
> > generic_file_buffered_write handles one segment of the vector at a
> > time as it has to pre-fault in each segment to avoid deadlocks.  When
> > writing from kernel-space (and nfsd does) this is not an issue, so
> > generic_file_buffered_write does not need to break and iovec from nfsd
> > into little pieces.
> > 
> > This patch avoids the splitting when  get_fs is KERNEL_DS as it is
> > from NFSd.
> > 
> > This issue was introduced by commit 6527c2bdf1f833cc18e8f42bd97973d583e4aa83
> > 
> > Cc: Nick Piggin <nickpiggin@yahoo.com.au>
> 
> FWIW, you can put Acked-by: me there if you'd like.
> 

It's yet another patch we need to revert if/when we get the write()-deadlock
stuff sorted out.  So please add negative-this to that patch series.
