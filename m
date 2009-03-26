Return-Path: <linux-kernel-owner+w=401wt.eu-S932522AbZCZTbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522AbZCZTbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 15:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760836AbZCZTap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 15:30:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760769AbZCZTao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 15:30:44 -0400
Date: Thu, 26 Mar 2009 12:20:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: Frans Pop <elendil@planet.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       tytso@mit.edu, jack@suse.cz, alan@lxorguk.ukuu.org.uk,
       arjan@infradead.org, a.p.zijlstra@chello.nl, npiggin@suse.de,
       jens.axboe@oracle.com, drees76@gmail.com, jesper@krogh.cc,
       linux-kernel@vger.kernel.org, oleg@redhat.com, roland@redhat.com
Subject: Re: relatime: update once per day patches (was: ext3 IO latency
 measurements)
Message-Id: <20090326122003.5f6f608c.akpm@linux-foundation.org>
In-Reply-To: <20090326184900.GA8580@srcf.ucam.org>
References: <20090325123744.GK23439@duck.suse.cz>
	<alpine.LFD.2.00.0903260912270.3032@localhost.localdomain>
	<20090326092454.b74e3f96.akpm@linux-foundation.org>
	<200903261812.09153.elendil@planet.nl>
	<20090326104843.46abfaa7.akpm@linux-foundation.org>
	<20090326184900.GA8580@srcf.ucam.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009 18:49:00 +0000 Matthew Garrett <mjg@redhat.com> wrote:

> On Thu, Mar 26, 2009 at 10:48:43AM -0700, Andrew Morton wrote:
> 
> > Oh, the feature itself is desirable.  But the interface isn't.
> > 
> > - It's a magic number.  Maybe someone runs tmpwatch twice per day, or
> >   weekly, or...
> 
> There has to be a default. 24 hours is a sensible one.

"default" implies that it can be altered by some means.

> When did we adopt a mindset that led to code having to satisfy every 
> single user requirement before being accepted, rather than being happy 
> with code that provides an incremental improvement over what exists 
> already?

Shortcomings have been identified.  Weaselly verbiage is not a suitable
way of addressing shortcomings!

Yes, we could (and do) merge things as a halfway step.  But when the
features are visible to userspace we just can't do that - we have to
get the interface right on day one, because interfaces are for ever.

(Bear in mind that kernel-does-X-once-per-day _is_ an interface)

> If there are actually users who want to be able to tune this 
> per filesystem then I'm sure someone (possibly even me) will write code 
> to support them, but right now it just sounds like features for the sake 
> of some sense of aesthetic correctness.

A hard-wired global 24-hours constant is in no way superior to a
per-mount tunable.  If we're going to do this we should do it in the
best way we know, and we certainly should not lock ourselves into the
inferior implementation for all time by exposing it to userspace.
