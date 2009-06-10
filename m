Return-Path: <linux-kernel-owner+w=401wt.eu-S1761756AbZFJVDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761756AbZFJVDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759259AbZFJVCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:02:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46286 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759218AbZFJVCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:02:51 -0400
Date: Wed, 10 Jun 2009 23:02:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stefan Bader <stefan.bader@canonical.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pierre@ossman.eu, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] mmc: prevent dangling block device from accessing
	stale queues
Message-ID: <20090610210247.GC1381@ucw.cz>
References: <4A280BD4.9080908@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A280BD4.9080908@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-04 20:00:52, Stefan Bader wrote:
> Kernel: 2.6.30-rc7 based
> Worked in 2.6.28 (probably only because things went at a different speed)
>
> Testcase: Use ext3/ext4 on a SD card partitioned with one primary DOS 
> partition and leave it mounted while suspend/resume.
>
> Result: After resume the partition table of the SD card has been erased.
>
> The detailed description can be found at:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/383668
>
> In essence the mmc block device frees the generic request queue before 
> the last user of the gendisk has stopped using it leaving an invalid 
> queue pointer which get unfortunately re-used before more requests come 
> in for the old device.
>
> The bugfix will cause more I/O error messages and might not be the 
> ultimate way things should work, but it prevents data from getting lost.

Thanks for finding root cause of this!
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
