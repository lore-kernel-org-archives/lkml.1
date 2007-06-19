Return-Path: <linux-kernel-owner+w=401wt.eu-S1759042AbXFSVIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbXFSVIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 17:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbXFSVIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 17:08:38 -0400
Received: from hera.cwi.nl ([192.16.191.8]:58762 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550AbXFSVIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 17:08:37 -0400
Date: Tue, 19 Jun 2007 23:08:28 +0200
From: Andries Brouwer <Andries.Brouwer@cwi.nl>
To: Karel Zak <kzak@redhat.com>
Cc: Andries Brouwer <Andries.Brouwer@cwi.nl>, linux-kernel@vger.kernel.org
Subject: Re: mount-2.12r-ggk.tar.gz
Message-ID: <20070619210827.GA20366@apps.cwi.nl>
References: <200706191238.l5JCcxg14300@apps.cwi.nl> <20070619141528.GS7226@petra.dvoda.cz> <20070619152818.GA16363@apps.cwi.nl> <20070619185125.GU7226@petra.dvoda.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619185125.GU7226@petra.dvoda.cz>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 08:51:25PM +0200, Karel Zak wrote:
> > >  I don't think that mtab is a good place for this shared subtree
> > >  stuff. The mtab needs to die.
> > 
> > Perhaps. Perhaps not.
> > 
> > On the one hand I think there is a place for arbitrary user-space info
> > about mounted filesystems. With information about who mounted, and at
> > what time. What the icon is that should represent this filesystem.
> > What resources are associated to this mount, and which program must do
> > the cleanup. Etc.
> > Today there is not much user-space info, but there is some.
> 
>  See also the "[RFC] obsoleting /etc/mtab" thread:
>  http://www.mail-archive.com/util-linux-ng@vger.kernel.org/index.html#00208

Good that I am not on that mailing list - I might have spent a lot of time
discussing.

I see that many people agree that there is the need to attach
some metadata to mounts. Good.
But they suggest storing that metadata in the kernel. Bad.
The kernel is not a storage place for random non-kernel-related data.

A good place is a file, like /etc/mtab (I suppose today /var/run/mtab
might be the appropriate place for system-wide mounts, and for
user-private mounts the user can, if she wishes, indicate her
favorite mtab file to use: "mount -M $HOME/foo/mtab3").

And the kernel needs non-procfs interfaces (namely syscalls)
that can tell a process about its mount environment: readmounts()
and statmount(). As soon as mount(8) can ask the kernel, then
the problem of non-up-to-date /etc/mtab, and incomplete /proc/mounts
has gone away.

Andries


[By the way, just like a single flat directory that contains all files
turned out to be a bad idea, a single flat structure that contains
all mounts will turn out soon to be a bad idea too. Some people use
thousands of mounts. So, also mounts must live in a tree-structured space.]


