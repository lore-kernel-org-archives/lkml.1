Return-Path: <linux-kernel-owner+w=401wt.eu-S1760796AbXI1CW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760796AbXI1CW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 22:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbXI1CWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 22:22:16 -0400
Received: from thunk.org ([69.25.196.29]:39910 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbXI1CWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 22:22:15 -0400
Date: Thu, 27 Sep 2007 22:21:18 -0400
From: Theodore Tso <tytso@mit.edu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Correct SuS compliance for open of large file without options
Message-ID: <20070928022118.GF8688@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jens Axboe <jens.axboe@oracle.com>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070927154432.302ec5a7@the-village.bc.nu> <20070927150853.GA10154@kernel.dk> <20070927161912.2f08aff6@the-village.bc.nu> <20070927155902.GA6450@thunk.org> <20070927102343.1a113ccc.akpm@linux-foundation.org> <20070927175917.GB8339@kroah.com> <20070927183742.GA23734@thunk.org> <20070927213445.GA7857@kroah.com> <20070927231927.GE8688@thunk.org> <20070927232857.GA12049@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927232857.GA12049@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 05:28:57PM -0600, Matthew Wilcox wrote:
> On Thu, Sep 27, 2007 at 07:19:27PM -0400, Theodore Tso wrote:
> > Would you accept a patch which causes the deprecated sysfs
> > files/directories to disappear, even if CONFIG_SYS_DEPRECATED is
> > defined, via a boot-time parameter?
> 
> How about a mount option?  That way people can test without a reboot:
> 
> mount -o remount,deprecated={yes,no} /sys

It would be nice if that would be easy to make work, but the problem
is that remounting /sysfs doesn't change the entries in the sysfs tree
that have already been made in the tree.  We could do something such
as creating an sysfs_create_link_deprecated() call which created a
kobject with a new flag indicating it's deprecated, so it could be
filtered out dynamically when /sys is remounted, or when some file
such as /sys/kernel/deprecated_sysfs_files has "0" or "1" written to
it.

The question is whether it's worth it, since we'd have to bloat the
kobject structure by 4 bytes (it currently doesn't have a flags field
from which we could borrow a bit), or whether it's OK just to make the
user reboot.  (I do agree it would be nicer if the user didn't have to
reboot, but most of the time they will need to test the initrd and
init scripts anyway.

							- Ted
