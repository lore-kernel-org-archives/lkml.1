Return-Path: <linux-kernel-owner+w=401wt.eu-S1752882AbZAEBKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbZAEBKi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 20:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbZAEBK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 20:10:28 -0500
Received: from phunq.net ([64.81.85.152]:59420 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751827AbZAEBK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 20:10:27 -0500
From: Daniel Phillips <phillips@phunq.net>
To: tux3@tux3.org
Subject: Re: [Tux3] Tux3 report: A Golden Copy
Date: Sun, 4 Jan 2009 17:10:12 -0800
User-Agent: KMail/1.9.5
Cc: Theodore Tso <tytso@mit.edu>, Jamie Lokier <jamie@shareable.org>,
       linux-fsdevel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org
References: <200812301935.49303.phillips@phunq.net> <20090104031733.GB20929@shareable.org> <20090104130446.GA17558@mit.edu>
In-Reply-To: <20090104130446.GA17558@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901041710.12435.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

On Sunday 04 January 2009 05:04, Theodore Tso wrote:
> On Sun, Jan 04, 2009 at 03:17:33AM +0000, Jamie Lokier wrote:
> > Justin P. Mattock wrote:
> > > >One feature we are kicking around to make life easier for SELinux:
> > > >sometimes the filesystem can run while SELinux is not running, and
> > > >security labels will be wrong when SELinux re-enters the picture.  We
> > > >have in mind to provide a persistent log of filesystem events that the
> > > >security system can attach to on startup and find out what went on in
> > > >its absence.
> > > >
> > That sounds like a feature Windows had for many years now, (since
> > Windows 2000?).  It complements the Windows equivlant of
> > dnotify/inotify/fsnotify.
> 
> Arguably you want to do this in the VFS layer, not in the low-level
> filesystem level if you want most applications to adopt it.

It has to be generic all right, but the VFS is not able to do the job
on its own.  To be useful for indexing, the reported events must
already be persistently recorded, and the VFS has no idea about when
that happens.  The filesystem is the expert on that subject, and it
must generate the events.  I can't imagine a reasonable VFS-level
emulation, or what value the VFS would add by acting as middleman for
a stream of filesystem events.

The natural way to do this is for the filesystem to stream events
directly to the monitoring application over a pipe-like fd.  Maybe a
library for event delivery could be shared by filesystems, to impose
a standard format.  The role of the VFS would be simply to set up the
event connection, or to report that it is not supported.

> > It's used for file indexing too (think equivalent to Spotlight,
> > Beagle, etc.), and other types of security scanning (think equivalent
> > to Tripwire).
> 
> Eric Paris has a patch he's been proposing for a while now for a new
> notify mechanism designed for anti-virus scanners...

An event stream accurate enough to support indexing is a considerably
harder problem, I think.

Regards,

Daniel
