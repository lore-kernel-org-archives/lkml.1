Return-Path: <linux-kernel-owner+w=401wt.eu-S932128AbZJDTD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbZJDTD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 15:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757656AbZJDTDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 15:03:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48487 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834AbZJDTDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 15:03:54 -0400
Date: Sun, 4 Oct 2009 21:03:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andreas Dilger <adilger@sun.com>, Valdis.Kletnieks@vt.edu,
       linux@treblig.org, agruen@suse.de, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: new O_NODE open flag
Message-ID: <20091004190304.GJ1378@ucw.cz>
References: <E1Mqpfq-0003uZ-Pw@pomaz-ex.szeredi.hu> <200909250223.58664.agruen@suse.de> <E1Mr3jF-0005G4-Sf@pomaz-ex.szeredi.hu> <20090925123747.GA31228@gallifrey> <9988.1253899252@turing-police.cc.vt.edu> <20090925183523.GA6065@gallifrey> <19645.1253913514@turing-police.cc.vt.edu> <E1MsDQ6-0001cY-92@pomaz-ex.szeredi.hu> <20090928152128.GA3384@webber.adilger.int> <E1MsIhu-0002AY-F2@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1MsIhu-0002AY-F2@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-09-28 18:04:10, Miklos Szeredi wrote:
> On Mon, 28 Sep 2009, Andreas Dilger wrote:
> > On Sep 28, 2009  12:25 +0200, Miklos Szeredi wrote:
> > > BTW I just checked, and it is possible to re-open or promote an fd
> > > opened with O_NODE like this:
> > > 
> > > 	char tmp[64];
> > > 
> > > 	fd = open(filename, O_NODE | O_NOACCESS);
> > > 	/* ... */
> > > 	sprintf(tmp, "/proc/self/fd/%i", fd);
> > > 	fd_rw = open(tmp, O_RDWR);
> > > 
> > > Now fd_rw is guaranteed to refer to the same inode as fd.
> > 
> > It seems very unpleasant to require applications using O_NODE to
> > reopen files using /proc.
> 
> The point of the above example was that reopening a file descriptor
> with upgraded (or downgraded) access mode is even now possible.  Which
> either means:
> 
>  a) the current permission model under /proc/PID/fd has a security
>     hole (which Jamie is worried about)

I believe its bugtraq time. Being able to reopen file with additional
permissions looks like  a security problem...

Jamie, do you have some test script? And do you want your 15 minutes
 of bugtraq fame? ;-).
 
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
