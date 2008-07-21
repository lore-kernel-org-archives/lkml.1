Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbYGUQZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbYGUQZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 12:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYGUQZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 12:25:11 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:25206 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbYGUQZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:25:09 -0400
X-IronPort-AV: E=Sophos;i="4.31,224,1215388800"; 
   d="scan'208";a="37948307"
From: Roland Dreier <rdreier@cisco.com>
To: Julia Lawall <julia@diku.dk>
Cc: rolandd@cisco.com, sean.hefty@intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, hnguyen@de.ibm.com, raisch@de.ibm.com
Subject: Re: [PATCH 1/7] drivers/infiniband: Release mutex in error handling code
References: <Pine.LNX.4.64.0807210956040.24625@ask.diku.dk>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 21 Jul 2008 09:25:07 -0700
In-Reply-To: <Pine.LNX.4.64.0807210956040.24625@ask.diku.dk> (Julia Lawall's
	message of "Mon, 21 Jul 2008 09:57:04 +0200 (CEST)")
Message-ID: <ada4p6j6w7w.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Jul 2008 16:25:08.0213 (UTC) FILETIME=[5725CA50:01C8EB4E]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > --- a/drivers/infiniband/hw/ehca/ipz_pt_fn.c
 > +++ b/drivers/infiniband/hw/ehca/ipz_pt_fn.c
 > @@ -163,6 +163,7 @@ static int alloc_small_queue_page(struct
 >  
 >  out:
 >  	ehca_err(pd->ib_pd.device, "failed to allocate small queue page");
 > +	mutex_unlock(&pd->lock);
 >  	return 0;
 >  }

Thanks, looks obviously correct.  ehca guys, I will queue this for my
next pull request to Linus; please let me know if you see a problem and
want me to drop it.

 - R.
