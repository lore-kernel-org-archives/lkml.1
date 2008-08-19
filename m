Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbYHSTUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbYHSTUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 15:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbYHSTUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 15:20:39 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3019 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752623AbYHSTUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 15:20:38 -0400
Date: Tue, 19 Aug 2008 21:20:27 +0200
From: Pavel Machek <pavel@suse.cz>
To: Rik van Riel <riel@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Eric Paris <eparis@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Jan Harkes <jaharkes@cs.cmu.edu>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       hch@infradead.org, andi@firstfloor.org, viro@ZenIV.linux.org.uk
Subject: Re: HSM (was Re: [malware-list] TALPA - a threat model?  well sorta.)
Message-ID: <20080819192027.GA6484@ucw.cz>
References: <20080813205906.559d3f37@lxorguk.ukuu.org.uk> <2629CC4E1D22A64593B02C43E855530304AE4BC2@USILMS12.ca.com> <20080813173529.7069b5f1@cuia.bos.redhat.com> <20080815201622.GD31584@cs.cmu.edu> <20080815150509.20ffb91d@infradead.org> <1219015177.27389.1.camel@localhost.localdomain> <20080818163313.72927af7@lxorguk.ukuu.org.uk> <20080818124339.4b65b6c0@riellaptop.surriel.com> <20080819071416.GA14731@elf.ucw.cz> <20080819121032.02632c09@riellaptop.surriel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819121032.02632c09@riellaptop.surriel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-08-19 12:10:32, Rik van Riel wrote:
> On Tue, 19 Aug 2008 09:14:16 +0200
> Pavel Machek <pavel@suse.cz> wrote:
> 
> > On Mon 2008-08-18 12:43:39, Rik van Riel wrote:
> > > On Mon, 18 Aug 2008 16:33:13 +0100
> > > Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > 
> > > > > I could probably buy that, but I don't know how an HSM would
> > > > > work. Would we have everything we need at open for them to fire
> > > > > off?
> > > > > 
> > > > > /me is HSM clueless and trying to include their needs is
> > > > > proving a challenge.
> > > > 
> > > > So don't bother. Its a theoretical use for the most part so we can
> > > > mangle the interface later. 
> > > 
> > > Think of a consumer HSM application: backup to rsync.net
> > > or Amazon S3.
> > > 
> > > Instead of waiting for the whole backup to be restored,
> > > you can start using the filesystem immediately.  The 
> > > block-on-open hook can be used by the restore program
> > > to fetch files from the remote backup site on an
> > > as-needed basis, with a full restore going on in the
> > > background.
> > > 
> > > If the block-on-open hook can be used for that (even
> > > with additional magic, like creating empty HSM inodes
> > > with a special attr to notify "the data lives elsewhere"),
> > > HSM should be good.
> > > 
> > > The "data lives elsewhere" bit/xattr/whatever could also
> > > be used on directories, so not even the whole directory
> > > tree would have to be restored right on restore :)
> > 
> > But is this really needed to be cross-filesystem thing? I'd expect
> > this to be implemented with FUSE, maybe FUSE+unionfs...
> 
> If you think FUSE+unionfs is a cleaner solution than one
> hook in the VFS, I've got a bridge to sell you.

If you can do it with one clean enough hook, I'll buy that bridge.

[If you want to do 'list directory before files are there' -- and you
seem to want to from description above -- fuse seems like a way to
go.]
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
