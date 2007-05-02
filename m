Return-Path: <linux-kernel-owner+w=401wt.eu-S2993148AbXEBT3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993148AbXEBT3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766675AbXEBT3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:29:06 -0400
Received: from THUNK.ORG ([69.25.196.29]:55603 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993148AbXEBT3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:29:03 -0400
Date: Wed, 2 May 2007 15:28:49 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Cabot, Mason B" <mason.b.cabot@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Ext3 vs NTFS performance
Message-ID: <20070502192849.GD19442@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Cabot, Mason B" <mason.b.cabot@intel.com>,
	linux-kernel@vger.kernel.org
References: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com> <20070501142325.09c294bd.akpm@linux-foundation.org> <p73slafxvor.fsf@bingen.suse.de> <20070502160436.GA19442@thunk.org> <p73y7k7vzks.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73y7k7vzks.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 08:40:35PM +0200, Andi Kleen wrote:
> Theodore Tso <tytso@mit.edu> writes:
> 
> > On Wed, May 02, 2007 at 02:21:40PM +0200, Andi Kleen wrote:
> > > Andrew Morton <akpm@linux-foundation.org> writes:
> > > > 
> > > > Conceivably we could address this in the filesystem without mucking other
> > > > things up.  But I'd have thought the simplest damage-control would be to
> > > > detect this pattern in samba and to then use glibc's fallocate().
> > > 
> > > The advantage of detecting it in kernel would be that it would handle
> > > Linux applications that do this (I suspect there are some) too.
> > 
> > Um, which applications do you suspect?  So we can hunt down those user
> > space applications programmers and slap them silly?  Or rather,
> > unsilly, since that there's no good reason to ever suspect that
> > writing a byte every 128k would result in a good allocation layout on disk?
> 
> Anything that uses glibc fallocate() ?

Glibc's fallocate current writes all zeros, not 1 byte every
128kbytes.  And once we wire up the new sys_fallocate() support, we'll
have the right preallocation support in ext4.

					- Ted
