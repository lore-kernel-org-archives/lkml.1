Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbYAXWja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbYAXWja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbYAXWjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:39:22 -0500
Received: from colo.lackof.org ([198.49.126.79]:58851 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbYAXWjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:39:21 -0500
Date: Thu, 24 Jan 2008 15:39:04 -0700
From: dann frazier <dannf@dannf.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.4: fix memory corruption from misinterpreted
	bad_inode_ops return values
Message-ID: <20080124223904.GA28495@colo.lackof.org>
References: <20080124061212.GA22079@ldl.fc.hp.com> <20080124195624.GJ8953@1wt.eu> <4798FDF2.3000605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4798FDF2.3000605@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 03:06:58PM -0600, Eric Sandeen wrote:
> Willy Tarreau wrote:
> > Hi Dann,
> > 
> > On Wed, Jan 23, 2008 at 11:12:12PM -0700, dann frazier wrote:
> >> This is a 2.4 backport of a linux-2.6 change by Eric Sandeen
> >> (commit be6aab0e9fa6d3c6d75aa1e38ac972d8b4ee82b8)
> >>
> >> CVE-2006-5753 was assigned for this issue.
> >>
> >> I've built and boot-tested this, but I'm not sure how to exercise
> >> these codepaths.
> > 
> > I have no idea either. Let's consider that if nobody on the list knows
> > how to do so, I'll merge it since you did not notice any regression.
> > 
> > Thanks,
> > Willy
> > 
> 
> Sorry... here you go.  Forgot to post this sooner.  I hit it with
> this on 2.6.x
> 
> #include <stdio.h>
> #include <sys/types.h>
> #include <sys/errno.h>
> 
> static int return_EIO(void)
> {
>         return -EIO;
> }
> 
> int main(int argc, char ** argv)
> {
> 	ssize_t error;
> 	ssize_t realerror = -EIO;
> 	ssize_t (*fn_ptr)(void);
> 
> 	fn_ptr = (void *)return_EIO;
> 
> 	error = (ssize_t)fn_ptr();
> 	printf("and... error is %ld, should be %ld\n", error, realerror);
> 	return 0;
> }

Thanks Eric. Sounds like my comment about exercising these code paths
wasn't too clear - the comments with your patch do make the issue
clear, and this program demonstrates the void cast promotion issue
well. I'm just not sure of a good way to demonstrate that my backport
of this patch doesn't break anything for 2.4.

-- 
dann frazier

