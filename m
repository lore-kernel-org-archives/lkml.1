Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbYJ1QGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbYJ1QGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbYJ1QGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:06:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47604 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbYJ1QGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:06:10 -0400
Date: Tue, 28 Oct 2008 12:03:51 -0400 (EDT)
Message-Id: <20081028.120351.78702656.k-ueda@ct.jp.nec.com>
To: nikanth@gmail.com
Cc: dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com,
       James.Bottomley@hansenpartnership.com, j-nomura@ce.jp.nec.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       knikanth@suse.de, k-ueda@ct.jp.nec.com
Subject: Re: [dm-devel] [PATCH 13/13] dm-mpath: convert to request-based
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <807b3a220810240055g1dfa4deam3f6a90d6c58aac32@mail.gmail.com>
References: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
	<20080912.104727.38325381.k-ueda@ct.jp.nec.com>
	<807b3a220810240055g1dfa4deam3f6a90d6c58aac32@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nikanth,

On Fri, 24 Oct 2008 13:25:33 +0530, "Nikanth K" wrote:
> On Fri, Sep 12, 2008 at 8:17 PM, Kiyoshi Ueda wrote:
> > This patch converts dm-multipath target to request-based from bio-based.
> 
> Can we keep both the bio-based as well as request-based dm-multipath?

Why do you want to keep bio-based dm-multipath?
In the realistic environment, dm-multipath is usually the bottom
of the stacking devices.  So I think existing working configurations
are still possible with request-based dm-multipath.

If we keep both types of multipath targets, maintenance cost would
be doubled and additional user interface might be needed to specify
which type is used.  I can't see any major benefit worth paying
the cost of keeping bio-based dm-multipath.

I know dm developers sometimes use linear/error maps under multipath
just for testing purpose.  If that is your requirement, I can make
request-based targets for linear and error (e.g. named like linear_rq
and error_rq).

Thanks,
Kiyoshi Ueda
