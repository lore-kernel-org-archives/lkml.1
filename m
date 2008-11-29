Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbYK2Qdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbYK2Qdp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 11:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbYK2Qdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 11:33:36 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60243 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbYK2Qdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 11:33:35 -0500
To: bharata@linux.vnet.ibm.com
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, jblunck@suse.de,
       dlezcano@fr.ibm.com, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
In-reply-to: <20081128161921.GA3843@in.ibm.com> (message from Bharata B Rao on
	Fri, 28 Nov 2008 21:49:21 +0530)
Subject: Re: [rfc git patch] union directory
References: <E1L616K-0005v3-Uc@pomaz-ex.szeredi.hu> <20081128161921.GA3843@in.ibm.com>
Message-Id: <E1L6Skx-0007uK-3H@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 29 Nov 2008 17:33:19 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2008, Bharata B Rao wrote:
> On Fri, Nov 28, 2008 at 12:01:32PM +0100, Miklos Szeredi wrote:
> > I've been doing some small fixing/cleanup work on the union directory
> > patches by Jan, and just noticed there's a thread about the union
> > mounts on LKML, so I thought publicizing won't hurt.
> 
> Interesting that you call it "union directory", do you have plans to go
> the Plan 9's way of union directories ?

I think yes, although I never tried Plan9 and don't know the details
of the union directory semantics.

At first we thought of providing completely read-only unioning (no
whiteouts, no object creation/removal).  This gets rid of a _lot_ of
complexity.

> > It's still a work in progress, notably the readdir code currently only
> > works on a few specific filesystem types.
> 
> readdir was one of the things on which we couldn't reach a consensus
> on how to do it the right way. We were suggested that we move the
> duplicate elimination into user space and an effort towards this was
> also done (Ref: http://lkml.org/lkml/2008/4/29/248) by moving this
> to glibc readdir. But we weren't sure how this could work for NFS and
> were told that it is required to get the NFS side of things
> sorted out first. So that's where readdir effort stands now afaik.
> Do you have any ideas/plans on this front ?

The plan is to get a simple kernel implementation first which caches
the directory in 'struct file'.

Long term we'll see.  Maybe the userspace implementation is worth
persuing as well for a more "kernel memory friendly" implementation.

Thanks,
Miklos
