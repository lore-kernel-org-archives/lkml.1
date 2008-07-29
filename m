Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbYG2TBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbYG2TBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 15:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbYG2TAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 15:00:49 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43730 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751581AbYG2TAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 15:00:48 -0400
Subject: Re: tools support for non-512 byte sector sizes
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Jim Meyering <jim@meyering.net>,
       linux-kernel@vger.kernel.org, Martin Petersen <mkp@mkp.net>,
       Jeff Garzik <jeff@garzik.org>, Matt Domsch <Matt_Domsch@Dell.com>
In-Reply-To: <20080729185002.GD24924@parisc-linux.org>
References: <488F524F.6020905@redhat.com>
	 <20080729182611.GB24924@parisc-linux.org>
	 <1217356645.6103.48.camel@localhost.localdomain>
	 <20080729184243.GC24924@parisc-linux.org>
	 <1217357078.6103.51.camel@localhost.localdomain>
	 <20080729185002.GD24924@parisc-linux.org>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 14:00:19 -0500
Message-Id: <1217358019.6103.56.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 12:50 -0600, Matthew Wilcox wrote:
> On Tue, Jul 29, 2008 at 01:44:38PM -0500, James Bottomley wrote:
> > On Tue, 2008-07-29 at 12:42 -0600, Matthew Wilcox wrote:
> > > On Tue, Jul 29, 2008 at 01:37:25PM -0500, James Bottomley wrote:
> > > > scsi_debug does exactly the same thing, so it reports anything you tell
> > > > it (Martin Petersen actually added this so he could test with 4k
> > > > sectors).
> > > > 
> > > > The problem, which ata_ram also suffers, is that the tools we most need
> > > > to test are the ones for manipulating non volatile characteristics (like
> > > > partition tables).  We'd really like the disk contents to survive reboot
> > > > for this ...
> > > 
> > > Ummm... _reboot_, or _module unload/reload_?  I could certainly include
> > > an option to populate the ramdisc from a file.  Is the ioctl to re-read
> > > the partition table not enough?
> > 
> > reboot ... we'd like to take the tools through shutdown restart testing
> > to make sure they're all working ... of course, then there's the
> > bios ...
> 
> It's not up to us to fix the BIOS.
> 
> Since the vast majority of users use a distro, and the vast majority of
> distros use a fully modular kernel, wouldn't initialising the contents
> of ata-ram from the initrd/initramfs solve the problem?

Well ... we'd really like it file backed to truly verify ... sort of
like scsi_debug on a loopback.  But saving on shutdown and
reinitialising from the saved image on boot would likely be perfect.

James


