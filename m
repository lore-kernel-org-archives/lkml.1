Return-Path: <linux-kernel-owner+w=401wt.eu-S1758523AbYGTRuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbYGTRuT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 13:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757858AbYGTRuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 13:50:06 -0400
Received: from relay1.sgi.com ([192.48.171.29]:33322 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757621AbYGTRuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 13:50:05 -0400
Date: Sun, 20 Jul 2008 12:50:04 -0500
From: Russ Anderson <rja@sgi.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH 0/2] Migrate data off physical pages with corrected memory errors (Version 7)
Message-ID: <20080720175004.GB9409@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20080718203514.GD29621@sgi.com> <87prpa88iw.fsf@basil.nowhere.org> <20080719121328.GA20138@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080719121328.GA20138@parisc-linux.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 06:13:28AM -0600, Matthew Wilcox wrote:
> On Sat, Jul 19, 2008 at 12:37:11PM +0200, Andi Kleen wrote:
> > Russ Anderson <rja@sgi.com> writes:
> > 
> > > [PATCH 0/2] Migrate data off physical pages with corrected memory errors (Version 7)
> > 
> > FWIW I discussed this with some hardware people and the general
> > opinion was that it was way too aggressive to disable a page on the
> > first corrected error like this patchkit currently does.  
> 
> I think it's reasonable to take a page out of service on the first error.
> Then a user program needs to be notified of which bit is suspected.
> It can then subject that page to an intense set of tests (I'd start
> by stealing the ones from memtest86+) and if no more errors are found,
> it could return the page to service.

In general I agree with that approach.  One concern is that in the
process of testing the memory the diagnostic may hit an uncorrectable
error.  That is not a problem with Itanium, which is designed to handle
uncorrected/poisoned data going into and out of the processor core, but
can be a system fatal error (requiring a reboot) on other processor types.
Just something to be aware of.

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
