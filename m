Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbYJDV1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbYJDV1o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 17:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbYJDV1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 17:27:36 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:44730 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753069AbYJDV1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 17:27:35 -0400
Date: Sat, 4 Oct 2008 17:27:21 -0400
From: Theodore Tso <tytso@mit.edu>
To: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081004212721.GA25293@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20081002062736.GR19428@kernel.dk> <20081001235501.2b7f50fe.akpm@linux-foundation.org> <20081002074523.GW19428@kernel.dk> <20081002010315.1cda8147.akpm@linux-foundation.org> <20081002120444.GA25164@mit.edu> <20081002061629.39d5e115@infradead.org> <20081002134659.GC25164@mit.edu> <20081002073304.7f027f52@infradead.org> <20081004141252.GA23398@mit.edu> <20081004171445.GA31780@nineveh.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081004171445.GA31780@nineveh.local>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 04, 2008 at 01:14:45PM -0400, Joseph Fannin wrote:
> On Sat, Oct 04, 2008 at 10:12:52AM -0400, Theodore Tso wrote:
> 
> > Anyway, here's the patch (against ext4, although could pretty easily
> > move this to ext3 --- but you can mount an ext3 filesystem as ext4,
> > although for the moment you do have to run the command "tune2fs -E
> > test_fs /dev/hdXX" first) [...]
> 
> Shouldn't he also be sure to mount the FS with the "noextents" option,
> or has ext4 learned not to to enable extents if they're not already
> enabled?

The latter; ext4 will no longer enable extents if not already enabled
as of commit e4079a11, dated July 11th.  That means 2.6.26 with any of
the ext4 patchsets (highly recommended if you want to use ext4) or any
mainline release post 2.6.26-git4/2.6.27-rc1.

A number of the ext4 tutorials/howto's are available on the web page
are out of date, including the one on IBM developer works.  The best
place to get up-to-date information on using ext4 is
http://ext4.wiki.kernel.org.

Regards,

						- Ted

P.S.  Note that there will be advantages to using even an unconverted
filesystem with the ext3 filesystem format with the ext4 code base,
even if you don't enable extents or any other ext4-specific feature;
the delayed allocation and soon-to-be-added inode table readahead
features (in the 2.6.27-rc8-ext4-2 patchset, and which will be pushed
during the next merge window) in the ext4 code base will improve
performance even on an "ext3 filesystem".
