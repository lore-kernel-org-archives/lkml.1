Return-Path: <linux-kernel-owner+w=401wt.eu-S1760077AbXI0XUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077AbXI0XUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 19:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754108AbXI0XTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 19:19:52 -0400
Received: from thunk.org ([69.25.196.29]:47039 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbXI0XTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 19:19:51 -0400
Date: Thu, 27 Sep 2007 19:19:27 -0400
From: Theodore Tso <tytso@mit.edu>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Correct SuS compliance for open of large file without options
Message-ID: <20070927231927.GE8688@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Greg KH <greg@kroah.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jens Axboe <jens.axboe@oracle.com>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070927151921.29b19abb@the-village.bc.nu> <20070927143548.GT5243@kernel.dk> <20070927154432.302ec5a7@the-village.bc.nu> <20070927150853.GA10154@kernel.dk> <20070927161912.2f08aff6@the-village.bc.nu> <20070927155902.GA6450@thunk.org> <20070927102343.1a113ccc.akpm@linux-foundation.org> <20070927175917.GB8339@kroah.com> <20070927183742.GA23734@thunk.org> <20070927213445.GA7857@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927213445.GA7857@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 02:34:45PM -0700, Greg KH wrote:
> Ok, how then should I advertise this better?  What can we do better to
> help userspace programmers out in this regard?

Would you accept a patch which causes the deprecated sysfs
files/directories to disappear, even if CONFIG_SYS_DEPRECATED is
defined, via a boot-time parameter?  Many people and distros are
likely to keep CONFIG_SYS_DEPRECATED defined just our of paranoia that
things might break.  Doing a quick google, I note that Fedora has been
going back and forth of turning it off, watching things break, and
then turning it back on.  The latest time, the changelog said:

* Fri Jan 26 23:00:00 2007 Bill Nottingham <notting{%}redhat{*}com>

    - turn on CONFIG_SYSFS_DEPRECATED so that things actually work. *sigh*

(and I've checked, Fedora's CVS still has CONFIG_SYSFS_DEPRECATED
defined; it's not just Debian at fault here.)

So having a boot-time parameter would make it much easier for
application programmers (who run distro kernels and who are unlikely
to want to compile their own custom kernel) to test to see what breaks
without CONFIG_SYS_DEPRECATED.

	   	     	     	      	- Ted
