Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbYLAEf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbYLAEf0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 23:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYLAEfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 23:35:11 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43235 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbYLAEfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 23:35:09 -0500
Date: Mon, 1 Dec 2008 10:05:09 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, jblunck@suse.de, dlezcano@fr.ibm.com,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: [rfc git patch] union directory
Message-ID: <20081201043509.GA3388@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <E1L616K-0005v3-Uc@pomaz-ex.szeredi.hu> <20081128161921.GA3843@in.ibm.com> <E1L6Skx-0007uK-3H@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1L6Skx-0007uK-3H@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2008 at 05:33:19PM +0100, Miklos Szeredi wrote:
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

FYI, I did this for a version of Union Mount.
(http://lkml.org/lkml/2007/6/20/21) I was maintaining the readdir cache in
struct file and the cache was persistant across readdir calls.

Do you have anything different in mind ?

Also all our readdir discussions have kind of terminated with how
it could provide a correct directory seek behaviour. I was thinking
that we could dis-allow seek on union mounted directories
but was told that it is important to provide proper seek for
union mounted directories. So do you plan to address this seek problem
in your simple/first readdir implementation ?

Regards,
Bharata.
