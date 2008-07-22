Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbYGVUwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbYGVUwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 16:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbYGVUw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 16:52:29 -0400
Received: from ns2.suse.de ([195.135.220.15]:45750 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291AbYGVUw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 16:52:26 -0400
Date: Tue, 22 Jul 2008 13:49:39 -0700
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, ak@linux.intel.com,
       Ingo Molnar <mingo@elte.hu>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 72/79] sysdev: Pass the attribute to the low level
	sysdev show/store function
Message-ID: <20080722204939.GA3028@suse.de>
References: <20080722051805.GA17373@suse.de> <1216703983-21448-72-git-send-email-gregkh@suse.de> <20080722134045.7f09ff29.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722134045.7f09ff29.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 01:40:45PM -0700, Andrew Morton wrote:
> On Mon, 21 Jul 2008 22:19:36 -0700
> Greg Kroah-Hartman <gregkh@suse.de> wrote:
> 
> > From: Andi Kleen <andi@firstfloor.org>
> > 
> > This allow to dynamically generate attributes and share show/store
> > functions between attributes. Right now most attributes are generated
> > by special macros and lots of duplicated code. With the attribute
> > passed it's instead possible to attach some data to the attribute
> > and then use that in shared low level functions to do different things.
> > 
> > I need this for the dynamically generated bank attributes in the x86
> > machine check code, but it'll allow some further cleanups.
> > 
> > I converted all users in tree to the new show/store prototype. It's a single
> > huge patch to avoid unbisectable sections.
> > 
> > Runtime tested: x86-32, x86-64
> > Compiled only: ia64, powerpc
> > Not compile tested/only grep converted: sh, arm, avr32
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> >
> > ...
> >
> >  kernel/sched.c                            |    8 ++++-
> 
> This wrecks use-sysdev_class-in-schedc.patch (below), which I merged a
> week ago and will now drop.
> 
> Why did this patch from Andi just turn up in linux-next now, halfway
> through the merge window?  It has a commit date of July 1 yet it has
> never before been sighted in linux-next.

What?  It's been in linux-next for a while now as it's been in my tree
for quite some time.  Unless it somehow got reverted in -next and I
didn't realize it?  Which I kind of doubt as it was causing problems
with the sparc build and I got reports of that.

This should be a simple merge, the show/store functions of sysdev now
just got an additional parameter, like we've done for a while with other
types of attributes.

thanks,

greg k-h
