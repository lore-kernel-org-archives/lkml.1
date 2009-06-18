Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbZFRDZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbZFRDZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 23:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbZFRDZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 23:25:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbZFRDZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 23:25:08 -0400
Date: Wed, 17 Jun 2009 23:23:57 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jan Rekorajski <baggins@sith.mimuw.edu.pl>, Jan Blunck <jblunck@suse.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz
Subject: Re: [PATCH 00/32] VFS based Union Mount (V3)
Message-ID: <20090618032357.GE15048@shell>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <20090521125419.GM30663@sith.mimuw.edu.pl> <20090608195752.GD4363@fsbox> <20090608224406.GA6801@sith.mimuw.edu.pl> <20090608224831.GF24586@fsbox> <20090615095528.GG4379@sith.mimuw.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615095528.GG4379@sith.mimuw.edu.pl>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 11:55:28AM +0200, Jan Rekorajski wrote:
> On Mon, 08 Jun 2009, Valerie Aurora wrote:
> 
> > On Tue, Jun 09, 2009 at 12:44:06AM +0200, Jan Rekorajski wrote:
> > > On Mon, 08 Jun 2009, Valerie Aurora wrote:
> > > 
> > > > You'll get -EBUSY on the second mount of any NFS file system over
> > > > another - try it again with the --union flag.  Support for NFS on NFS
> > > > union mount would have to change this.
> > > 
> > > I did just that, --union didn't change standard NFS behaviour.
> > 
> > Er, excuse me - I mean to type "try it again WITHOUT the --union
> > flag."  My apologies!
> 
> I did, see below.
> 
> > > 
> > > mount -t nfs server:/export/system /mnt
> > > mount --union -t nfs server:/export/profile /mnt
> > > mount.nfs: /mnt is busy or already mounted
> > > 
> > > I did an experiment by using different IP of the server (same machine)
> > > when mounting the second fs, mount worked then, but 'ls -1 /mnt' oopsed.
> > > I can reproduce this and send you the oops next week.
> > 
> > Interesting!  Does this happen without the --union flag?
> 
> Filesystems are exported ro, all mounts nfs3,ro,tcp.
> 
> Without --union:
> 
> mount -t nfs 10.1.0.4:/nfs/system /mnt -oro,nolock,vers=3,tcp
> OK
> 
> mount -t nfs 10.1.0.4:/nfs/profile /mnt -oro,nolock,vers=3,tcp
> -EBUSY (as expected)
> 
> mount -t nfs 10.1.0.3:/nfs/profile /mnt -oro,nolock,vers=3,tcp
>  (notice different IP - but it's the same machine)
> Works, just overmounts /mnt, ls shown contents of /nfs/profile
> 
> Now, --union:
> 
> mount -t nfs 10.1.0.4:/nfs/system /mnt -oro,nolock,vers=3,tcp
> OK
> 
> mount --union -t nfs 10.1.0.4:/nfs/profile /mnt -oro,nolock,vers=3,tcp
> -EBUSY (/mnt busy or already mounted)
> 
> mount --union -t nfs 10.1.0.3:/nfs/profile /mnt -oro,nolock,vers=3,tcp
>  (notice different IP - but it's the same machine)
> mount command works, ls Oopses:

Sorry for the delay in reply!  This is on our to-do list, thanks for
doing a little more testing.

-VAL
