Return-Path: <linux-kernel-owner+w=401wt.eu-S1759787AbYAYTSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759787AbYAYTSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 14:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbYAYTSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 14:18:46 -0500
Received: from ns2.suse.de ([195.135.220.15]:48791 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbYAYTSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 14:18:45 -0500
Date: Fri, 25 Jan 2008 11:16:48 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] driver core patches against 2.6.24
Message-ID: <20080125191648.GA22985@suse.de>
References: <20080125071127.GA4860@kroah.com> <alpine.LFD.1.00.0801251035150.2979@hp.linux-foundation.org> <20080125185213.GA23475@suse.de> <alpine.LFD.1.00.0801251108480.2979@hp.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801251108480.2979@hp.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 11:11:48AM -0800, Linus Torvalds wrote:
> 
> 
> On Fri, 25 Jan 2008, Greg KH wrote:
> > 
> > That's really wierd, I don't see that at all here just running with your
> > 2.6.24 + my git tree and lots of USB drivers built into the kernel also
> > (like ehci_hcd).
> 
> But do you use an initrd that tries to load the same driver too?
> 
> I'm too lazy to want to do my own initrd. I just use the prepackaged ones 
> and rely on the fact that my private kernel will refuse to load modules 
> that aren't meant for it anyway.

No, I don't use any initrd at all.

You should just get a message saying that the version magic doesn't
match, so the initrd modules will not load.  That's what happens to me
when I try to force old modules to load.

> > $ cat /proc/sys/kernel/tainted
> > 0
> 
> Mine says "2".
> 
> > $ uname -r
> > 2.6.24-ge374a2bf-dirty
> > 
> > Strange, I thought that the uname id would show the git version that you
> > were running, but that doesn't show a valid id.  But that's probably a
> > different issue in the build system somewhere...
> 
> That *is* the git version you're running: e374a2bf.
> 
> The "-g" is for "git" and the "-dirty" is because you have some 
> non-checked-in changes in addition.
> 
> I works for me:
> 
> 	[torvalds@hp linux]$ git show --abbrev-commit -s --pretty=oneline e374a2bf
> 	e374a2b... Kobject: fix coding style issues in kobject c files
> 
> so that looks like a valid version..

Ah taking the "g" off the search works, didn't realize that.

And I didn't have any unchecked in files, 'git status' shows no modified
files, but other stuff in the main directory, like patches that
shouldn't matter, but perhaps they do.
But oh well, I'm still building your tree now to try to reproduce
this...

thanks,

greg k-h
