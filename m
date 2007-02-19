Return-Path: <linux-kernel-owner+w=401wt.eu-S932288AbXBSOdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbXBSOdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 09:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932291AbXBSOdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 09:33:50 -0500
Received: from thunk.org ([69.25.196.29]:33009 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932294AbXBSOdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 09:33:49 -0500
Date: Mon, 19 Feb 2007 09:33:21 -0500
From: Theodore Tso <tytso@mit.edu>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/44 take 2] [UBI] Unsorted Block Images
Message-ID: <20070219143321.GE25490@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217224952.GB16522@thunk.org> <1171889303.13817.29.camel@sauron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171889303.13817.29.camel@sauron>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 02:48:23PM +0200, Artem Bityutskiy wrote:
> I actually did not mean these patches should be included to a git. We
> have UBI git to pull from for these purposes. I basically manually split
> the UBI sources to make UBI easier to review. I should have added an
> "RFC" tag, apologies.

It made it much, much, MUCH harder to review.  Especially given that
the documentation was separated from the implementation.  As I looked
at the implementation, there was no way to look and what it was
supposed to do without flipping back to a previous e-mail message and
losing my place.  

> This reflects the way of my thinking. I see UBI as a set of units with
> defined interfaces. So I even physically split the interface description
> into files. I still think it is easier to grasp the architecture this
> way.

Speaking as someone who was coming into it cold, it actually made it
far more difficult.  Your units were too small, so that meant the
number of interfaces that were created as a result were huge!  (Around
20 _sets_ of interfaces, all of which had to be comprehended for what
should have been a relatively simple set of functionality!)

And when you create that many interfaces, it adds inertia to changing
the interfaces later on, because it's sometimes not clear how many
users of the interface there really are.  My general rule of thumb is
that if an interface only has one user, then it may be a good idea to
combine it with the user of that interface, and then make the
functions involved be a static, so that it becomes clear the only user
of that functoin is within that one file.  You can take this too far,
and to extremes it doesn't work all that well, but the UBI layer has
gone waaaaaay off the deep end in terms of functional decomposition.

Adding lots of units so you can have formal functional interfaces is
not always the right answer in terms of making code more readable or
maintainable.  And in my humble opinion, UBI is a picture-perfect
demonstration of this.

Regards,

						- Ted
