Return-Path: <linux-kernel-owner+w=401wt.eu-S1760004AbXJYGAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004AbXJYGAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 02:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757350AbXJYGAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 02:00:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60390 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbXJYGAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 02:00:32 -0400
Date: Wed, 24 Oct 2007 22:45:45 -0700
From: Greg KH <greg@kroah.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Takenori Nagano <t-nagano@ah.jp.nec.com>
Subject: Re: sysfs sys/kernel/ namespace (was Re: [PATCH 0/2] add new
	notifier function ,take2)
Message-ID: <20071025054545.GB15255@kroah.com>
References: <471700F4.1080200@ah.jp.nec.com> <200710241648.55939.nickpiggin@yahoo.com.au> <3ae72650710240412h55469ae4r4379df0a66412c94@mail.gmail.com> <200710251231.07185.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710251231.07185.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 12:31:06PM +1000, Nick Piggin wrote:
> On Wednesday 24 October 2007 21:12, Kay Sievers wrote:
> > On 10/24/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > On Tuesday 23 October 2007 10:55, Takenori Nagano wrote:
> > > > Nick Piggin wrote:
> > > > > One thing I'd suggest is not to use debugfs, if it is going to
> > > > > be a useful end-user feature.
> > > >
> > > > Is /sys/kernel/notifier_name/ an appropriate place?
> > >
> > > I'm curious about the /sys/kernel/ namespace. I had presumed that
> > > it is intended to replace /proc/sys/ basically with the same
> > > functionality.
> >
> > It was intended to be something like /proc/sys/kernel/ only.
> 
> Really? So you'd be happy to have a /sys/dev /sys/fs /sys/kernel
> /sys/net /sys/vm etc? "kernel" to me shouldn't really imply the
> stuff under the kernel/ source directory or other random stuff
> that doesn't fit into another directory, but attributes that are
> directly related to the kernel software (rather than directly
> associated with any device).

What would you want in /sys/net and /sys/dev and /sys/vm?  I don't mind
putting subdirs in /sys/kernel/ if you want it.

> > > I _assume_ these are system software stats and
> > > tunables that are not exactly linked to device drivers (OTOH,
> > > where do you draw the line? eg. Would filesystems go here?
> >
> > We already have /sys/fs/ ?
> >
> > > Core network algorithm tunables might, but per interface ones probably
> > > not...).
> >
> > We will merge the nonsense of "block/", "class/" and "bus/" to one
> > "subsystem". The block, class, bus directories will only be kept as
> > symlinks for compatibility. Then every subsystem has a directory like:
> > /sys/subsystem/block/, /sys/subsystem/net/ and the devices of the
> > subsystem are in a devices/ directory below that. Just like the
> > /sys/bus/< name>/devices/ layout looks today. All subsystem-global
> > tunables can go below the /sys/subsystem/<name>/ directory, without
> > clashing with the list of devices or anything else.
> 
> Makes sense.
> 
> 
> > > I don't know. Is there guidelines for sysfs (and procfs for that
> > > matter)? Is anyone maintaining it (not the infrastructure, but
> > > the actual content)?
> >
> > Unfortunately, there was never really a guideline.
> >
> > > It's kind of ironic that /proc/sys/ looks like one of the best
> > > organised directories in proc, while /sys/kernel seems to be in
> > > danger of becoming a mess: it has kexec and uevent files in the
> > > base directory, rather than in subdirectories...
> >
> > True, just looking at it now, people do crazy things like:
> > /sys/kernel/notes, which is a file with binary content, and a name
> > nobody will ever be able to guess what it is good for. That should
> > definitely go into a section/ directory.  Also the VM stuff there
> > should probably move to a /sys/vm/ directory along with the weird
> > placed top-level /sys/slab/.
> 
> Top level directory IMO should be kept as sparse as possible. If
> you agree to /sys/mm for example, that's fine, but then slab should
> go under that. (I'd prefer all to go underneath /sys/kernel, but...).
> 
> It would be nice to get a sysfs content maintainer or two. Just
> having new additions occasionally reviewed along with the rest of
> a patch, by random people, doesn't really aid consistency. Would it
> be much trouble to ask that _all_ additions to sysfs be accompanied
> by notification to this maintainer, along with a few line description?
> (then merge would require SOB from said maintainer).

No, I would _love_ that.  We should make the requirement that all new
sysfs files be documented in Documentation/API/ like that details.

I'll be glad to review it, but as it's pretty trivial to add sysfs
files, everyone ends up doing it :)

thanks,

greg k-h
