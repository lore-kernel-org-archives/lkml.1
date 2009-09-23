Return-Path: <linux-kernel-owner+w=401wt.eu-S1752266AbZIWL3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbZIWL3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 07:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbZIWL3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 07:29:43 -0400
Received: from sh.osrg.net ([192.16.179.4]:34275 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbZIWL3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 07:29:43 -0400
Date: Wed, 23 Sep 2009 20:27:51 +0900
To: kyle@moffetthome.net
Cc: fujita.tomonori@lab.ntt.co.jp, lars.ellenberg@linbit.com,
       arjan@infradead.org, lmb@suse.de, jens.axboe@oracle.com, neilb@suse.de,
       hch@infradead.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com,
       akpm@linux-foundation.org, bart.vanassche@gmail.com, davej@redhat.com,
       gregkh@suse.de, kosaki.motohiro@jp.fujitsu.com,
       torvalds@linux-foundation.org, nab@linux-iscsi.org, knikanth@suse.de,
       philipp.reisner@linbit.com, sam@ravnborg.org, Mauelshagen@redhat.com
Subject: Re: [GIT PULL] DRBD for 2.6.32
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <f73f7ab80909211751p4d797556lcce5e47c3241b5ef@mail.gmail.com>
References: <20090921165321.GJ8072@barkeeper1-xen.linbit>
	<20090922072617U.fujita.tomonori@lab.ntt.co.jp>
	<f73f7ab80909211751p4d797556lcce5e47c3241b5ef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090923202646F.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 23 Sep 2009 20:27:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009 20:51:32 -0400
Kyle Moffett <kyle@moffetthome.net> wrote:

> On Mon, Sep 21, 2009 at 18:27, FUJITA Tomonori
> <fujita.tomonori@lab.ntt.co.jp> wrote:
> > On Mon, 21 Sep 2009 18:53:21 +0200 Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
> >> That's not what I meant, of course that is and needs to be stable.
> >> Sorry, I exagerated to make a point.
> >>
> >> Point was:
> >> mdadm configured md.
> >> dmsetup configured dm.
> >> drbdsetup configure drbd.
> >>
> >> If and when "something" is done to "unify" things on the implementation
> >> level, it is likely to also unify the "kernel<->userspace" configuration
> >> interface.
> >>
> >> If it happens, once that happens, that _will_ be an ABI break.
> >
> > You misunderstand the raid unification.
> >
> > We will not unify the kernel<->userspace configuration interface
> > because we can't break the kernel<->userspace ABI.
> >
> > We plan to unify the multiple device frameworks, but the unified
> > framework must support the all existing ABIs.
> >
> > So adding another 'drbd' ABI hurts us.
> 
> One major issue for me personally (and I don't think its been mentioned enough):
> 
> There is a *VAST* existing user-base for DRBD.  Basically every vendor
> builds the modules for their kernels, ships the userspace tools, etc.
> *Regardless* of when or how it gets merged, the existing user-base
> will need kernel support for the existing tools.

I don't think that the user base can be a reason for mainline
inclusion.

IMHO, vendors should use their resource to push an out-of-tree thing
into mainline instead of taking care of it with their own
kernels. Finally, device-mapper people are trying to push the similar
feature. I think that the history taught us that people who have used
out-of-tree stuff eventually move in the mainline alternative.


> To put it another way:  Would you really keep a stable SCSI raid
> driver for existing hardware out of mainline by claiming they need to
> write a new raid-management abstraction first?  If not, then why the
> pushback on DRBD?

Yeah, we should have done that. It's too late though.

Anyway, I don't think that your example is fair; we need a driver
for scsi hardware but we have an alternative to drbd. 
