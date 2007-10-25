Return-Path: <linux-kernel-owner+w=401wt.eu-S1759214AbXJYCiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214AbXJYCiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 22:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbXJYChv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 22:37:51 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:32073 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754682AbXJYChu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 22:37:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Vnr1uBy5XU6kd3qza/7fXGXjqqTeAZhTIuZ5RrFJuY00aV/GgM1hK5S/GbfwCeg16V/R2pWGzXh8uA0pM88VbgHdwTufCVjsq/wJfVgExgQvi234jGE5A4aCR/KVjRqc9FUaU4+5rTy46MepthJTWGika7xI11hJStykTsNdJkY=  ;
X-YMail-OSG: PdxO87UVM1leR4ku6bHASSS1wq9fA2PtmXVIYlCqANsm25WFDMZauJklNwxDCf1itDBEd7K2mw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: sysfs sys/kernel/ namespace (was Re: [PATCH 0/2] add new notifier function ,take2)
Date: Thu, 25 Oct 2007 12:31:06 +1000
User-Agent: KMail/1.9.5
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Takenori Nagano" <t-nagano@ah.jp.nec.com>, "Greg KH" <greg@kroah.com>
References: <471700F4.1080200@ah.jp.nec.com> <200710241648.55939.nickpiggin@yahoo.com.au> <3ae72650710240412h55469ae4r4379df0a66412c94@mail.gmail.com>
In-Reply-To: <3ae72650710240412h55469ae4r4379df0a66412c94@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710251231.07185.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2007 21:12, Kay Sievers wrote:
> On 10/24/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Tuesday 23 October 2007 10:55, Takenori Nagano wrote:
> > > Nick Piggin wrote:
> > > > One thing I'd suggest is not to use debugfs, if it is going to
> > > > be a useful end-user feature.
> > >
> > > Is /sys/kernel/notifier_name/ an appropriate place?
> >
> > I'm curious about the /sys/kernel/ namespace. I had presumed that
> > it is intended to replace /proc/sys/ basically with the same
> > functionality.
>
> It was intended to be something like /proc/sys/kernel/ only.

Really? So you'd be happy to have a /sys/dev /sys/fs /sys/kernel
/sys/net /sys/vm etc? "kernel" to me shouldn't really imply the
stuff under the kernel/ source directory or other random stuff
that doesn't fit into another directory, but attributes that are
directly related to the kernel software (rather than directly
associated with any device).


> > I _assume_ these are system software stats and
> > tunables that are not exactly linked to device drivers (OTOH,
> > where do you draw the line? eg. Would filesystems go here?
>
> We already have /sys/fs/ ?
>
> > Core network algorithm tunables might, but per interface ones probably
> > not...).
>
> We will merge the nonsense of "block/", "class/" and "bus/" to one
> "subsystem". The block, class, bus directories will only be kept as
> symlinks for compatibility. Then every subsystem has a directory like:
> /sys/subsystem/block/, /sys/subsystem/net/ and the devices of the
> subsystem are in a devices/ directory below that. Just like the
> /sys/bus/< name>/devices/ layout looks today. All subsystem-global
> tunables can go below the /sys/subsystem/<name>/ directory, without
> clashing with the list of devices or anything else.

Makes sense.


> > I don't know. Is there guidelines for sysfs (and procfs for that
> > matter)? Is anyone maintaining it (not the infrastructure, but
> > the actual content)?
>
> Unfortunately, there was never really a guideline.
>
> > It's kind of ironic that /proc/sys/ looks like one of the best
> > organised directories in proc, while /sys/kernel seems to be in
> > danger of becoming a mess: it has kexec and uevent files in the
> > base directory, rather than in subdirectories...
>
> True, just looking at it now, people do crazy things like:
> /sys/kernel/notes, which is a file with binary content, and a name
> nobody will ever be able to guess what it is good for. That should
> definitely go into a section/ directory.  Also the VM stuff there
> should probably move to a /sys/vm/ directory along with the weird
> placed top-level /sys/slab/.

Top level directory IMO should be kept as sparse as possible. If
you agree to /sys/mm for example, that's fine, but then slab should
go under that. (I'd prefer all to go underneath /sys/kernel, but...).

It would be nice to get a sysfs content maintainer or two. Just
having new additions occasionally reviewed along with the rest of
a patch, by random people, doesn't really aid consistency. Would it
be much trouble to ask that _all_ additions to sysfs be accompanied
by notification to this maintainer, along with a few line description?
(then merge would require SOB from said maintainer).

For that matter, this should be the case for *all* userspace API
changes (kernel-user-api@vger.kernel.org?)
