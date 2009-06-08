Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbZFHWtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbZFHWtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 18:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbZFHWtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 18:49:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60539 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbZFHWtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 18:49:03 -0400
Date: Mon, 8 Jun 2009 15:48:31 -0700
From: Valerie Aurora <vaurora@redhat.com>
To: Jan Rekorajski <baggins@sith.mimuw.edu.pl>, Jan Blunck <jblunck@suse.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz
Subject: Re: [PATCH 00/32] VFS based Union Mount (V3)
Message-ID: <20090608224831.GF24586@fsbox>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <20090521125419.GM30663@sith.mimuw.edu.pl> <20090608195752.GD4363@fsbox> <20090608224406.GA6801@sith.mimuw.edu.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608224406.GA6801@sith.mimuw.edu.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 12:44:06AM +0200, Jan Rekorajski wrote:
> On Mon, 08 Jun 2009, Valerie Aurora wrote:
> 
> > On Thu, May 21, 2009 at 02:54:19PM +0200, Jan Rekorajski wrote:
> > > On Mon, 18 May 2009, Jan Blunck wrote:
> > > 
> > > > Here is another post of the VFS based union mount implementation.
> > > 
> > > Is there any chance this will support NFS? I can union-mount tmpfs over
> > 
> > NFS as the read-only layer ought to work.  NFS as the read-write layer
> > is still up in the air.
> 
> As I don't need rw NFS, i didn't even try that :)
> 
> > > nfs mounted fs, but if I try to mount --union two NFS filesystems I
> > > always get -EBUSY on second mount on the same mountpoint.
> > > 
> > > Something along these lines:
> > > 
> > > doesn't matter if I use --union on first mount, the result is always the
> > > same.
> > > 
> > > mount <--union> -t nfs server:/export/system /mnt
> > > OK
> > > mount --union -t nfs server:/export/profile /mnt
> > > mount.nfs: /mnt is busy or already mounted
> > > 
> > > I patched mount.nfs so it knows about MS_UNION, and strace shows me that
> > > it passes that flag to kernel.
> > 
> > FYI, using --union on the first mount will make it union with the
> > local directory below it.  The --union option is not needed when you
> > mount the lower read-only layer.
> 
> Thanks for clarification.
> 
> > You'll get -EBUSY on the second mount of any NFS file system over
> > another - try it again with the --union flag.  Support for NFS on NFS
> > union mount would have to change this.
> 
> I did just that, --union didn't change standard NFS behaviour.

Er, excuse me - I mean to type "try it again WITHOUT the --union
flag."  My apologies!

> 
> mount -t nfs server:/export/system /mnt
> mount --union -t nfs server:/export/profile /mnt
> mount.nfs: /mnt is busy or already mounted
> 
> I did an experiment by using different IP of the server (same machine)
> when mounting the second fs, mount worked then, but 'ls -1 /mnt' oopsed.
> I can reproduce this and send you the oops next week.

Interesting!  Does this happen without the --union flag?

-VAL
