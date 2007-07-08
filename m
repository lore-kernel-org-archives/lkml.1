Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbXGHSOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbXGHSOE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 14:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbXGHSNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 14:13:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51516 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754776AbXGHSNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 14:13:53 -0400
Date: Sun, 8 Jul 2007 11:12:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: Al Viro <viro@ftp.linux.org.uk>,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6(mm1) Unable to handle kernel NULL pointer dereference
 - git-bisect result
In-Reply-To: <469121DA.6030600@redhat.com>
Message-ID: <alpine.LFD.0.999.0707081058120.31544@woody.linux-foundation.org>
References: <20070708051452.GA4140@gentoox2.trippelsdorf.de>
 <20070708012016.455ce8d5.akpm@linux-foundation.org>
 <20070708100911.GA4196@gentoox2.trippelsdorf.de> <20070708152808.GA5902@gentoox2.trippelsdorf.de>
 <469119A3.6030409@redhat.com> <20070708173416.GG21668@ftp.linux.org.uk>
 <469121DA.6030600@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 8 Jul 2007, Ulrich Drepper wrote:
> 
> But the real permissions tests are performed in notify_change.  I think
> all this is consistent with how, for instance, fchmod works.  The
> additional tests in fchmod which aren't here (IS_RDONLY and IS_APPEND)
> would also apply to the case where a file name is given.  So, either the
> code was inconsistent already are these tests are really not needed.

No.

notify_change() does *not* do permission checks for 
ATTR_CTIME/MTIME/ATIME.

It does them for the "xxx_SET" attributes, but MTIME/ATIME is expected to 
change when other things change, so notify_change() expects that those 
_other_ changes have been validated from a security standpoint!

utimes() is special.

		Linus
