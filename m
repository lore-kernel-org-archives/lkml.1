Return-Path: <linux-kernel-owner+w=401wt.eu-S1030826AbXDQTBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030826AbXDQTBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 15:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030844AbXDQTBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 15:01:00 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:48060 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030826AbXDQTA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 15:00:59 -0400
To: serue@us.ibm.com
CC: linuxram@us.ibm.com, devel@openvz.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, viro@ftp.linux.org.uk,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       haveblue@us.ibm.com
In-reply-to: <20070417181500.GD14891@sergelap.austin.ibm.com>
	(serue@us.ibm.com)
Subject: Re: [Devel] Re: [patch 05/10] add "permit user mounts in new namespace" clone flag
References: <20070412203208.GG27772@sergelap.austin.ibm.com> <m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com> <1176713221.9488.17.camel@ram.us.ibm.com> <E1HdNZn-0006i9-00@dorka.pomaz.szeredi.hu> <1176716941.9488.57.camel@ram.us.ibm.com> <E1HdNwV-0006l2-00@dorka.pomaz.szeredi.hu> <1176743669.9488.62.camel@ram.us.ibm.com> <E1HdVLi-0007oe-00@dorka.pomaz.szeredi.hu> <20070417170737.GA14891@sergelap.austin.ibm.com> <E1Hdrir-0002E8-00@dorka.pomaz.szeredi.hu> <20070417181500.GD14891@sergelap.austin.ibm.com>
Message-Id: <E1HdstF-0002Nn-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 17 Apr 2007 20:58:57 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > mount --make-rshared /
> > mkdir -p /mnt/ns/$USER
> > mount --rbind / /mnt/ns/$USER
> > mount --make-rslave /mnt/ns/$USER
> 
> This was my main point - that the tree in which users can mount will be
> a slave of /, so that propagating the "are user mounts allowed" flag
> among peers is safe and intuitive.

I think it's equally intuitive if flags are not propagated.  After
all, I may want to set the mount flag _only_ on this particular mount,
and not anything else.

This is something I wouln't be sure about either way without
consulting the man.

> True.  But the kernel functionality you provide enables both ways so no
> problem in either case :)
> 
> > Another point: user mounts under /proc and /sys shouldn't be allowed.
> > There are files there (at least in /proc) that are seemingly writable
> > by the user, but they are still not writable in the sense, that
> > "normal" files are.
> 
> Good point.
> 
> > Anyway, there are lots of userspace policy issues, but those don't
> > impact the kernel part.
> 
> Though it might make sense to enforce /proc and /sys not allowing user
> mounts under them in the kernel.

I think not, it would just be another policy decision having to be
made in the kernel on an fs by fs basis, and getting it wrong would be
much worse than getting it wrong in userspace.

Miklos
