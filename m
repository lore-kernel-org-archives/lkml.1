Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbYBXBbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbYBXBbk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 20:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbYBXBbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 20:31:32 -0500
Received: from verein.lst.de ([213.95.11.210]:57835 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbYBXBbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 20:31:31 -0500
Date: Sun, 24 Feb 2008 02:31:13 +0100
From: Christoph Hellwig <hch@lst.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ?ric Piel <Eric.Piel@tremplin-utc.net>, len.brown@intel.com,
       Christoph Hellwig <hch@lst.de>, dsdt@gaugusch.at,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, trenn@suse.de
Subject: Re: [PATCH] Use userland-like functions for reading the ACPI table
Message-ID: <20080224013113.GA12512@lst.de>
References: <20080210071226.GA23360@lst.de> <20080210071454.GA23428@lst.de> <47AEE6D1.4070402@tremplin-utc.net> <20080212053730.GA15347@lst.de> <47BDC705.6090902@tremplin-utc.net> <47C07536.6040404@tremplin-utc.net> <alpine.LFD.1.00.0802231232280.21332@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802231232280.21332@woody.linux-foundation.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 12:45:38PM -0800, Linus Torvalds wrote:
> > 
> > As recommended by Christoph Hellwig, even if we can't rely on the userspace
> > firmware loader so early at boot, at least use normal syscall (as in
> > init/do_mounts_*.c). Similarly, use kfree() instead of ACPI_FREE().
> 
> So I'm missing a lot of the background here.
> 
> I don't think "sys_open()" is in any way preferable to the alternatives, 
> especially since it depends on thread-global state (the file descriptor 
> table) rather than much more local state ("struct file" that you've 
> opened).
> 
> I think the calls to sys_open() in init do_dounts etc are very different: 
> they really are more about a real kernel-level almost-user-mode thread 
> than a core driver. 

Well, that's what this code is like aswell.  That's why I recommended
to Eric to move it to init/ and make it look like that code.  I haven't
quite caught up with the discussion yet, but Eric think moving it
there might not be a that good idea.  Having this code in drivers/
even if it's just called in init time is a bad idea, as people will
copy it.  Then again using the functions the code was using before
isn't any better.

