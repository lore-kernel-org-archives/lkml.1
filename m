Return-Path: <linux-kernel-owner+w=401wt.eu-S1763060AbXKNTvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763060AbXKNTvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758959AbXKNTvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:51:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58262 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbXKNTva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:51:30 -0500
Date: Wed, 14 Nov 2007 11:50:08 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20071114115008.3ab4b534@laptopd505.fenrus.org>
In-Reply-To: <473B4B53.9090507@hp.com>
References: <20071015104647.14e60bc5@laptopd505.fenrus.org>
	<20071015114738.6b5a25c7.akpm@linux-foundation.org>
	<20071015161315.4fe18e07@bree.surriel.com>
	<20071015141236.62b075c6.akpm@linux-foundation.org>
	<473B18BA.5000709@hp.com>
	<20071114091451.d4b110db.akpm@linux-foundation.org>
	<473B4B53.9090507@hp.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007 14:24:03 -0500
"Alan D. Brunelle" <Alan.Brunelle@hp.com> wrote:
> >   
> 
> The test works like this:
> 
>    1. I ensure that the device under test (DUT) is set to run the CFQ
>       scheduler.
>          1. It is a Fibre Channel 72GiB disk
>          2. Single partition...
>    2. Put an Ext3 FS on the partition (mkfs.ext3 -b 4096)
>    3. Mount the device, and then:
>          1. Put an 8GiB file on the new FS
>          2. Put 3 copies of a Linux tree (w/ objs & kernel & such)
> onto the FS in separate directories
>                1. Note: I'm going to do runs with 6 copies to each
>                   directory tree to get to about 4.2GiB per directory
> tree 4. Then, for each of the tests:
>          1. Remount the device (purge page cache by umount & then
> mount) 2. Start up a copy of 1 kernel tree to another tree (you hadn't
>             specified if the copy in the background should be to a new
>             area or not, so I'm just re-using the same area so we
> don't have to worry about removing the old). I keep doing the copy
>             as long as the tests are going
>          3. Perform the test (10 times)
> 
> The tests are:
> 
>     * Linear read of a large file (8GiB)
>     * Tree read (foreach file in the tree, dd it to /dev/null)
>     * Overwrite of that large file: was doing 256KiB random&direct
>       read/writes, will go down to 4KiB read/writes as that is more
>       realistic I'd guess
> 

ok so the obvious meta-question is this: what does it mean that your
test takes longer or shorter. I can see IO "capacity" (trying to avoid
the use bandwidth here) moves from the foreground test to the
background test (and/or other way around)... but if that was starved
previously... it could or could not be the right result.
What do you think the measure of "it's at least not worse" is? Is there
any way to get to that concept? (and then looking at if that got met is
the second step ;( )

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
