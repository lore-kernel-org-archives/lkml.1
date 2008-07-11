Return-Path: <linux-kernel-owner+w=401wt.eu-S1760720AbYGKUjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720AbYGKUjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 16:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbYGKUjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 16:39:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60476 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760119AbYGKUjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 16:39:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH -mm 1/2] kexec jump -v12: kexec jump
Date: Fri, 11 Jul 2008 22:40:58 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>,
       Huang Ying <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1215401122.4660.4.camel@caritas-dev.intel.com> <20080711122131.b6461ab1.akpm@linux-foundation.org> <20080711202434.GB6261@elf.ucw.cz>
In-Reply-To: <20080711202434.GB6261@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807112240.59461.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 11 of July 2008, Pavel Machek wrote:
> On Fri 2008-07-11 12:21:31, Andrew Morton wrote:
> > On Tue, 8 Jul 2008 10:50:51 -0400 Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > On Mon, Jul 07, 2008 at 11:25:22AM +0800, Huang Ying wrote:
> > > > This patch provides an enhancement to kexec/kdump. It implements
> > > > the following features:
> > > > 
> > > > - Backup/restore memory used by the original kernel before/after
> > > >   kexec.
> > > > 
> > > > - Save/restore CPU state before/after kexec.
> > > > 
> > > 
> > > Hi Huang,
> > > 
> > > In general this patch set looks good enough to live in -mm and
> > > get some testing going.
> > > 
> > > To me, adding capability to return back to original kernel looks
> > > like a logical extension to kexec functionality.
> > 
> > Exciting ;)  It's much less code than I expected.
> > 
> > I don't think I understand the feature any more.  Once upon a time we
> > thought that this might become a new and better (or at least
> > better-code-sharing) way of doing suspend-to-disk.  How far are we from
> > that?
> 
> Well, it will be tricky to get kjump-hibernation right with respect to
> ACPI, but we should be fairly close to basic hibernation working with
> this. It has major advantage of not needing refrigerator (and few
> disadvantages -- like doing aditional boot during suspend).

Please, stop that.  This has always been a bogus argument.

The truth is we could do hibernation without the freezer if
(a) some drivers were fixed not to rely on it (kexec doesn't help here),
(b) we had support at the block layer or filesystems level (kexec is a big
   workaround here).

> But main reason I'd like kjump to be in is different -- it should be
> useful to stuff like "dump but continue running", etc...

That's a different thing.

Thanks,
Rafael
