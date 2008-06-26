Return-Path: <linux-kernel-owner+w=401wt.eu-S1763019AbYFZNLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763019AbYFZNLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761885AbYFZNAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:00:38 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26220 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760664AbYFZNAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:00:37 -0400
Date: Thu, 26 Jun 2008 15:00:34 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org, antonio.lin@alcormicro.com,
       david.vrabel@csr.com
Subject: Re: Scatter-gather list constraints
Message-ID: <20080626130034.GX20851@kernel.dk>
References: <20080626110615U.fujita.tomonori@lab.ntt.co.jp> <20080626143928P.fujita.tomonori@lab.ntt.co.jp> <20080626063559.GJ20851@kernel.dk> <20080626155834I.fujita.tomonori@lab.ntt.co.jp> <20080626123936.GV20851@kernel.dk> <48639180.2090005@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48639180.2090005@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26 2008, Andi Kleen wrote:
> 
> > On the fs side, just setting a hw block size of 1k should fix the
> > problem, since that'd be your minimum transfer size AND alignment there
> > even for O_DIRECT IO.
> 
> XFS used to force 512 byte IOs for its log IO. Not sure
> that was ever fixed. If it was fixed it likely required a disk format
> change (I think s390 ran into a problem like this)

Issuing IO less than the hardware block size is illegal, so if they do
that then they can't be supported on hardware with > 512b block sizes.
Someone has to do the RMW for such an operation and we don't do it in
drivers.

-- 
Jens Axboe

