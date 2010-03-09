Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab0CILSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 06:18:06 -0500
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:50034 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754541Ab0CILSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 06:18:01 -0500
Date: Tue, 9 Mar 2010 22:15:23 +1100
From: Dave Chinner <david@fromorbit.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Karel Zak <kzak@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, Jim Meyering <jim@meyering.net>,
       Neil Brown <neilb@suse.de>
Subject: Re: ATA 4 KiB sector issues.
Message-ID: <20100309111523.GL28189@discord.disaster>
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net> <170fa0d21003081134g491034e5v4aad4d43853e48ec@mail.gmail.com> <4B95F071.3070400@msgid.tls.msk.ru> <20100309100153.GD18077@nb.net.home> <4B961FE1.5040105@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B961FE1.5040105@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 01:16:01PM +0300, Michael Tokarev wrote:
> Karel Zak wrote:
> > I did almost all my tests with scsi_debug or MD RAID0 on scsi_debug.
> > It works as expected.
> 
> Actually, for raid0, the alignment is questionable.  Should it be a
> multiple of chunk size or whole stripe size?  I'm not sure, both ways
> has bad and good sides..  But if it is the latter, the same issues
> pops up again: do a 3-disk raid0 and you'll have to align to 3*2^N.

Yes, alignment is still needed, especially for filesystems that can
do stripe unit aligned allocation like XFS. If you don't align the
filesystem properly, all the data IO will be mis-aligned to the
underlying disks and stripe unit sized IO will hit multiple disks
rather than just one....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
