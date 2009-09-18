Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbZIRWBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbZIRWBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 18:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758704AbZIRWBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 18:01:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:40011 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758700AbZIRWBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 18:01:03 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs / Novell
To: Eric Paris <eparis@redhat.com>
Subject: Re: fanotify as syscalls
Date: Sat, 19 Sep 2009 00:00:43 +0200
User-Agent: KMail/1.9.9
Cc: Jamie Lokier <jamie@shareable.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, viro@zeniv.linux.org.uk, alan@linux.intel.com,
       hch@infradead.org
References: <20090912094110.GB24709@ioremap.net> <200909172207.01764.agruen@suse.de> <1253307128.2552.21.camel@dhcp231-106.rdu.redhat.com>
In-Reply-To: <1253307128.2552.21.camel@dhcp231-106.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909190000.43556.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 18 September 2009 22:52:08 Eric Paris wrote:
> On Thu, 2009-09-17 at 22:07 +0200, Andreas Gruenbacher wrote:
> > From my point of view, "global" events make no sense, and fanotify
> > listeners should register which directories they are interested in (e.g.,
> > include "/", exclude "/proc"). This takes care of chroots and namespaces
> > as well.
>
> While I completely agree that most users don't want global events, the
> antimalware vendors who today, unprotect and hack the syscall table on
> their unsuspecting customer's machines to intercept every read, write,
> open, close, mmap, etc syscall want EXACTLY that.

I understand that "global" is what those guys get today for lack of a 
reasonable mechanism, but it's not what anybody can ge given by fanotify: it 
conflicts with filesystem namespaces.

Consider running several "virtual machines" in separate namespaces on the same 
kernel. With "global" you are forced to run the same global fanotify 
listeners everywhere; with per-mount-point listeners, you can choose 
between "global" and something more fine-grained by identifying which 
vfsmounts you are interested in. (Filesystem namespaces correspond to 
vfsmount hierarchies.)

> [...] You still have to exclude /proc and /sys and everything else.

Those are mount points, and so convenient to handle with a per-mount-point 
mechanism. No additional kernel code needed.

> [...] Still though, this sounds like an issue for the f_type and f_fsid
> exclusion syscall I say I'm still not settled on.

Those are also obsolete with a per-mount-point mechanism.

Thanks,
Andreas
