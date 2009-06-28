Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbZF2CrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbZF2CrD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 22:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbZF2Cqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 22:46:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36089 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbZF2Cqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 22:46:52 -0400
Date: Mon, 29 Jun 2009 01:32:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       earl_chew@agilent.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern (v3)
Message-ID: <20090628233200.GA26669@redhat.com>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org> <20090629003514.GC2479@localhost.localdomain> <20090628222455.GA21475@redhat.com> <20090629023621.GA4289@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629023621.GA4289@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28, Neil Horman wrote:
>
> On Mon, Jun 29, 2009 at 12:24:55AM +0200, Oleg Nesterov wrote:
> >
> > Perhaps this sysctl should be added in a separate patch? This patch mixes
> > differents things imho.
> >
> No, I disagree. If we're going to have a sysctl, It should be added in this
> patch.  I agree that since these processes run as root, we can have all sort of
> bad things happen.  But I think theres an advantage to being able to limit the
> damage that a core_pattern process can do if it never exits.

Yes, but why it should be added in this patch?

> > But in fact I don't really understand why do we need the new sysctl. Yes,
> > if the collecting process never exits, the coredumping thread can't be reaped.
> > But this process runs as root, it can do other bad things. And let's suppose
> > it just does nothing, say sleeps forever, and do not read the data from pipe.
> > In that case, regardless of any sysctls, ->core_dump() never finishes too.
> >
> Not always true, in the event that the core file is smaller than the pipe size.

sure,

> But regardless, if ->core_dump never returns due to the aforementioned
> situation, the sysctl provides the ability to mitigate the damange that can do,
> since the dump count is held while ->core_dump is called.

Yes, I misread the sysctl code. Perhaps another reason to split this patch ;)

Oleg.

