Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbZAUWHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbZAUWHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 17:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbZAUWHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 17:07:21 -0500
Received: from thunk.org ([69.25.196.29]:39490 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855AbZAUWHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 17:07:20 -0500
Date: Wed, 21 Jan 2009 15:46:46 -0500
From: Theodore Tso <tytso@mit.edu>
To: Victor Pelt <victor.pelt@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ext4 no space left
Message-ID: <20090121204645.GB9088@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Victor Pelt <victor.pelt@gmail.com>, linux-kernel@vger.kernel.org
References: <576cb9750901210619u3d2abfdclb818f0946f7bc663@mail.gmail.com> <20090121145513.GH31253@mit.edu> <576cb9750901210718u32aa98ecy87e7298a0f3444f@mail.gmail.com> <20090121170423.GJ31253@mit.edu> <576cb9750901211015g3c8813e6md7c0cdd88b9dada1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <576cb9750901211015g3c8813e6md7c0cdd88b9dada1@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 07:15:26PM +0100, Victor Pelt wrote:
> upgrading to 2.6.29-rc2-git1 did allow me to use most of the space but
> i still can't quite use all of it. maybe this is to be expected.

No, it's not to be expected.  You should be able to use everything up
to 100% of what is reported by df.  There is the 5% reserved blocks
which only root is allowed to use, but df takes that into account.  So
if you can't use that last 62944k reported by df after a reboot, and
df -i reports enough inodes, that's definitely a bug in ext4.

Would you be willing to send me a compressed raw e2image file?  You
can generate it as follows:

    e2image -r /dev/hda2 - | bzip2 > /tmp/hda2.e2i.bz2

Ideally this should be done while the filesystem is unmounted, or
mounted read-only. 

It will give me a copy of the filesystem metadata, but no data blocks.
That will allow me to try to replicate the problem on my system.  It
will probably be still too large e-mail, so if you can put it up on
some web or ftp server, and send me the URL, that would be best.

Thanks!!

							- Ted
