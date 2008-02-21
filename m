Return-Path: <linux-kernel-owner+w=401wt.eu-S935037AbYBUQwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935037AbYBUQwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757010AbYBUQw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:52:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57521 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451AbYBUQw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:52:28 -0500
Date: Thu, 21 Feb 2008 08:52:14 -0800
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc2-git4 BUG: sysfs_readdir
Message-ID: <20080221165214.GA30606@kroah.com>
References: <20080221082553.ddc4e723.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080221082553.ddc4e723.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 08:25:53AM -0800, Randy Dunlap wrote:
> One of my (x86_64) test machines got this on booting 2.6.25-rc2-git4.
> 
> insmod used greatest stack depth: 4144 bytes left
> EXT3-fs: INFO: recovery required on readonly filesystem.
> EXT3-fs: write access will be enabled during recovery.
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs: recovery complete.
> EXT3-fs: mounted filesystem with ordered data mode.
> modprobe used greatest stack depth: 3600 bytes left
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> IP: [<ffffffff802d0f16>] sysfs_readdir+0xe0/0x13f

That's really wierd, as nothing has changed in this area in a while now.
did 2.6.25-rc2 work for you ok?

Can you enable CONFIG_DEBUG_KOBJECT and see if the kernel log shows you
what is happening here?  Hm, that's only going to tell you what files
were created, not what was being read from sysfs...

How about adding the patch at:
	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver/sysfs-crash-debugging.patch
which has been in -mm for forever that will add the last-accessed sysfs
file to the oops report.  That might give us more information here.

thanks,

greg k-h
