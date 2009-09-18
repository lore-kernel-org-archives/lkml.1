Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbZIRUwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbZIRUwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758263AbZIRUwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:52:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758231AbZIRUwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:52:38 -0400
Subject: Re: fanotify as syscalls
From: Eric Paris <eparis@redhat.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Jamie Lokier <jamie@shareable.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, viro@zeniv.linux.org.uk, alan@linux.intel.com,
       hch@infradead.org
In-Reply-To: <200909172207.01764.agruen@suse.de>
References: <20090912094110.GB24709@ioremap.net>
	 <1253094537.5213.89.camel@dhcp231-106.rdu.redhat.com>
	 <20090916121708.GD29359@shareable.org>  <200909172207.01764.agruen@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Sep 2009 16:52:08 -0400
Message-Id: <1253307128.2552.21.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-17 at 22:07 +0200, Andreas Gruenbacher wrote:

> From my point of view, "global" events make no sense, and fanotify listeners 
> should register which directories they are interested in (e.g., include "/", 
> exclude "/proc"). This takes care of chroots and namespaces as well.

While I completely agree that most users don't want global events, the
antimalware vendors who today, unprotect and hack the syscall table on
their unsuspecting customer's machines to intercept every read, write,
open, close, mmap, etc syscall want EXACTLY that.  They'd been asking
for a way to get this information for quite some time now.  The largest
vendors in this market have agreed the interface (well, when it was a
socket interface that I talked about for so long) should meet their
needs.

Subtree watching / isn't any different or better, just harder and more
complex to implement.  You still have to exclude /proc and /sys and
everything else.  Just like one must with a global listener.  Still
though, this sounds like an issue for the f_type and f_fsid exclusion
syscall I say I'm still not settled on.  Not and issue with the basis of
fanotify or with the 3 proposed syscalls.

Jamie, do you see a problem with what I have been asking for review on
or see a problem with extending it moving forward?

Linus, do you see the value of 'yet another notification scheme' ?

-Eric

