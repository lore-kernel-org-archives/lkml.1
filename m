Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbZEJON1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbZEJON1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 10:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbZEJONP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 10:13:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54508 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbZEJONP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 10:13:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: [RFC][PATCH 0/6] PM/Hibernate: Rework memory shrinking (rev. 3)
Date: Sun, 10 May 2009 15:48:56 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@tuxonice.net>,
       David Rientjes <rientjes@google.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <200905070040.08561.rjw@sisk.pl> <200905072348.59856.rjw@sisk.pl>
In-Reply-To: <200905072348.59856.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905101548.57557.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 May 2009, Rafael J. Wysocki wrote:
> On Thursday 07 May 2009, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > The following patchset is an attempt to rework the memory shrinking mechanism
> > used during hibernation to make room for the image.  It is a work in progress
> > and most likely it's going to be modified, but it has been discussed recently
> > and I'd like to get comments on the current version.
> > 
> > [1/5] - disable the OOM kernel after freezing tasks (this will be dropped if
> >         it's verified that we can avoid the OOM killing by using
> >         __GFP_FS|__GFP_WAIT|__GFP_NORETRY|__GFP_NOWARN
> >         in the next patches).
> > 
> > [2/5] - drop memory shrinking from the suspend (to RAM) code path
> > 
> > [3/5] - move swsusp_shrink_memory() to snapshot.c
> > 
> > [4/5] - rework swsusp_shrink_memory() (to use memory allocations for applying
> >         memory pressure)
> > 
> > [5/5] - allocate image pages along with the shrinking.
> 
> Updated patchset follows.

I the meantime I added a patch that attempts to computer the size of the hard
core working set.  I also had to rework the patch reworking
swsusp_shrink_memory() so that it takes highmem into account.

Currently, the patchset consists of the following patches:

[1/6] - disable the OOM kernel after freezing tasks (this will be dropped if
        it's verified that we can avoid the OOM killing by using
        __GFP_FS|__GFP_WAIT|__GFP_NORETRY|__GFP_NOWARN
        in the next patches).

[2/6] - drop memory shrinking from the suspend (to RAM) code path

[3/6] - move swsusp_shrink_memory() to snapshot.c

[4/6] - rework swsusp_shrink_memory() (to use memory allocations for applying
        memory pressure)

[5/6] - allocate image pages along with the shrinking

[6/6] - estimate the size of the hard core working set and use it as the lower
        limit of the image size.

Comments welcome.

Thanks,
Rafael

