Return-Path: <linux-kernel-owner+w=401wt.eu-S1761530AbZBNXbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761530AbZBNXbp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:31:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbZBNXYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:24:52 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51632 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759997AbZBNXYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:24:50 -0500
Date: Sat, 14 Feb 2009 23:24:48 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hannes Eder <hannes@hanneseder.net>
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 31/43] drivers/net/tokenring: fix sparse warning: cast
	truncates bits from const value
Message-ID: <20090214232448.GR28946@ZenIV.linux.org.uk>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net> <20090214214452.24377.31953.stgit@vmbox.hanneseder.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090214214452.24377.31953.stgit@vmbox.hanneseder.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 10:46:24PM +0100, Hannes Eder wrote:
> Impact: Use '__u16' instead of '__u8', this possibly fixes a bug.
> 
> Fix this sparse warnings:
>   drivers/net/tokenring/smctr.c:4410:52: warning: cast truncates bits from constant value (100 becomes 0)
>   drivers/net/tokenring/smctr.c:4415:52: warning: cast truncates bits from constant value (400 becomes 0)
>   drivers/net/tokenring/smctr.c:4420:52: warning: cast truncates bits from constant value (800 becomes 0)
>   drivers/net/tokenring/smctr.c:4425:52: warning: cast truncates bits from constant value (1000 becomes 0)
>   drivers/net/tokenring/smctr.c:4430:52: warning: cast truncates bits from constant value (2000 becomes 0)
>   drivers/net/tokenring/smctr.c:4435:52: warning: cast truncates bits from constant value (4000 becomes 0)
>   drivers/net/tokenring/smctr.c:4440:52: warning: cast truncates bits from constant value (8000 becomes 0)

Um, no.  Here's a better question: does *anything* use ->current_ring_status
at all?  Answer: no.  Next question: did anything use it in the past?
git log -p drivers/net/tokenging/smctr.c in historical trees shows that
it had always been defined that way and that it had never been used at
all.

So how about removing the damn field completely?  Or asking the driver's
author what the hell had it been about?
