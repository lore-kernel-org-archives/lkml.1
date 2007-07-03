Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbXGCFsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbXGCFsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 01:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbXGCFsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 01:48:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:58019 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbXGCFsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 01:48:40 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <200707031454.42078.nigel@nigel.suspend2.net>
References: <20070703042916.GA17240@srcf.ucam.org>
	 <200707031454.42078.nigel@nigel.suspend2.net>
Content-Type: text/plain
Date: Tue, 03 Jul 2007 15:48:26 +1000
Message-Id: <1183441706.10386.73.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Note, though, that this won't help at all when people use the "suspend-to-ram 
> instead of powering down after writing a hibernation image" feature in 
> (uswsusp | tuxonice). Fuse is just a broken idea in the first place, but 
> given that it exists, we still need to find the underlying cause.

No, Fuse is not a broken idea in the first place. It's the freezer that
is a totally broken idea. It has proven many times to be racy by design
and cannot be made right. Ther usermode helper mess is just part of
that, fuse is another example, etc etc ...

So I think Matthew is totally right. In fact, the presence of the
freezer is the main reason why Paulus so far NACKed Johannes attempts at
merging the PPC PM code with the generic code in kernel/power.c

We've been doing fine without it so far and intend to continue to do so.

As for suspend-to-disk, I refer you to the discussions we had in the
past with Linus, where he explains I think quite clearly how wrong the
current implementation of STR is :-)

Thing is, if you're going to do snapshots, you should probably not sync
after you have "frozen" anyway.

Cheers,
Ben.


