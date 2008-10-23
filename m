Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbYJWD2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbYJWD2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 23:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbYJWD2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 23:28:39 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:42282 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750785AbYJWD2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 23:28:39 -0400
Date: Wed, 22 Oct 2008 23:28:32 -0400
From: Theodore Tso <tytso@mit.edu>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org, eugene@ibrix.com, msnitzer@ibrix.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: ext3: fix ext3_dx_readdir hash collision handling - Regression
Message-ID: <20081023032832.GE10369@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	linux-kernel@vger.kernel.org, eugene@ibrix.com, msnitzer@ibrix.com,
	akpm@linux-foundation.org, torvalds@linux-foundation.org
References: <20081022093201.GA2227@gentoox2.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022093201.GA2227@gentoox2.trippelsdorf.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 11:32:01AM +0200, Markus Trippelsdorf wrote:
> Commit 6a897cf447a83c9c3fd1b85a1e525c02d6eada7d 
> "ext3: fix ext3_dx_readdir hash collision handling" causes a regression
> when deleting big directories.
> 
> I'm using an ext3 filesystem in data=writeback mode as my root fs.
> When I untar a kernel tarball and then rm -r the files, this is what
> happens on my machine (latest git):
> 
> markus@gentoox2 ~ % tar xjf  linux-2.6.27.2.tar.bz2
> markus@gentoox2 ~ % rm -r linux-2.6.27.2
> rm: cannot remove `linux-2.6.27.2/arch/alpha/include/asm/statfs.h': No such file or directory...

I haven't been able to replicate this.  Does it matter which kernel
tarball you use?  And can you send me the output of "dumpe2fs -h
/dev/hdXX", where hdXX is the device of the filesystem where this was
failing?

Thanks,

						- Ted
