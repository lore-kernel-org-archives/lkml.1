Return-Path: <linux-kernel-owner+w=401wt.eu-S1762665AbXKIONY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762665AbXKIONY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 09:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759912AbXKIONQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 09:13:16 -0500
Received: from pat.uio.no ([129.240.10.15]:43465 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759846AbXKIONQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 09:13:16 -0500
Subject: Re: [OOPS] 2.6.23.1 in NFS
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Mark Hindley <mark@hindley.org.uk>
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net
In-Reply-To: <20071109095558.GB29687@hindley.org.uk>
References: <20071109095558.GB29687@hindley.org.uk>
Content-Type: text/plain
Date: Fri, 09 Nov 2007 09:16:14 -0500
Message-Id: <1194617774.7459.30.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.2, required=12.0, autolearn=disabled, AWL=-0.160)
X-UiO-Scanned: 459E35ADF549A6AEA593E9118E09489EBB210E9A
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -1 maxlevel 200 minaction 2 bait 0 mail/h: 480 total 5031450 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-11-09 at 09:55 +0000, Mark Hindley wrote:
> I got this OOPS this morning on a K6. Sorry it is tainted by madwifi.
> ath5k doesn't (yet!) support my card. Box is K6 200, headless, used as
> firewall/router
> 
> It looks like the same codepath as http://lkml.org/lkml/2007/11/6/275
> but my kernel was definitely compiled on a local disk.

You are hitting the BUG_ON() in line 909, whereas Mathieu was hitting
something further up in the same routine.

However I agree that they look suspicious. Both look as if something is
corrupting the rpc_task structure. In your case, a debugging tag that is
only ever touched by the RPC code at the very start and very finish of
the call is being changed, which points at something like a
use-after-free issue.

Hmm... I note that you are both running with the SLUB allocator. Any
chance you can reproduce using SLAB (and with the SLAB debugging
enabled)?

Trond

