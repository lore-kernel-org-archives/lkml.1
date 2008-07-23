Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbYGWF2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbYGWF2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 01:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbYGWF1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 01:27:54 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:41113 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753023AbYGWF1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 01:27:53 -0400
X-Sasl-enc: YG+F6FVJbs9BemsFbsyVEvuds/6xuSyiO9eKBmj1Ehgo 1216790872
Subject: Re: [PATCH 6/7] autofs4 - use struct qstr in waitq.c
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, autofs@linux.kernel.org,
       linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Jeff Moyer <jmoyer@redhat.com>
In-Reply-To: <20080722221731.9b688b45.akpm@linux-foundation.org>
References: <20080617122336.14725.64829.stgit@raven.themaw.net>
	 <20080617122406.14725.84758.stgit@raven.themaw.net>
	 <20080722161357.802ad1a5.akpm@linux-foundation.org>
	 <1216789721.2995.29.camel@raven.themaw.net>
	 <20080722221731.9b688b45.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 23 Jul 2008 13:24:00 +0800
Message-Id: <1216790642.2995.41.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-07-22 at 22:17 -0700, Andrew Morton wrote:
> On Wed, 23 Jul 2008 13:08:40 +0800 Ian Kent <raven@themaw.net> wrote:
> 
> > 
> > On Tue, 2008-07-22 at 16:13 -0700, Andrew Morton wrote:
> > > On Tue, 17 Jun 2008 20:24:06 +0800
> > > Ian Kent <raven@themaw.net> wrote:
> > > 
> > > > From: Jeff Moyer <jmoyer@redhat.com>
> > > > 
> > > > The autofs_wait_queue already contains all of the fields of the
> > > > struct qstr, so change it into a qstr.
> > > > 
> > > > This patch, from Jeff Moyer, has been modified a liitle by myself.
> > > > 
> > > > Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> > > > Signed-off-by: Ian Kent <raven@themaw.net>
> > > 
> > > So this patch which had been happily sitting in -mm for a month has
> > > suddenly broken because linux-next's three-day-old
> > > 4bce7ce7c7d0d57b78dacc3a2bd87ec63b2d9b4c has removed LOOKUP_ACCESS.
> > > 
> > > This is suboptimal.
> > > 
> > > Now what do I do?
> > 
> > Ummm .. I'm confused.
> > 
> > Your patch autofs4-use-lookup-intent-flags-to-trigger-mounts-fix.patch
> > allows the linux-next kernel to build with all the autofs4 patches
> > currently posted for inclusion in mm but the patch you mention here
> > isn't concerned with the lookup flags?
> 
> Yeah, I picked the wrong patch to reply to.

Hahaha, ;)

> 
> > The removal of LOOKUP_ACCESS is quite interesting. AFAIKS it effectively
> > prevents the patch
> > autofs4-use-lookup-intent-flags-to-trigger-mounts.patch from also
> > resolving an issue with recursive autofs mounts while still resolving
> > the issue that the patch was actually meant to address.
> > 
> > It's hard to get exited about the former issue as Al Viro has NACKed a
> > previous patch that added the LOOKUP_ACCESS check, indicating the
> > availability of the lookup flags will be changing. Also there is a
> > question as to whether autofs will support the use mount points in
> > automount maps that themselves refer to an automount path (the recursive
> > bit).
> 
> So what do we do?

Yeah, best thing to do is to go with the patch that you did to resolve
it. I'm going to need to deal with changes to the availability of the
lookup flags to modules as they come up anyway.

I don't want to hold things up due to the recursive mount issue as Al
has pointed out it doesn't work correctly now anyway. I haven't had time
to look into it as it isn't at the top of my priority list.

Ian


