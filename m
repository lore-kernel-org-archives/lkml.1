Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab0CKOjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:39:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37898 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758020Ab0CKOjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:39:44 -0500
Subject: Re: ATA 4 KiB sector issues.
From: James Bottomley <James.Bottomley@suse.de>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Nikanth Karthikesan <knikanth@suse.de>,
       Damian Lukowski <damian@tvk.rwth-aachen.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Mark Lord <kernel@teksavvy.com>,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       aschnell@suse.de, jdelvare@suse.de
In-Reply-To: <472A4C80-30CE-4875-8073-F7E61659B6F0@mit.edu>
References: <4B947393.2050002@kernel.org>
	 <4B97C6A5.4010209@tvk.rwth-aachen.de>
	 <17BB1CC0-9B13-401D-B6AA-90365208A042@mit.edu>
	 <201003111927.24829.knikanth@suse.de>
	 <472A4C80-30CE-4875-8073-F7E61659B6F0@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 08:39:34 -0600
Message-ID: <1268318374.2798.2.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 09:28 -0500, Theodore Tso wrote:
> On Mar 11, 2010, at 8:57 AM, Nikanth Karthikesan wrote:
> > 
> > I guess, what he meant was, to keep filesystem blocks aligned, even if the 
> > partition is not. Say if the partition is mis-aligned by 512-bytes, let the 
> > filesystem waste 4k-512bytes and keep it's blocks aligned. But it might be a 
> > case of over-engineering, possibly requiring disk format change.
> 
> Ah, yes, I agree with you; that's probably what he meant.
> 
> Sure, that's theoretically possible, but it would mean changing every
> single filesystem, and it would require a file system format change
> --- or at least a file system format extension.
> 
> It would seem to be way easier to simply fix the partitioning tools to
> do the right thing, though.

Actually, it's a layering violation.  The filesystem shouldn't need to
probe the device layout ... particularly when there are complexities
like is it logical 512 or physical, and if logical 512 on 4k does it
have an offset exponent or not.

We can transmit certain abstractions of information up the stack (like
stripe width for RAID arrays which should be the fs optimal write size),
but for this type of alignment, which can be completely solved at the
partition layer, the information should really stay there and the
filesystem should "just work".

James


