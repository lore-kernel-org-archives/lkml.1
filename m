Return-Path: <linux-kernel-owner+w=401wt.eu-S1161202AbXDMXcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161202AbXDMXcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 19:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161260AbXDMXcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 19:32:46 -0400
Received: from smtp.osdl.org ([65.172.181.24]:60828 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161202AbXDMXcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 19:32:45 -0400
Date: Fri, 13 Apr 2007 16:32:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Jason Lunz <lunz@falooley.org>, Cameron Schaus <cam@schaus.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20 OOM with 8Gb RAM
Message-Id: <20070413163242.7d9283e1.akpm@linux-foundation.org>
In-Reply-To: <20070413225433.GV2986@holomorphy.com>
References: <20070412173830.GA31323@schaus.ca>
	<20070412121553.c7fd3249.akpm@linux-foundation.org>
	<20070413223935.GA6783@metaxa.reflex>
	<20070413154653.21fdb914.akpm@linux-foundation.org>
	<20070413225433.GV2986@holomorphy.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 15:54:33 -0700
William Lee Irwin III <wli@holomorphy.com> wrote:

> On Fri, Apr 13, 2007 at 03:46:53PM -0700, Andrew Morton wrote:
> > It's just weird - it exploits internal knowledge of VFS behaviour, diddles
> > with pagecache within a fake disk strategy handler, etc.
> > Furthermore, because it pretends to be a block device, the VFS will not use
> > highmem pages when accessing the ramdisk.  So the 8GB machine will go splat
> > with only 800MB of ramdisk.
> > ramfs is much cleaner and does not have that limitation.
> 
> After all this time, bdevs are still lowmem etc. Crying shame.

One would need to hunt down every use of b_data in filesystems and switch
them to kmap the page.

Possibly it could be done on a per-fs basis.
