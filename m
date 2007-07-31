Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbXGaKx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbXGaKx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 06:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbXGaKxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 06:53:19 -0400
Received: from THUNK.ORG ([69.25.196.29]:48199 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816AbXGaKxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 06:53:18 -0400
Date: Tue, 31 Jul 2007 06:53:09 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC 12/26] ext2 white-out support
Message-ID: <20070731105309.GA6980@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jan Blunck <jblunck@suse.de>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bharata B Rao <bharata@linux.vnet.ibm.com>
References: <20070730161323.100048969@weierstrass.suse.de> <20070730161324.261652101@weierstrass.suse.de> <20070731034515.GD25876@thunk.org> <20070731074436.GE5101@hasse.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731074436.GE5101@hasse.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 09:44:36AM +0200, Jan Blunck wrote:
> Ok, this is pretty similar to the way I implemented this for tmpfs. The
> problem is that the union mount code is explicitly checking if the filesystem
> is supporting whiteout. I used to use a new filesystem flag (FS_WHITEOUT) for
> this but thought that disk filesystem like ext2/3/4 will have problem with
> that if you mount an old image. So I guess I still need a feature flag.

Without the method I described to you, *any* ext2/3/4 filesystem will
support whiteouts (as long as you have the support code compiled into
the kernel :-), so there's no need for a feature flag.

> > I wouldn't bother with setting the directory type field to be DT_WHT,
> > given that they will never be returned to userspace anyway.
> 
> At the moment I still rely on this for the current readdir implementation.
> Viro already said that he doesn't want to see this (the readdir changes) in
> the kernel but in userspace.

Life gets very messy if you have to do this in userspace.  Example:
statically linked programs that were compiled with a version of glibc
that didn't know about whiteout records.  Unfortunately, the memory
needed to to collate directories entries so that whiteout records can
be dropped is painful enough that completely understand why Al doesn't
want to see this in userspace.  Unfortunately this is going to be one
of those things that will make union mounts problematic, compared to
something like unionfs.

						- Ted
