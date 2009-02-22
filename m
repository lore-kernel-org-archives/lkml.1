Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbZBVXmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbZBVXmq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 18:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbZBVXmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 18:42:37 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:58157 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095AbZBVXmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 18:42:37 -0500
Message-ID: <49A1E2D3.9000304@garzik.org>
Date: Sun, 22 Feb 2009 18:42:11 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
       Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
       Fernando Luis V?zquez Cao <fernando@oss.ntt.co.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, fernando@kic.ac.jp,
       Ric Wheeler <rwheeler@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: vfs: Add MS_FLUSHONFSYNC mount flag
References: <20090119120349.GA10193@duck.suse.cz> <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp> <20090128095518.GA16554@duck.suse.cz> <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp> <1234434970.15433.4.camel@sebastian.kern.oss.ntt.co.jp> <499458C1.90105@redhat.com> <20090212212304.GA7935@duck.suse.cz> <499494E2.3060006@redhat.com> <20090213022336.GH6922@mini-me.lan> <20090222141532.GC1586@ucw.cz> <20090222231914.GI17066@mit.edu>
In-Reply-To: <20090222231914.GI17066@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Sun, Feb 22, 2009 at 03:15:33PM +0100, Pavel Machek wrote:
>> Sounds like posix violation to
>> me... '/sys/fsync_does_not_really_sync'?
> 
> It's as much a Posix violation as noatime.  :-)
> 
>> Perhaps it is better done at glibc level? Environment variables
>> already mostly have semantics you want.....
> 
> Environment variables own't allow us to switch fsync's on and off
> while the process is running, so that the system can run "safe" while
> it is on AC mains, but "low power" when on battery.

Overall, for each filesystem, we really should _default_ to a safe mode 
where fsync(2), fdatasync(2), sync_file_range(2) and transaction commits 
are guaranteed to be committed to stable storage -- i.e. SYNC CACHE / 
FLUSH CACHE, a forced unit access (FUA) bit, or guarantee that the 
underlying storage has disabled write-back caching.

Correctness should come before performance.  Linux has not had 
credibility here, in the ATA+ext[23] space at least, and it is embarrassing.

Modern SATA and SCSI disks can do tagged command queueing with the FUA 
bit, which does a lot to mitigate the performance loss seen with a less 
capable "FLUSH CACHE + barrier" setup.

	Jeff




