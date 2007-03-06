Return-Path: <linux-kernel-owner+w=401wt.eu-S965187AbXCFV1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965187AbXCFV1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 16:27:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965185AbXCFV1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 16:27:12 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:47609 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965164AbXCFV1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 16:27:10 -0500
To: a.p.zijlstra@chello.nl
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, staubach@redhat.com, hugh@veritas.com
In-reply-to: <1173213151.4718.16.camel@lappy> (message from Peter Zijlstra on
	Tue, 06 Mar 2007 21:32:31 +0100)
Subject: Re: [patch 2/8] update ctime and mtime for mmaped write
References: <20070306180443.669036741@szeredi.hu>
	 <20070306180549.312408559@szeredi.hu> <1173213151.4718.16.camel@lappy>
Message-Id: <E1HOh8r-0006Sp-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 06 Mar 2007 22:24:17 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not liking this, its not a constant operation as the name implies.

OK, I'll think of something better.

> And it style is a bit out of line with the rest of rmap.
> 
> The thing it actually does is page_mkclean(), all it doesn't do is
> setting the pte read-only.
> 
> I can understand you wanting to avoid the overhead of the minor faults
> resulting from using page_mkclean(), but I'm not sure its worth it.

It would be nice if the cost of MS_ASYNC wouldn't be too high.  And I
do have the feeling that minor faults are far more expensive than
cleaning the dirty bit in the ptes.

Do you have any numbers?

Thanks,
Miklos
