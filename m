Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbXLDHzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbXLDHzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 02:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbXLDHzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 02:55:31 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:59122
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751288AbXLDHza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 02:55:30 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch] rewrite rd
Date: Tue, 4 Dec 2007 01:55:17 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
References: <20071204042628.GA26636@wotan.suse.de>
In-Reply-To: <20071204042628.GA26636@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712040155.21124.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 December 2007 22:26:28 Nick Piggin wrote:
> There is one slight downside -- direct block device access and filesystem
> metadata access goes through an extra copy and gets stored in RAM twice.
> However, this downside is only slight, because the real buffercache of the
> device is now reclaimable (because we're not playing crazy games with it),
> so under memory intensive situations, footprint should effectively be the
> same -- maybe even a slight advantage to the new driver because it can also
> reclaim buffer heads.

For the embedded world, initramfs has pretty much rendered initrd obsolete, 
and that was the biggest user of the ramdisk code I know of.  Beyond that, 
loopback mounts give you more flexible transient block devices than ramdisks 
do.  (In fact, ramdisks are such an amazing pain to use/size/free that if I 
really needed something like that I'd just make a loopback mount in a ramfs 
instance.)

Embedded users who still want a block interface for memory are generally 
trying to use a cramfs or squashfs image out of ROM or flash, although there 
are flash-specific filesystems for this and I dunno if they're actually 
mounting /dev/mem at an offset or something (md?  losetup -o?  Beats me, I 
haven't tried that myself yet...)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
