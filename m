Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbYLAQqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbYLAQqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 11:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbYLAQpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 11:45:54 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:36886 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbYLAQpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 11:45:53 -0500
Subject: Re: [rfc git patch] union directory
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: bharata@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org, jblunck@suse.de,
       dlezcano@fr.ibm.com, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
In-Reply-To: <E1L6Skx-0007uK-3H@pomaz-ex.szeredi.hu>
References: <E1L616K-0005v3-Uc@pomaz-ex.szeredi.hu>
	 <20081128161921.GA3843@in.ibm.com>  <E1L6Skx-0007uK-3H@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 11:24:39 -0500
Message-Id: <1228148679.25837.77.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-11-29 at 17:33 +0100, Miklos Szeredi wrote:
> On Fri, 28 Nov 2008, Bharata B Rao wrote:
> > On Fri, Nov 28, 2008 at 12:01:32PM +0100, Miklos Szeredi wrote:
> > > I've been doing some small fixing/cleanup work on the union directory
> > > patches by Jan, and just noticed there's a thread about the union
> > > mounts on LKML, so I thought publicizing won't hurt.
> > 
> > Interesting that you call it "union directory", do you have plans to go
> > the Plan 9's way of union directories ?
> 
> I think yes, although I never tried Plan9 and don't know the details
> of the union directory semantics.
> 
> At first we thought of providing completely read-only unioning (no
> whiteouts, no object creation/removal).  This gets rid of a _lot_ of
> complexity.

While this removes a lot of complexity it also makes it unusable for
what most people are using UnionFS and AUFS for today. If you want
people to use and test the code whiteouts and object creation/removal
have to be there from the start or you wont see the LiveCD and thin
client people trying it. Considering they make up the overwhelming
majority of the users of union directories/mounts it seems important to
have them on board.

> 
> > > It's still a work in progress, notably the readdir code currently only
> > > works on a few specific filesystem types.
> > 
> > readdir was one of the things on which we couldn't reach a consensus
> > on how to do it the right way. We were suggested that we move the
> > duplicate elimination into user space and an effort towards this was
> > also done (Ref: http://lkml.org/lkml/2008/4/29/248) by moving this
> > to glibc readdir. But we weren't sure how this could work for NFS and
> > were told that it is required to get the NFS side of things
> > sorted out first. So that's where readdir effort stands now afaik.
> > Do you have any ideas/plans on this front ?
> 
> The plan is to get a simple kernel implementation first which caches
> the directory in 'struct file'.
> 
> Long term we'll see.  Maybe the userspace implementation is worth
> persuing as well for a more "kernel memory friendly" implementation.
> 
> Thanks,
> Miklos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

