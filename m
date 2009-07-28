Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZG1Czt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZG1Czt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 22:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbZG1Czs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 22:55:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:53387 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbZG1Czs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 22:55:48 -0400
Subject: Re: [PATCH] mm: Make it easier to catch NULL cache names
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <alpine.LFD.2.01.0907271951390.3186@localhost.localdomain>
References: <1248745735.30993.38.camel@pasglop>
	 <alpine.LFD.2.01.0907271951390.3186@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 12:55:39 +1000
Message-Id: <1248749739.30993.39.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 19:52 -0700, Linus Torvalds wrote:
> 
> On Tue, 28 Jul 2009, Benjamin Herrenschmidt wrote:
> >
> > Right now, if you inadvertently pass NULL to kmem_cache_create() at boot
> > time, it crashes much later after boot somewhere deep inside sysfs which
> > makes it very non obvious to figure out what's going on.
> 
> Please don't do BUG_ON() when there are alternatives.
> 
> In this case, something like
> 
> 	if (WARN_ON(!name))
> 		return NULL;
> 
> would probably have worked too.

Fair enough..  I'll send a new patch.

Cheers,
Ben.


