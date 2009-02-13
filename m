Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbZBMCu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbZBMCu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 21:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbZBMCus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 21:50:48 -0500
Received: from thunk.org ([69.25.196.29]:33899 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbZBMCur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 21:50:47 -0500
Date: Thu, 12 Feb 2009 21:23:36 -0500
From: Theodore Tso <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Jan Kara <jack@suse.cz>,
       Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
       Ric Wheeler <rwheeler@redhat.com>
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
Message-ID: <20090213022336.GH6922@mini-me.lan>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao <fernando@oss.ntt.co.jp>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
	Ric Wheeler <rwheeler@redhat.com>
References: <1232185639.4831.18.camel@sebastian.kern.oss.ntt.co.jp> <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp> <20090119120349.GA10193@duck.suse.cz> <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp> <20090128095518.GA16554@duck.suse.cz> <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp> <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp> <499458C1.90105@redhat.com> <20090212212304.GA7935@duck.suse.cz> <499494E2.3060006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499494E2.3060006@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 03:30:10PM -0600, Eric Sandeen wrote:
> >   Yes, but OTOH we should give sysadmin a possibility to enable / disable
> > it on just some partitions. I don't see a reasonable use for that but people
> > tend to do strange things ;) and here isn't probably a strong reason to not
> > allow them.
> > 
>
> But nobody has asked for that, have they?  So why offer it up a this point?
> 
> They could use LD_PRELOAD to make fsync a no-op if they really don't
> care for it, I guess... though that's not easily per-fs either.

Actually, Bart Samwel at FOSDEM talked to me and asked for something
similar --- what we came up which meant his request while still being
standards-compliant was a per-process personality flag which had three
options:

     *)  Always honor fsync() calls (the default)
     *)  Never honor fsync() calls
     *)  Only honor fsync() calls if a global "honor fsync" flag
           (which would be manipulated by the laptop mode scripts)
	   is set.

The flag would be reset to the default across a setuid exec, but would
otherwise be inherited across fork()'s.  It might be possible to
set/get the flag via a /proc interface.

The basic idea is that laptop systems where the system administrator
wants longer battery life (and trusts the battery not to suddenly give
out) more than they care about fsync() guarantees can set up a pam
library which sets the flag for at login time so that all of the
user's processes can be set up not to honor fsync() calls; however,
all of the system daemons would still function normally.   

       	   	  	  	      	       - Ted
