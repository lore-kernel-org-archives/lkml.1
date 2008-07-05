Return-Path: <linux-kernel-owner+w=401wt.eu-S1752908AbYGEOOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbYGEOOu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 10:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbYGEOOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 10:14:43 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:46260 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750848AbYGEOOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 10:14:43 -0400
Date: Sat, 5 Jul 2008 10:13:35 -0400
From: Theodore Tso <tytso@mit.edu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: PATCH] fix potential latency issues in JBD's journal code
Message-ID: <20080705141335.GB20240@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>, akpm@linux-foundation.org,
	jens.axboe@oracle.com, linux-kernel@vger.kernel.org
References: <20080704192929.2c4dd4ca@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080704192929.2c4dd4ca@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

I will make the corresponding change for ext4.  Is the "Properly
notify block layer of sync writes" going to be pushed to mainline?  I
can't add SWRITE_SYNC to the ext4 tree without growing a dependency to
this patch.

> This patch modifies two key places that submit IO that then immediately will
> get waited on. The JBD code is slightly convoluted, but after some chasing of
> abstraction layers, these instances seem to really be of this pattern.
> There's one case in checkpoint.c which is another candidate, but I've not
> been able to get my head around the code enough to verify that that one
> really is of this pattern as well, so for now I'll leave that one as is.

You mean the ll_rw_block() SWRITE in __flush_patch?  Yep, seems to be
of the same pattern.

						- Ted

