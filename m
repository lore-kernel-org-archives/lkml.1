Return-Path: <linux-kernel-owner+w=401wt.eu-S965641AbXDMWq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965641AbXDMWq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965646AbXDMWq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:46:57 -0400
Received: from smtp.osdl.org ([65.172.181.24]:58472 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965641AbXDMWq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:46:56 -0400
Date: Fri, 13 Apr 2007 15:46:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Lunz <lunz@falooley.org>
Cc: Cameron Schaus <cam@schaus.ca>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.20 OOM with 8Gb RAM
Message-Id: <20070413154653.21fdb914.akpm@linux-foundation.org>
In-Reply-To: <20070413223935.GA6783@metaxa.reflex>
References: <20070412173830.GA31323@schaus.ca>
	<20070412121553.c7fd3249.akpm@linux-foundation.org>
	<20070413223935.GA6783@metaxa.reflex>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 18:39:36 -0400
Jason Lunz <lunz@falooley.org> wrote:

> On Thu, Apr 12, 2007 at 12:15:53PM -0700, Andrew Morton wrote:
> > All of ZONE_NORMAL got used by ramdisk, and networking wants to
> > allocate a page from ZONE_NORMAL.  An oom-killing is the correct
> > response, although probably not effective.
> > 
> > ramdisk is a nasty thing - cannot you use ramfs or tmpfs?
> 
> What do you mean by "nasty thing"?

It's just weird - it exploits internal knowledge of VFS behaviour, diddles
with pagecache within a fake disk strategy handler, etc.

Furthermore, because it pretends to be a block device, the VFS will not use
highmem pages when accessing the ramdisk.  So the 8GB machine will go splat
with only 800MB of ramdisk.

ramfs is much cleaner and does not have that limitation.

> I've heard that about loopback too.

loopback does some pretty weird thigns too, but it has more of an excuse:
it is a specialised layering thing, whereas ramdisk is, umm, just a
ramdisk.

> If I want to run a system entirely from ram with a compressed filesystem
> image mounted on /, is it better to store that image in a ramdisk, or on
> a tmpfs and mount it via loopback?

Store it all in ramfs, no loopback needed?
