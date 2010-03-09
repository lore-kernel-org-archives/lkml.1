Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab0CIAsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 19:48:50 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51891 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab0CIAst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 19:48:49 -0500
Date: Tue, 9 Mar 2010 00:48:29 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
Message-ID: <20100309004829.GQ30031@ZenIV.linux.org.uk>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
 <20100308094647.GA14268@elte.hu>
 <20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
 <4B9585BD.6070904@redhat.com>
 <alpine.LFD.2.00.1003081523280.3669@localhost.localdomain>
 <20100309001554.GP30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100309001554.GP30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 12:15:54AM +0000, Al Viro wrote:
> On Mon, Mar 08, 2010 at 03:37:38PM -0800, Linus Torvalds wrote:
> 
> > Of course, you can make /etc unwritable, and that is indeed the 
> > traditional UNIX model of handling namespace security: by just 
> > implementing it as "content security" of the directory.
> > 
> > The sgid and sticky bits can be used to further try to make it more 
> > fine-grained (exactly becuase it is _not_ sufficient to say "you can't 
> > read or write this directory" on a whole-directory basis), and obviously 
> > SELinux has extensions of its own too.
> 
> But that's not what the apparmor et.al. are doing.  If you want (and that's
> not obviously a good thing) fine-grained access control for directory
> entries, it would at least make some sense.  Prohibitively pricy, probably,
> but that's a separate story.  But they are *NOT* protecting /foo/bar directory
> entry when you want to protect /foo/bar/baz/barf; it doesn't go up towards
> root.
> 
> And if you *do* protect each ancestor and try to keep granularity, you'll
> end up with complexity from hell.

BTW, if you actually look at apparmor (I'd suggest tomoyo, but I'm not _that_
sadistic), you'll see how seriously do they take pathname-based *anything*.
LSM hooks for namespace operations (you know, mount, umount) are lousy, but
they exist.  Not used by apparmor.
