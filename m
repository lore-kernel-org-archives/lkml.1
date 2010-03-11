Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042Ab0CKPEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 10:04:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932954Ab0CKPEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 10:04:08 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: James Bottomley <James.Bottomley@suse.de>
Subject: Re: ATA 4 KiB sector issues.
Date: Thu, 11 Mar 2010 20:35:26 +0530
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: Theodore Tso <tytso@mit.edu>, Damian Lukowski <damian@tvk.rwth-aachen.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Mark Lord <kernel@teksavvy.com>,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       aschnell@suse.de, jdelvare@suse.de
References: <4B947393.2050002@kernel.org> <472A4C80-30CE-4875-8073-F7E61659B6F0@mit.edu> <1268318374.2798.2.camel@mulgrave.site>
In-Reply-To: <1268318374.2798.2.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003112035.26743.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 March 2010 20:09:34 James Bottomley wrote:
> On Thu, 2010-03-11 at 09:28 -0500, Theodore Tso wrote:
> > On Mar 11, 2010, at 8:57 AM, Nikanth Karthikesan wrote:
> > > I guess, what he meant was, to keep filesystem blocks aligned, even if
> > > the partition is not. Say if the partition is mis-aligned by 512-bytes,
> > > let the filesystem waste 4k-512bytes and keep it's blocks aligned. But
> > > it might be a case of over-engineering, possibly requiring disk format
> > > change.
> >
> > Ah, yes, I agree with you; that's probably what he meant.
> >
> > Sure, that's theoretically possible, but it would mean changing every
> > single filesystem, and it would require a file system format change
> > --- or at least a file system format extension.
> >
> > It would seem to be way easier to simply fix the partitioning tools to
> > do the right thing, though.
> 
> Actually, it's a layering violation.  The filesystem shouldn't need to
> probe the device layout ... particularly when there are complexities
> like is it logical 512 or physical, and if logical 512 on 4k does it
> have an offset exponent or not.
> 
> We can transmit certain abstractions of information up the stack (like
> stripe width for RAID arrays which should be the fs optimal write size),
> but for this type of alignment, which can be completely solved at the
> partition layer, the information should really stay there and the
> filesystem should "just work".
> 

Right. It would be layering violation and we have LVM to solve it already.

The real problem, here is just that partitioning-tools should create 
partitions that can work with both XP as well as Windows7. May be distro 
installers, should ask the user which compatibility he needs.

Thanks
Nikanth
