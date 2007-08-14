Return-Path: <linux-kernel-owner+w=401wt.eu-S932454AbXHNDZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbXHNDZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 23:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758243AbXHNDZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 23:25:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60193
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752994AbXHNDZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 23:25:28 -0400
Date: Mon, 13 Aug 2007 20:25:28 -0700 (PDT)
Message-Id: <20070813.202528.05603304.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: jens.axboe@oracle.com, npiggin@suse.de, mingo@elte.hu,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: lmbench ctxsw regression with CFS
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070813200038.7fc8a9e6.akpm@linux-foundation.org>
References: <20070806032949.GA16401@wotan.suse.de>
	<20070813123031.GS23758@kernel.dk>
	<20070813200038.7fc8a9e6.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 13 Aug 2007 20:00:38 -0700

> Guys, repeat after me: "context switch is not a fast path".  Take
> that benchmark and set fire to it.

Nothing in this world is so absolute :-)

Regardless of the value of lat_ctx, we should thank it for showing
that something is more expensive now.  And it definitely warrants
figuring out what paths are big cycle eaters now and why.

Not "on IA64 indirect calls are expensive, so that must be it", but
rather doing cycle analysis of the relevant scheduling functions to
figure out what might be wrong.

I'm willing to bet it's something completely trivial and easy
to amend, rather than a fundamental issue.  But somebody has
to _look_ instead of supposing this and that.

