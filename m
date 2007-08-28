Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbXH1VQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbXH1VQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 17:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbXH1VQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 17:16:24 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:20818 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbXH1VQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 17:16:22 -0400
X-IronPort-AV: i="4.19,318,1183359600"; 
   d="scan'208"; a="208196018:sNHT44271405"
To: Jeff Garzik <jeff@garzik.org>
Cc: Divy Le Ray <divy@chelsio.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.23 RESEND] cxgb3 - Fix dev->priv usage
X-Message-Flag: Warning: May contain useful information
References: <20070823220628.9835.73819.stgit@speedy5>
	<46CFA8E8.90101@garzik.org> <46CFCCDF.9060101@garzik.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 28 Aug 2007 14:16:21 -0700
In-Reply-To: <46CFCCDF.9060101@garzik.org> (Jeff Garzik's message of "Sat, 25 Aug 2007 02:31:59 -0400")
Message-ID: <adahcmjcqca.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Aug 2007 21:16:21.0469 (UTC) FILETIME=[AE8710D0:01C7E9B8]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > I take that back.  Rejected -- it breaks infiniband build.

To be more precise:

    drivers/infiniband/hw/cxgb3/cxio_hal.c: In function 'cxio_rdev_open':
    drivers/infiniband/hw/cxgb3/cxio_hal.c:919: error: implicit declaration of function 'T3CDEV'

it seems the problem is that T3CDEV() has been deleted and been
replaced with the dev2t3cdev() inline function.  However a simple
replacement s/T3CDEV/dev2t3cdev/ in drivers/infiniband/hw/cxgb3
doesn't work because the function has moved from t3cdev.h to
adapter.h; and moving the function back to t3cdev.h doesn't work
because it depends on more structure definitions now.

And at that point I gave up...

 - R.
