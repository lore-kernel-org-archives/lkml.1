Return-Path: <linux-kernel-owner+w=401wt.eu-S1761047AbXE2Qq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761047AbXE2Qq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 12:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbXE2Qqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 12:46:48 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:41699 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbXE2Qqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 12:46:47 -0400
Date: Tue, 29 May 2007 18:43:52 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andy Whitcroft <apw@shadowen.org>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker
Message-ID: <20070529164352.GD18437@osiris.boeblingen.de.ibm.com>
References: <9a1288909c10f2935af82ec5cea0c46b@pinky> <p738xb8fjv2.fsf@bingen.suse.de> <20070529115324.GB18437@osiris.boeblingen.de.ibm.com> <20070529131903.GA5024@one.firstfloor.org> <20070529142222.GC18437@osiris.boeblingen.de.ibm.com> <20070529145818.GB5024@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529145818.GB5024@one.firstfloor.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 04:58:18PM +0200, Andi Kleen wrote:
> > So you prefer random data corruption over an emergency stop?
> 
> With an oops you can at least recover the system and actually 
> look at the problem. On a machine with a panic you're just dead
> and the probability of actually being able to do something about the problem
> is much lower. On x86 systems you typically don't even get 
> any message out.

Ok, that's the different approach of analyzing problems. On s390 we
prefer dumps of a crashed system, since that is much easier to
debug than a kernel that just printed some lines and then went on
as if nothing happened. Besides the nice side effects that a BUG()
statement has of course.

> And I'm not convinced drivers are in a good position to decide
> if memory was likely corrupted or not anyways. At least the
> panics I see in driver sources seem to be just random logic
> bugs from someone not familiar with BUG().
> 
> Also they typically don't make much attempt to figure out
> if there might have been data corruption.

I'm talking of a specific problem where we just added a panic to the
zfcp device driver. If that panic ever triggers we know for sure that
memory corruption happened.
So I'm just asking to not say in general that panic() in a device driver
is a bad thing.
 
> If you're really worried about memory corruption in drivers
> you should just use an IOMMU.

IOMMU and s390 don't fit together.

> > That doesn't make much sense to me...
> So you're always setting panic_on_oops? 

On our internal tests, yes. Otherwise it's of course up to the distros.
Btw. the default implementation for BUG() is panic(). See asm-generic/bug.h.
