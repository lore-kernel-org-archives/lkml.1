Return-Path: <linux-kernel-owner+w=401wt.eu-S1753180AbXCUX1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbXCUX1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbXCUX1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:27:50 -0400
Received: from smtp.osdl.org ([65.172.181.24]:58443 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbXCUX1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:27:48 -0400
Date: Wed, 21 Mar 2007 16:27:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] Delete obsolete RAW driver feature.
Message-Id: <20070321162717.34edb348.akpm@linux-foundation.org>
In-Reply-To: <20070321231935.GC9092@redhat.com>
References: <Pine.LNX.4.64.0703180754060.6605@CPE00045a9c397f-CM001225dbafb6>
	<p73y7lu5yt6.fsf@bingen.suse.de>
	<20070320165736.GA19781@redhat.com>
	<20070320181442.1ae73295@lxorguk.ukuu.org.uk>
	<20070321151952.02b5612d.akpm@linux-foundation.org>
	<20070321231935.GC9092@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 19:19:35 -0400
Dave Jones <davej@redhat.com> wrote:

> On Wed, Mar 21, 2007 at 03:19:52PM -0700, Andrew Morton wrote:
> 
>  > We've given people years of notice and _some_ applications have converted
>  > over to open("/dev/sda1", O_DIRECT), as they should.
>  > 
>  > Sure, it's a small and simple driver (now), so the cost of maintaining it
>  > is low.
>  > 
>  > But otoh, there's no reason for it to exist, except for userspace
>  > sluggishness.
>  > 
>  > So we can either give up, or we can push on: put a rude printk in there
>  > somewhere and who knows, maybe in five years time we can finally be rid of
>  > the thing.
> 
> We've actually tried to deprecate this twice. First in RHEL4, and more
> recently in RHEL5.  The conversations go something like this..
> 
> Customer: app xyz doesn't work.
> Us: it's using a deprecated API, it needs to be updated to use O_DIRECT
> Customer: vendor says "pay us $$$$$ to go to version N+1"
> 
> Then we find out the customer can't move to N+1 because they have
> some other piece of infrastructure that relies on semantics in the
> old version, and screaming and hairpulling ensues.
> 
> (And this is one of the more promising conversations. Others
>  that have happened with certain db vendors are enough to
>  make the pope curse).
> 
> Adding printk's on open() of it doesn't solve the problem either.
> The people that see them are the customers who run this stuff,
> not the people who have the ability to change the code.
> 
> If it gets dropped from kernel.org, it wouldn't be long before
> it'd find its way back into enterprise vendor kernels.
> Isn't it better that we all at least ship the same thing? [1]
> 

Yes, I realise it's a tough thing to do - large vendors of large databases
aren't the most agile or clueful of organisations.

If it's your assessment that it's just unreasonsable for us to expect that
we'll ever be able to be rid of the thing then ho hum I guess we might as
well give up.

It's a pretty sad situation though.

> 
> [1] Though admittedly the one in RHEL deviates from upstream
> as it contains performance enhancements that were vetoed from
> upstream acceptance due to it being "deprecated".

What enhancements are they?
