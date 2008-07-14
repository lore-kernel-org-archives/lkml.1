Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbYGSKY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbYGSKY0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 06:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbYGSKXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 06:23:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:51497 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755771AbYGSKXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 06:23:32 -0400
Message-ID: <487B3DA1.7010906@kernel.org>
Date: Mon, 14 Jul 2008 20:50:57 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Greg K-H <greg@kroah.com>
Subject: Re: [PATCH] block: fix block_class iteration locking
References: <487AECD0.5010602@kernel.org> <20080714134228.1079c6f7@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20080714134228.1079c6f7@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Jul 2008 10:21:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> Greg has some patches sitting in his tree that convert those functions
> to use class_{for_each,find}_device() instead - and that looks like the
> clean solution, especially since the class implementation details will
> be moved into a private structure. One worry though...

Yeah, that sounds nice.

> With your patch, you protect against adding/removing devices to/from
> the class between _start and _stop. This wasn't done previously, and
> won't be done with Greg's patches (which leaves in the
> locking/unlocking of block_class_lock). Not sure if I'm missing
> something here...

That's mostly the point of this patch.  It wasn't protected properly
before.  It would be best if there's a safe iterator (maybe use klist?).

Thanks.

-- 
tejun
