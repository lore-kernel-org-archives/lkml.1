Return-Path: <linux-kernel-owner+w=401wt.eu-S1753008AbXFNG7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbXFNG7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 02:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbXFNG7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 02:59:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:25563 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbXFNG7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 02:59:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lpuXfSlF+QDqjP/QAExETNCoLuGizDj9J5x1fNbg0wT4xaCvDUUIcso82kn9CRHZIND+v9rjOf9thj13wlr9xRnxtVkP41Kix2eL6DUoemO7Yf0gDd1VHgPceOU95LqOq7TidP+V3y8M8lV/NvQwS9zmkgozCfXsavZ4UOd5Vb4=
Message-ID: <787b0d920706132359h17531f57gdc4ed01724e53361@mail.gmail.com>
Date: Thu, 14 Jun 2007 02:59:23 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Chris Mason" <chris.mason@oracle.com>
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, snitzer@gmail.com
In-Reply-To: <20070613165706.GF28279@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920706122245j3a2ff7e8ja611ecf41cc67a4c@mail.gmail.com>
	 <20070613120037.GA28279@think.oraclecorp.com>
	 <787b0d920706130914l676a24cau62525e90a90b5839@mail.gmail.com>
	 <20070613165706.GF28279@think.oraclecorp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/13/07, Chris Mason <chris.mason@oracle.com> wrote:
> On Wed, Jun 13, 2007 at 12:14:40PM -0400, Albert Cahalan wrote:
> > On 6/13/07, Chris Mason <chris.mason@oracle.com> wrote:
> > >On Wed, Jun 13, 2007 at 01:45:28AM -0400, Albert Cahalan wrote:

> > >> * secure delete via destruction of per-file or per-block random crypto
> > >keys
> > >
> > >I'd rather keep secure delete as a userland problem (or a layered FS
> > >problem).  When you take backups and other copies of the file into
> > >account, it's a bigger problem than btrfs wants to tackle right now.
> >
> > It can't be a userland problem if you allow disk blocks to move.
> > Volume resizing, logging/journalling, etc. -- they combine to make
> > the userland solution essentially impossible. (one could wipe the
> > whole partition, or maybe fill ALL space on the volume)
>
> Right about here is where I would insert a long story about ecryptfs, or
> encryption solutions that happen all in userland.  At any rate, it is
> outside the scope of v1.0, even though I definitely agree it is an
> important problem for some people.

I'm sure you do have a nice long story, and I'm sure it seems
correct, but there is something not quite right about the add-on
hacks.

BTW, I'm suggesting that this be about deletion, not protection
of data you wish to keep. It covers more than just file bodies.
It covers inode data, block allocations, etc.

> > >> * atomic creation of copy-on-write directory trees
> > >
> > >Do you mean something more fine grained than the current snapshotting
> > >system?
> >
> > I believe so. Example: I have a linux-2.6 directory. It's not
> > a mount point or anything special like that. I want to copy
> > it to a new directory called wip, without actually copying
> > all the blocks. To all the normal POSIX API stuff, this copy
> > should look like the result of "cp -a", not hard links.
>
> This would be a snapshot, which has to be done on a subvolume right now.
> It is not as nice as being able to pick a random directory, but I've
> only been able to get this far by limiting the feature scope
> significantly.  What I did do was make subvolumes very cheap...just make
> a bunch of them.

Can a regular user create and use a subvolume? If not, then
this doesn't work. (if so, then I have other concerns...)
