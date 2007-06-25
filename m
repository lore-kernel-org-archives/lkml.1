Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbXFYAZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbXFYAZU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 20:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXFYAZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 20:25:09 -0400
Received: from lilly.ping.de ([83.97.42.2]:4983 "HELO lilly.ping.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751226AbXFYAZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 20:25:08 -0400
Date: Mon, 25 Jun 2007 02:23:15 +0200
From: Patrick Mau <mau@oscar.ping.de>
To: Carlo Wood <carlo@alinoe.com>, Justin Piszcz <jpiszcz@lucidpixels.com>,
       Michael Tokarev <mjt@tls.msk.ru>,
       "Dr. David Alan Gilbert" <linux@treblig.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Manoj Kasichainula <manoj@io.com>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: SATA RAID5 speed drop of 100 MB/s
Message-ID: <20070625002315.GA29405@oscar.prima.de>
References: <20070622214859.GC6970@alinoe.com> <467CC5C5.6040201@garzik.org> <20070623125316.GB26672@alinoe.com> <467DA1F5.2060306@garzik.org> <467E5C5E.6000706@msgid.tls.msk.ru> <20070624125957.GA28067@gallifrey> <Pine.LNX.4.64.0706241021030.12207@p34.internal.lan> <467E9356.1030200@msgid.tls.msk.ru> <Pine.LNX.4.64.0706241257190.12207@p34.internal.lan> <20070624220723.GA21724@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070624220723.GA21724@alinoe.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 12:07:23AM +0200, Carlo Wood wrote:
> On Sun, Jun 24, 2007 at 12:59:10PM -0400, Justin Piszcz wrote:
> > Concerning NCQ/no NCQ, without NCQ I get an additional 15-50MB/s in speed 
> > per various bonnie++ tests.
> 
> There is more going on than a bad NCQ implementation of the drive imho.
> I did a long test over night (and still only got two schedulers done,
> will do the other two tomorrow), and the difference between a queue depth
> of 1 and 2 is DRAMATIC.
> 
> See http://www.xs4all.nl/~carlo17/noop_queue_depth.png
> and http://www.xs4all.nl/~carlo17/anticipatory_queue_depth.png

Hi Carlo,

Have you considered using "blktrace" ?

It enables you to gather data of all seperate requests queues
and will also show you the mapping of bio request from /dev/mdX
to the individual physical disk.

You can also identify SYNC and BARRIER flags for requests,
that might show you why the md driver will sometimes wait
for completion or even REQUEUE if the queue is full.

Just compile your kernel with CONFIG_BLK_DEV_IO_TRACE
and pull the "blktrace" (and "blockparse") utility with git.

The git URL is in the Kconfig help text.

You have to mount, debugfs (automatically selected by IO trace).
I just want to mention, because I did not figure it at first ;)

You should of course use a different location for the output
files to avoid an endless flood of IO.

Regards,
Patrick

PS: I know, I talked about blktrace twice already ;)

