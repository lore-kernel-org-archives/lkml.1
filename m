Return-Path: <linux-kernel-owner+w=401wt.eu-S964930AbXBLOHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964930AbXBLOHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 09:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964932AbXBLOHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 09:07:37 -0500
Received: from cantor.suse.de ([195.135.220.2]:34177 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964930AbXBLOHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 09:07:36 -0500
To: Nadia.Derbey@bull.net
Cc: akpm@osdl.org, randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] AKT - Tunable structure and registration routines
References: <20070130101143.296619000@bull.net>
	<20070130102908.781457000@bull.net>
From: Andi Kleen <ak@suse.de>
Date: 12 Feb 2007 16:07:50 +0100
In-Reply-To: <20070130102908.781457000@bull.net>
Message-ID: <p73y7n3fm7t.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nadia.Derbey@bull.net writes:
> +
> +This feature aims at making the kernel automatically change the tunables
> +values as it sees resources running out.

The only reason we have resource limit is to avoid DOS when one
resource consumes too much memory.  When there is no such danger then
there isn't any reason to have a limit at all and it could be just
eliminated (or set to unlimited by default)

Your feature doesn't address the DOS and without that there isn't
any reason to have limits at all. So what's the point? 

I agree that some of the default limits we have are not very useful
on modern machines. I guess you're trying to address that.

I would suggest the following strategy:

- Review any limits we have and make sure they make sense.

- Figure out if they actually serve a useful purpose 
e.g. what happens when they are exceeded, is there a DOS?. 
If yes can  the DOS be addressed in a better way (e.g. by allowing to shrink
the resource by a shrinker callback).
 
Some of the existing limits are clearly bogus, e.g. the limit
on shared memory.

For others i don't see a good alternative. e.g. if you don't limit
the number of files allocated the only alternative would be to kill
processes when they allocate too many files. Is that really preferable
to a errno? 

- If they serve a useful purpose then check if the default is useful
on a modern machine. Or make them scale with the amount of memory
like many limits already do.

-Andi
