Return-Path: <linux-kernel-owner+w=401wt.eu-S1755700AbYHSQXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbYHSQXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 12:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbYHSQXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 12:23:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbYHSQXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 12:23:39 -0400
Date: Tue, 19 Aug 2008 12:10:32 -0400
From: Rik van Riel <riel@redhat.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Eric Paris <eparis@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Jan Harkes <jaharkes@cs.cmu.edu>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       hch@infradead.org, andi@firstfloor.org, viro@ZenIV.linux.org.uk
Subject: Re: HSM (was Re: [malware-list] TALPA - a threat model?  well
 sorta.)
Message-ID: <20080819121032.02632c09@riellaptop.surriel.com>
In-Reply-To: <20080819071416.GA14731@elf.ucw.cz>
References: <20080813173722.13c9c306@lxorguk.ukuu.org.uk>
	<1218646833.3540.82.camel@localhost.localdomain>
	<20080813205906.559d3f37@lxorguk.ukuu.org.uk>
	<2629CC4E1D22A64593B02C43E855530304AE4BC2@USILMS12.ca.com>
	<20080813173529.7069b5f1@cuia.bos.redhat.com>
	<20080815201622.GD31584@cs.cmu.edu>
	<20080815150509.20ffb91d@infradead.org>
	<1219015177.27389.1.camel@localhost.localdomain>
	<20080818163313.72927af7@lxorguk.ukuu.org.uk>
	<20080818124339.4b65b6c0@riellaptop.surriel.com>
	<20080819071416.GA14731@elf.ucw.cz>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008 09:14:16 +0200
Pavel Machek <pavel@suse.cz> wrote:

> On Mon 2008-08-18 12:43:39, Rik van Riel wrote:
> > On Mon, 18 Aug 2008 16:33:13 +0100
> > Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > 
> > > > I could probably buy that, but I don't know how an HSM would
> > > > work. Would we have everything we need at open for them to fire
> > > > off?
> > > > 
> > > > /me is HSM clueless and trying to include their needs is
> > > > proving a challenge.
> > > 
> > > So don't bother. Its a theoretical use for the most part so we can
> > > mangle the interface later. 
> > 
> > Think of a consumer HSM application: backup to rsync.net
> > or Amazon S3.
> > 
> > Instead of waiting for the whole backup to be restored,
> > you can start using the filesystem immediately.  The 
> > block-on-open hook can be used by the restore program
> > to fetch files from the remote backup site on an
> > as-needed basis, with a full restore going on in the
> > background.
> > 
> > If the block-on-open hook can be used for that (even
> > with additional magic, like creating empty HSM inodes
> > with a special attr to notify "the data lives elsewhere"),
> > HSM should be good.
> > 
> > The "data lives elsewhere" bit/xattr/whatever could also
> > be used on directories, so not even the whole directory
> > tree would have to be restored right on restore :)
> 
> But is this really needed to be cross-filesystem thing? I'd expect
> this to be implemented with FUSE, maybe FUSE+unionfs...

If you think FUSE+unionfs is a cleaner solution than one
hook in the VFS, I've got a bridge to sell you.
 
-- 
All rights reversed.
