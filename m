Return-Path: <linux-kernel-owner+w=401wt.eu-S1758843AbZEMIpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843AbZEMIpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 04:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758048AbZEMIoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 04:44:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45721 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756564AbZEMIoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 04:44:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 0/6] PM/Hibernate: Rework memory shrinking (rev. 4)
Date: Wed, 13 May 2009 10:32:52 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc5-rjw; KDE/4.2.2; x86_64; ; )
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@tuxonice.net>,
       David Rientjes <rientjes@google.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <200905070040.08561.rjw@sisk.pl> <200905072348.59856.rjw@sisk.pl> <200905101548.57557.rjw@sisk.pl>
In-Reply-To: <200905101548.57557.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905131032.53624.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 May 2009, Rafael J. Wysocki wrote:
> On Thursday 07 May 2009, Rafael J. Wysocki wrote:
> > On Thursday 07 May 2009, Rafael J. Wysocki wrote:
> > > Hi,
> > > 
> > > The following patchset is an attempt to rework the memory shrinking mechanism
> > > used during hibernation to make room for the image.  It is a work in progress
> > > and most likely it's going to be modified, but it has been discussed recently
> > > and I'd like to get comments on the current version.
> > > 
> > > [1/5] - disable the OOM kernel after freezing tasks (this will be dropped if
> > >         it's verified that we can avoid the OOM killing by using
> > >         __GFP_FS|__GFP_WAIT|__GFP_NORETRY|__GFP_NOWARN
> > >         in the next patches).
> > > 
> > > [2/5] - drop memory shrinking from the suspend (to RAM) code path
> > > 
> > > [3/5] - move swsusp_shrink_memory() to snapshot.c
> > > 
> > > [4/5] - rework swsusp_shrink_memory() (to use memory allocations for applying
> > >         memory pressure)
> > > 
> > > [5/5] - allocate image pages along with the shrinking.
> > 
> > Updated patchset follows.
> 
> I the meantime I added a patch that attempts to computer the size of the hard
> core working set.  I also had to rework the patch reworking
> swsusp_shrink_memory() so that it takes highmem into account.
> 
> Currently, the patchset consists of the following patches:
> 
> [1/6] - disable the OOM kernel after freezing tasks (this will be dropped if
>         it's verified that we can avoid the OOM killing by using
>         __GFP_FS|__GFP_WAIT|__GFP_NORETRY|__GFP_NOWARN
>         in the next patches).
> 
> [2/6] - drop memory shrinking from the suspend (to RAM) code path
> 
> [3/6] - move swsusp_shrink_memory() to snapshot.c
> 
> [4/6] - rework swsusp_shrink_memory() (to use memory allocations for applying
>         memory pressure)
> 
> [5/6] - allocate image pages along with the shrinking
> 
> [6/6] - estimate the size of the hard core working set and use it as the lower
>         limit of the image size.

This is the 4th (and hopefully final) version of the patchset reworking
hibernation memory shrinking.  The patches have been rearranged and some of
them were modified to fix bugs etc.

[1/6] - drop memory shrinking from the suspend (to RAM) code path

[2/6] - move swsusp_shrink_memory() to snapshot.c

[3/6] - disable the OOM killer after freezing tasks (now it is done it a
        simpler way)

[4/6] - rework swsusp_shrink_memory() to use memory allocations for applying
        memory pressure)

[5/6] - do not release the preallocated image pages

[6/6] - estimate the minimum image size and use it to avoid attempting to free
        too much memory too hard

IMO patches [1/6] and [2/6] are ready to go, so I'm going to add them to the
linux-next branch of the suspend tree.

Patch [3/6] in in mm, but it would be easier to handle [4/6] - [6/6] having
this patch in the suspend tree.  Dunno.  Andrew, what would you prefer to do
with it?

Patches [4/6] - [6/6] have been tested on a couple of boxes in different
configuration and no major problems have been found.

Comments welcome.

Thanks,
Rafael

