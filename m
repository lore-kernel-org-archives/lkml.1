Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbZEBRzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbZEBRzX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 13:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbZEBRzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 13:55:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752680AbZEBRzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 13:55:06 -0400
Date: Sat, 2 May 2009 10:49:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pavel@ucw.cz, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 3/3] PM/Hibernate: Use memory allocations to free memory
Message-Id: <20090502104947.2720f173.akpm@linux-foundation.org>
In-Reply-To: <200905021346.34967.rjw@sisk.pl>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera>
	<200905020029.39181.rjw@sisk.pl>
	<20090501161423.94b37d5b.akpm@linux-foundation.org>
	<200905021346.34967.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 May 2009 13:46:34 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> > Do we need the bitmap?  I expect we can just string all these pages
> > onto a local list via page.lru.  Would need to check that - the
> > pageframe fields are quite overloaded.
> 
> This is the reason why we use the bitmaps for hibernation. :-)

grep the tree for page->lru and you'll see that quite a few page
consumers are using it.  So you'd be pretty safe doing it this way.

Whether it's _worth_ doing it this way is debatable, given that
hibernation uses bitmaps elsewhere.  But it would shrink the patch a
bit I expect?
