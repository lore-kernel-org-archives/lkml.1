Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbZBPEa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbZBPEa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 23:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbZBPEaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 23:30:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35290 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755948AbZBPEaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 23:30:18 -0500
Message-ID: <4998EBB7.9000203@redhat.com>
Date: Sun, 15 Feb 2009 22:29:43 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>,
       =?ISO-8859-1?Q?Fernando_Luis_V=E1zq?= =?ISO-8859-1?Q?uez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
       Ric Wheeler <rwheeler@redhat.com>
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
References: <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp> <20090119120349.GA10193@duck.suse.cz> <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp> <20090128095518.GA16554@duck.suse.cz> <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp> <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp> <499458C1.90105@redhat.com> <49945C90.3010104@garzik.org> <20090214153626.GA3973@infradead.org> <1234682606.19783.222.camel@sebastian.kern.oss.ntt.co.jp> <20090215225427.GH10706@mini-me.lan>
In-Reply-To: <20090215225427.GH10706@mini-me.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Sun, Feb 15, 2009 at 04:23:26PM +0900, Fernando Luis Vázquez Cao wrote:
>> You mentioned "we should integrate this with the barrier settings". Do
>> you imply we should make it a per-device tunable too? Should we keep the
>> barrier-related mount options some filesystems provide?
>>
> 
> Making barriers to be a per-device tunable makes sense.  The only
> reason why we kept it as a mount option in ext4 is for benchmarking
> purposes, and in ext3, because the filesystem predated the barrier
> code, and there was a desire to be able to benchmark with and without
> the old behavior --- and because akpm is still worried about the
> performance hit of the barrier code, so he's been resistant about
> change the default for ext3.
> 
>        	   				- Ted

I agree that making barriers a per-device tunable probably does make the
most sense.  And talking w/ Dave, he points out that if it were this
way, the fs could just issue barrier IOs at every appropriate place, and
the bdev would just ignore them if they got tuned off, instead of the
current fs world of trying a barrier, always watching out for
-EOPNOTSUPP coming back up, then disabling barriers, etc.

-Eric
