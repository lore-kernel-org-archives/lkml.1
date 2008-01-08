Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbYAHQ20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbYAHQ20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbYAHQ15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:27:57 -0500
Received: from mail.gmx.net ([213.165.64.20]:50945 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753867AbYAHQ14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:27:56 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Op7Q+cdVOO2TPu+jqAZuiyrO9TWZSN2c+ZPKtO4
	MBrEZ5frdAmBYn
Subject: Re: [vm] writing to UDF DVD+RW (/dev/sr0) while under memory
	pressure: box ==> doorstop
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1199805713.3571.12.camel@homer.simson.net>
References: <1199447212.4529.13.camel@homer.simson.net>
	 <1199612533.4384.54.camel@homer.simson.net>
	 <1199642470.3927.12.camel@homer.simson.net>
	 <20080106122954.d8f04c98.akpm@linux-foundation.org>
	 <1199790316.4094.57.camel@homer.simson.net>
	 <20080108033801.40d0043a.akpm@linux-foundation.org>
	 <1199805713.3571.12.camel@homer.simson.net>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 16:27:51 +0100
Message-Id: <1199806071.4174.2.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-08 at 16:21 +0100, Mike Galbraith wrote:
> On Tue, 2008-01-08 at 03:38 -0800, Andrew Morton wrote:
> > 
> > Well.  From your earlier trace it appeared that something was causing
> > the filesystem to perform synchronous inode writes - sync_dirty_buffer() was
> > called.
> > 
> > This will cause many more seeks than would occur if we were doing full
> > delayed writing, with obvious throughput implications.
> 
> Yes, with UDF, the IO was _incredibly_ slow.  With ext2, it was better,
> though still very bad.  I tested with that other OS, and it gets ~same
> throughput with UDF as I got with ext2 (ick).
> 
> UDF does udf_clear_inode() -> write_inode_now(inode, 1)
> 
> I suppose I could try write_inode_now(inode, 0).  Might unstick the box.

(nope, still sync, UDF still deadly)

