Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbYJQR76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbYJQR76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 13:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbYJQR7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 13:59:50 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:52953 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714AbYJQR7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 13:59:50 -0400
X-IronPort-AV: E=Sophos;i="4.33,432,1220227200"; 
   d="scan'208";a="49362953"
From: Roland Dreier <rdreier@cisco.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>
Subject: Re: [announce] new tree: "fix all build warnings, on all configs"
References: <20081017171139.GA1792@elte.hu>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 17 Oct 2008 10:59:48 -0700
In-Reply-To: <20081017171139.GA1792@elte.hu> (Ingo Molnar's message of "Fri,
	17 Oct 2008 19:11:39 +0200")
Message-ID: <ada3aiv9k6j.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Oct 2008 17:59:49.0117 (UTC) FILETIME=[2594F2D0:01C93082]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > diff --git a/drivers/net/mlx4/mcg.c b/drivers/net/mlx4/mcg.c
 > index c83f88c..d1230a8 100644
 > --- a/drivers/net/mlx4/mcg.c
 > +++ b/drivers/net/mlx4/mcg.c
 > @@ -215,7 +215,7 @@ int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 >  
 >  	if (block_mcast_loopback)
 >  		mgm->qp[members_count++] = cpu_to_be32((qp->qpn & MGM_QPN_MASK) |
 > -						       (1 << MGM_BLCK_LB_BIT));
 > +						       (1U << MGM_BLCK_LB_BIT));

This is fixing a warning caused by a gcc bug
(http://gcc.gnu.org/bugzilla/show_bug.cgi?id=37261) which is fixed
upstream.  The change is rather inoffensive but on the other hand I'm
not sure what our policy for dealing with version-specific warning bugs
in gcc should be.

 - R.
