Return-Path: <linux-kernel-owner+w=401wt.eu-S1753749AbXIUAkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbXIUAkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 20:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbXIUAkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 20:40:39 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52189 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751000AbXIUAki (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 20:40:38 -0400
Date: Fri, 21 Sep 2007 10:40:29 +1000
From: David Chinner <dgc@sgi.com>
To: Ramon Chimeno <ramon.chimeno@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Disk I/O degraded performance
Message-ID: <20070921004029.GC995458@sgi.com>
References: <c424c7d0709191309s283a255au9e6841634c18204c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c424c7d0709191309s283a255au9e6841634c18204c@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 10:09:12PM +0200, Ramon Chimeno wrote:
> Hi all
> 
> I migrated one of my server from kernel 2.6.18 to the latest 2.6.22
> and I experienced lower disk performance for processes that open file
> with the O_DIRECT flag.
> 
> I did a very simple test program that opens two files with O_DIRECT
> flag and reads the files to end. I monitored the time spent to read
> the files and I have ~ 40% of difference between 2.6.18 and 2.6.22.
> 
> For information, the files are stored on a XFS partition which is part
> of a software raid-5 block device (the raid-5 is made with 3 SATA
> drives).

Start by eliminating the filesystem. i.e. run the same test using
different offsets on the raw device (e.g. seek one fd a few gigabytes
further into the disk than the other then start reading).

Also, you might want to check that you are comparing apples to apples;
are the two files you used in each test the same? If not, are
they all unfragmented, in the same AGs (i.e. all on the same area of
disk as there's a 2x speed difference betweem the inner and outer edges),
etc....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
