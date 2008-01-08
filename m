Return-Path: <linux-kernel-owner+w=401wt.eu-S1759582AbYAHPWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582AbYAHPWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 10:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbYAHPV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 10:21:58 -0500
Received: from mail.gmx.net ([213.165.64.20]:59079 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754247AbYAHPV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 10:21:57 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/NHkIiToLNIvL5uv8go4PgfFeibsoENQZwittuVf
	dYngtxvVLBOkv3
Subject: Re: [vm] writing to UDF DVD+RW (/dev/sr0) while under memory
	pressure: box ==> doorstop
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080108033801.40d0043a.akpm@linux-foundation.org>
References: <1199447212.4529.13.camel@homer.simson.net>
	 <1199612533.4384.54.camel@homer.simson.net>
	 <1199642470.3927.12.camel@homer.simson.net>
	 <20080106122954.d8f04c98.akpm@linux-foundation.org>
	 <1199790316.4094.57.camel@homer.simson.net>
	 <20080108033801.40d0043a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 16:21:53 +0100
Message-Id: <1199805713.3571.12.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-08 at 03:38 -0800, Andrew Morton wrote:
> On Tue, 08 Jan 2008 12:05:16 +0100 Mike Galbraith <efault@gmx.de> wrote:

> > Seeks on DVD drives are apparently far FAR more horrible that I ever
> > imagined, so writing to a filesystem on a DVD+RW in effect constitutes
> > the stupid thing I was worried about above.  Make an image, populate it,
> > write it instead... sure to be a truckload faster, and due to the VM
> > connection, much safer too.  Oh well.
> > 
> 
> Well.  From your earlier trace it appeared that something was causing
> the filesystem to perform synchronous inode writes - sync_dirty_buffer() was
> called.
> 
> This will cause many more seeks than would occur if we were doing full
> delayed writing, with obvious throughput implications.

Yes, with UDF, the IO was _incredibly_ slow.  With ext2, it was better,
though still very bad.  I tested with that other OS, and it gets ~same
throughput with UDF as I got with ext2 (ick).

UDF does udf_clear_inode() -> write_inode_now(inode, 1)

I suppose I could try write_inode_now(inode, 0).  Might unstick the box.

	-Mike

