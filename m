Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbZGVP0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbZGVP0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZGVP0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:26:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35198 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbZGVP0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:26:31 -0400
Subject: Re: GFS2: Add LED support to GFS2
From: Steven Whitehouse <swhiteho@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org, rpurdie@rpsys.net
In-Reply-To: <20090722151521.GB6035@basil.fritz.box>
References: <1248260198.3456.4.camel@localhost.localdomain>
	 <87k5203hdx.fsf@basil.nowhere.org>
	 <1248274288.3298.5.camel@localhost.localdomain>
	 <20090722145534.GA6035@basil.fritz.box>
	 <1248274951.3298.11.camel@localhost.localdomain>
	 <20090722151521.GB6035@basil.fritz.box>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Wed, 22 Jul 2009 16:24:41 +0100
Message-Id: <1248276281.3298.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2009-07-22 at 17:15 +0200, Andi Kleen wrote:
> > I did consider adding a feature to filter events on a per superblock
> > basis, but I decided against it in the end, as it seemed to be making
> > things too complicated (how should we specify the superblock? what
> > should the user interface be?).
> 
> Maybe key on mount points? (so passing vfsmnts) 
> 
That might be an issue though... there might be multiple super blocks
for a single mount point I think. We could try specifying devices
instead, but there might be multiple devices for one fs.

We can't hold refs to the vfsmnts since that would prevent umount, so
we'd need to get notified at umount time so that we can clear old
entries from the list. Matching on devices might just resolve this, but
its no good when device numbers are not stable, which would make
configuration a pain across a cluster.

What was a simple patch is rapidly becoming rather complicated :(

> So have some sysfs file where you echo mount points into to enable
> LED activity.
> 
Yes, the real issue is where to put them. I'm not sure if we can add
them into the LED sysfs files which where they probably ought to live.
Richard, what do you think?

> Ok that would be a little clumpsy for a "10 million bind mounts" case,
> but presumably that's very rare and they can still make it work.
> 
> -Andi
> 
I suspect that it will become less rare as time goes on.

So whilst I'd also like a more generic feature, I'm still not entirely
convinced that it would be a better solution yet,

Steve.


